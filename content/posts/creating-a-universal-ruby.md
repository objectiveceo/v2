---
date: 2023-04-20 18:24:33
slug: creating-a-universal-ruby
title: "Creating a Universal Ruby"
summary: |
  I recently had to create a universal build of Ruby.  In the process, I had to create many other universal libraries.  This is a brief look at how to create them via many means.
---
I recently had an opportunity to create a Universal build of Ruby.  A "universal" build is also often called a "fat" build, but we won't use that nomenclature.  I mention just so there's no confusion.  Universal builds are so named because they should run on any CPU architecture for any given OS.  In this case, I needed Ruby to run on modern Apple Silicon and under Rosetta (x86_64 CPU architecture) emulation.  This isn't commonly needed, so I don't recommend this for anyone apart from having good business case for it.  But I did.  And I figured I'd share the journey in case anyone else finds themselves in a similar situation.

The tactics here cross many different methodologies, so it's not limited to just building Ruby.  Ruby, like many modern applications, has a few dependencies.  In order to build a properly Universal final build of Ruby, you need to build Universal versions of each dependent library.  In this case, each one had a slightly different means of creating that Universal build.

First things first, the technical details are encoded in [this repository](https://github.com/Grayson/universal-ruby).

## Two Ways to Build Ruby

Ruby is available via source in two ways.  There's a [git repo](https://github.com/ruby/ruby) and there are [source distros](https://www.ruby-lang.org/en/downloads/).  The source distros have a bit of preprocessing and represent a state of Ruby at a specific point in time.  Unless you need to live at head, the source distros are probably the right call.

For the vast majority of user cases, we probably won't care about either.  Instead, we'll use community-provided tools such as [ruby-build](https://github.com/rbenv/ruby-build).  "ruby-build" is used by tools such as ["rbenv"](https://github.com/rbenv/rbenv) and ["asdf"](https://asdf-vm.com) under the hood.

I mention because, when we get into the weeds, we'll be configuring "ruby-build" to behave the way we want rather than building from source.

## "CFLAGS", the Easy (and Best) Way

Ruby depends on "libyaml".  That'll be the first dependency that we compile as Universal libraries.  It also comes [as a repo](https://github.com/yaml/libyaml) as well as [source distribution](https://pyyaml.org/wiki/LibYAML).  It uses a very familiar (for *nix users, at least) "./configure && make && make install" build system.

The canonical...-ish way to build C-based libraries with multiple architectures is to set the appropriate compiler flags.  For GCC-compatible compilers (including Clang), that means setting the "-arch" flag twice.  By default, the compiler will choose the "active" CPU architecture.  If you specify *one* architecture, it'll just build that one.  But if you specify *two or more*, it should build for all of them.  Handy!

I mention "active" because it'll come into play later.  If you build directly on Apple Silicon Macs, it'll choose "arm64" by default.  However, you can switch architectures by running in Rosetta emulation.  In those cases, it'll use "x86_64" CPU architecture.  Just... hold that thought in mind for the next dependency we build.

The whole configure/make/make install process doesn't expose the GCC-compatible command call directly, so we need to *push* our flags downstream somehow.  Fortunately, the standard process works with "configure" *most* of the time.  You can specify your GCC flags using variables such as "CFLAGS" [like so](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L67).  Now, when "make" calls the compiler, it'll pass those flags on the command.

Just like that... viola!  You'll have artifacts that contain both the "arm64" and "x86_64" symbols!

## "Symbols"?!  What is THAT?!

We should take a detour here and explain *why* we're doing this.

When you compile an app, what you're actually doing is taking code in a human-readable syntax (well, if you consider C, C++, Swift, Rust, and others actually readable) and turning it into a machine-readable artifact.  Not every machine speaks the same "language."  It depends on the CPU (and OS and, frankly, several other things that we'll ignore in this post for brevity) architecture.  "arm64" CPUs like in Apple Silicon devices don't speak the same language as "x86_64" CPUs (present in pre-Apple Silicon Macs.  "x86_64" Macs don't speak the same computer language as in those really old PPC Macs from decades ago.

When you compile your source code, the function and method names are stored in a special portion of the created artifact.  Each one is keyed by the CPU architecture.  So when your compile is *linking* your final binary, that is, looking up whatever it needs to make sure your apps *runs correctly*, it'll check to see if those functions and methods exist *for your architecture*.  

The function and methods names (and static/global variables and other items) are the "symbols" that the linker looks for.  However, it doesn't *just* check if something exists.  It checks to make sure it's *usable* for your intended CPU architecture.

### An Aside for How I got into this Mess

Ruby "gems" are their equivalent of "packages" in other languages.  When you install a gem, Ruby has the option to compile native code for your CPU.  By default, "ruby-build" (and, frankly, every other means of building Ruby) builds for your currently active CPU architecture.  However, if you need to do something like, say, run a Ruby built on Apple Silicon in Rosetta emulation, it won't find the symbols needed to build the gems.  "libruby.dylib" won't have the "x86_64" symbols in this case.  That means that gems will fail to install and builds will fail.

So, uh, don't get yourself into this situation if you can.

You might still need to create Universal binaries (Android apps, I'm looking *directly* at you), so some of this information might still be useful.

## What if CFLAGS fails?

Will "configure" fail to do the right thing?  It happened to me.  It can happen to you.

The GNU "readline" library is super common across a lot of applications.  It's used by Ruby.  The common distribution is [via source releases](https://ftp.gnu.org/gnu/readline/).

However, despite being old and such a stalwart library, I just could not figure out how to "configure" a Universal build.  That's okay.  I have other methods.

Remember how I mentioned the "active" architecture?  Well, that's what I leveraged here.  I first built a version for [arm64](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L89-L93) with a specific "prefix" (output location).  Then I [did it again](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L98-L100) under Rosetta emulation so the "active" architecture would be "x86_64".  Now I have *two* binaries.  Well, a lot more than that because there are multiple artifacts, but the point stands.  I had a problem.

Fortunately, Apple provides a utility for working with multiple CPU architectures called ["lipo"](https://ss64.com/osx/lipo.html) (remember the "fat" terminology above?).  In addition to diagnosing what architectures are available in a binary, it can *combine* multiple artifacts into a combined form.

We can leverage that to [create a universal build](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L112) from multiple builds.

Here, I should note that "lipo" does not care about symlinks.  Many libraries have an optimization where they can specify very specific artifacts.  "libfoo" might output a "libfoo.1.42.6.dylib" and symlink a less specific "libfoo.1.42.dylib" which is the same as a symlinked "libfoo.1.dylib" which is also symlinked to just "libfoo.dylib".  Rather than having multiple files on the file system, they're all just symlinked to the most specific version.  "lipo" will obliterate those symlinks and create multiple actual files.  For our purposes, they aren't large enough to be a problem, but it's worth mentioning.

## Some Libraries do their own thing

When it came to the OpenSSL distribution, it provides its own means of configuring for multiple CPUs.  That's a headache.  But it happens.  In these cases, you can just [build normally](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L140-L143) and then [build for a specific architecture](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L146-L149).  You can then do the same ["lipo" dance](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L160) to build your Universal binary.

If you're not familiary with "configure", you can often run "configure --help" and see most of the flags available to you.  Apart from that, research and good internet searching can guide you on the correct path.  Usually.  Good luck.

## Pulling it All Together for Ruby

Okay, so we have our dependencies built as Universal binaries.  The only thing left is to put it all together for Ruby.  Like OpenSSL, there's a special way to build Universal binaries using the "--with-arch" flag as a "CFLAG" option.  You can push that as well as paths to the dependencies by specifying the [correct "RUBY_CONFIGURE_OPTS" options](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/build_ruby.sh#L187).

And... that'll fail the build.

Specifically, (as of Ruby 3.2.2 which is what I was working on), you'll get the Ruby equivalent of a null reference exception.  This will happen because many versions of Ruby don't handle Universal builds well.  There's a regex that attempts to pull the architecture from build flags but [doesn't match multiple architectures](https://github.com/ruby/ruby/blob/5579cbe2dd6fda86d2c31c9c0a6ee4697fc31e26/tool/mkconfig.rb#L200).  Later versions of the code [add a fallback](https://github.com/ruby/ruby/blob/5579cbe2dd6fda86d2c31c9c0a6ee4697fc31e26/tool/mkconfig.rb#L201) (these are from the same modern version of Ruby, but illustrate the issue and I didn't backtrack to find the "broken" source code).

### Hijacking the Code

We just need to update the source.  If you're building from source, that's not too hard.  Just replace the file before you build.  If you're using "ruby-build", then you have a problem.  There's not a convenient way to replace the code between downloading and compiling.

My solution was to hijack the "make" phase.  "ruby-build" lets you do this to swap in a different version of "make" (such as GNU make) but I just used it to do a [just in time replacement](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/make-shim.sh#L7-L10) of the necessary code and forward on to standard "make".

### And It Still Fails

This was all good, but Ruby will fail at runtime when run in Rosetta emulation.  Specifically, it throws an exception complaining about the runtime.  I tracked it down to a [specific check](https://github.com/ruby/ruby/blob/5579cbe2dd6fda86d2c31c9c0a6ee4697fc31e26/compile.c#L13347-L13349).

At this point, I decided to punt.  Rather than do the work to figure out what this means and how to fix it, I decided to use the replacement trick above and [just comment that code out](https://github.com/Grayson/universal-ruby/blob/a5de487831ab92dd2ca9fd6671a1fec1d33812a1/bin/replacements/ruby/3.2.2/compile.c#L13249-L13251).  I probably should have spent more time evaluating this codepath and understanding how important it is.  For my purposes, though, this was a proof of concept that allowed my team to move on to the next phase.

## Finally, a universal Ruby

At this point, I finally had a universal build of Ruby.  It ran my meager tests natively and in Rosetta emulation.  I had done it.  For a specific version of Ruby at a specific time in development.  I have no idea how portable this version of Ruby actually is (Apple's codesigning requirements means that this "works on my machine" and that's good enough for me for now).  I also have no idea if this will work for past or future versions of Ruby (I've assumed the replacement files, at least, may need to be updated to be more contemporary).

In any case, this turned out to be a quick survey of various tactics of how to piece together universal binaries.  These types of antics may be less useful as Apple Silicon becomes more pervasive with age.  However, this knowledge will help address linking problems for many platforms in the future.  This may never go away completely, but at least there's a record that explains how it is done (although probably imperfectly!).
