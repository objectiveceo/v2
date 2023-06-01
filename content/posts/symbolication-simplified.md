---
date: 2021-05-16 20:01:26
slug: symbolication-simplified
title: "Symbolication Simplified"
summary: |
  Earlier this week, I was explaining the importance of the dSYM folder and why we had to upload it with our binary to one of my reports.  I realized that the whole notion of symbolication was foreign to her because we've abstracted everything away and she never had to deal with any of it.  I put together something to share with my team on what symbolication is, why it's important, and the need for the dSYM folder (and similar symbolication artifacts for other platforms).
---
First things first, all of the necessary code has been uploaded to [Github](https://github.com/objectiveceo/simple-symbolication).  You're welcome to clone that repo and work along with me.

Second, compilers may change over time.  I expect that the general commands that I present will work, but some of the details (like memory offsets) will change.  If you're the follow-along type while also being a copy-and-paste type, you should pay careful attention to the parts that I highlight.

# What are symbols?

In general programming utilizaton, "symbols" have a canonical meaning of [something with a human readable form](https://en.wikipedia.org/wiki/Symbol_(programming)).  I just say that it's "something with a name."  In our example [foo](https://github.com/objectiveceo/simple-symbolication/blob/4c1b956181e8e80e9a16f9077ae90255839cc7c2/example.swift#L1), [bar](https://github.com/objectiveceo/simple-symbolication/blob/4c1b956181e8e80e9a16f9077ae90255839cc7c2/example.swift#L6), and [baz](https://github.com/objectiveceo/simple-symbolication/blob/4c1b956181e8e80e9a16f9077ae90255839cc7c2/example.swift#L11) are all function objects that have names.  You could declare a function object without a name using Swift's closure syntax.  That happens all the time with the trailing closure syntax:

	func do(something: () -> Void) {
		something()
	}

	do() { /* Trailing closure, no name! */
		print("Doing")
	}

In the case above, that trailing closure *isn't a symbol*.  It doesn't have a name.  That's important because symbolication is the process of re-applying names to something that had their name taken away.  Before we get to that, let's talk about removing symbol names.

# Stacktraces and effective debugging

Let's go back and compile our [example](https://github.com/objectiveceo/simple-symbolication/blob/4c1b956181e8e80e9a16f9077ae90255839cc7c2/example.swift) script.

	xcrun swiftc example.swift -o a.out

This isn't *quite* the simplest way to compile a Swift program (you can drop the "-o" flag), but it's close.  You might notice that our code has a [crash](https://github.com/objectiveceo/simple-symbolication/blob/4c1b956181e8e80e9a16f9077ae90255839cc7c2/example.swift#L13-L14).  Let's run the application.

	➜  simple-symbolication git:(main) ✗ ./a.out 
	foo
	bar
	baz
	Fatal error: Unexpectedly found nil while unwrapping an Optional value
	[1]    53169 illegal hardware instruction  ./a.out

Yep.  That's exactly we'd expect.  Now, let's debug it.

	➜  simple-symbolication git:(main) ✗ xcrun lldb a.out
	(lldb) target create "a.out"
	Current executable set to 'a.out' (x86_64).
	(lldb) process launch
	Process 53241 launched: '/Volumes/Data/Users/objceo/Projects/objectiveceo/simple-symbolication/a.out' (x86_64)
	foo
	bar
	baz
	Process 53241 stopped
	* thread #1, queue = 'com.apple.main-thread', stop reason = Fatal error: Unexpectedly found nil while unwrapping an Optional value
		frame #0: 0x00000001003a9b90 libswiftCore.dylib"_swift_runtime_on_report
	libswiftCore.dylib"_swift_runtime_on_report:
	->  0x1003a9b90 <+0>: pushq  %rbp
		0x1003a9b91 <+1>: movq   %rsp, %rbp
		0x1003a9b94 <+4>: popq   %rbp
		0x1003a9b95 <+5>: retq   
	Target 0: (a.out) stopped.
	(lldb) thread backtrace
	* thread #1, queue = 'com.apple.main-thread', stop reason = Fatal error: Unexpectedly found nil while unwrapping an Optional value
	* frame #0: 0x00000001003a9b90 libswiftCore.dylib"_swift_runtime_on_report
		frame #1: 0x00000001003fb5b1 libswiftCore.dylib"_swift_stdlib_reportFatalError + 113
		frame #2: 0x00000001001031da libswiftCore.dylib"function signature specialization <Arg[1] = [Closure Propagated : reabstraction thunk helper from @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> () to @escaping @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> (@out ()), Argument Types : [@callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> ()]> of generic specialization <()> of Swift.StaticString.withUTF8Buffer<A>((Swift.UnsafeBufferPointer<Swift.UInt8>) -> A) -> A + 58
		frame #3: 0x000000010038996e libswiftCore.dylib"partial apply forwarder for closure #2 (Swift.UnsafeBufferPointer<Swift.UInt8>) -> () in Swift._fatalErrorMessage(_: Swift.StaticString, _: Swift.StaticString, file: Swift.StaticString, line: Swift.UInt, flags: Swift.UInt32) -> Swift.Never + 110
		frame #4: 0x00000001001031da libswiftCore.dylib"function signature specialization <Arg[1] = [Closure Propagated : reabstraction thunk helper from @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> () to @escaping @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> (@out ()), Argument Types : [@callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> ()]> of generic specialization <()> of Swift.StaticString.withUTF8Buffer<A>((Swift.UnsafeBufferPointer<Swift.UInt8>) -> A) -> A + 58
		frame #5: 0x00000001002cb9a9 libswiftCore.dylib"function signature specialization <Arg[2] = Dead, Arg[3] = Dead> of Swift._fatalErrorMessage(_: Swift.StaticString, _: Swift.StaticString, file: Swift.StaticString, line: Swift.UInt, flags: Swift.UInt32) -> Swift.Never + 105
		frame #6: 0x0000000100102cb3 libswiftCore.dylib"Swift._fatalErrorMessage(_: Swift.StaticString, _: Swift.StaticString, file: Swift.StaticString, line: Swift.UInt, flags: Swift.UInt32) -> Swift.Never + 19
		frame #7: 0x0000000100000e8d a.out"baz() at example.swift:14
		frame #8: 0x0000000100000d24 a.out"bar() at example.swift:8
		frame #9: 0x0000000100000c64 a.out"foo() at example.swift:3
		frame #10: 0x0000000100000ba4 a.out"main at example.swift:17
		frame #11: 0x00007fff7b8b8015 libdyld.dylib"start + 1
	(lldb) quit
	Quitting LLDB will kill one or more processes. Do you really want to proceed: [Y/n] y

Okay.  So we're just running the same program in "lldb".  Once we've loaded the executable, we'll actually run it using "process launch".  When it crashes, our debugger will stop automatically.  We can get more information using "thread backtrace".  There's a stack trace that we should be familiar with!  Look at frames 7, 8, and 9!  There are our function names!

	➜  simple-symbolication git:(main) ✗ xcrun nm a.out
	0000000100000c70 t _$S1b3baryyF
	0000000100000d30 t _$S1b3bazyyF
	0000000100000bb0 t _$S1b3fooyyF
					U _$SSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC
					U _$SSSN
	0000000100000e90 t _$SSSSgWOy
					U _$Ss18_fatalErrorMessage__4file4line5flagss5NeverOs12StaticStringV_A2HSus6UInt32VtF
					U _$Ss27_allocateUninitializedArrayySayxG_BptBwlFyp_Tg5
					U _$Ss5print_9separator10terminatoryypd_S2StF
					U _$Ss5print_9separator10terminatoryypd_S2StFfA0_
					U _$Ss5print_9separator10terminatoryypd_S2StFfA1_
	0000000100000fb6 s ___swift_reflection_version
	0000000100000000 T __mh_execute_header
	0000000100000b90 T _main
					U _swift_bridgeObjectRelease
					U _swift_bridgeObjectRetain
					U dyld_stub_binder

If we were to run the "nm" tool, we'll see that the names of our functions are compiled into the binary!  How handy!

# Stripping for size

This looks fine and dandy for our small script, but imagine how many symbols are located in a full application.  Each class, method, enum, and function name are included with the binary.  Every symbol adds some extra size to your program but your users will never see them!  That's okay.  Symbol strippers have been making release builds of applications much smaller for decades.

	➜  simple-symbolication git:(main) ✗ xcrun strip a.out
	➜  simple-symbolication git:(main) ✗ xcrun nm a.out
					U _$SSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC
					U _$SSSN
					U _$Ss18_fatalErrorMessage__4file4line5flagss5NeverOs12StaticStringV_A2HSus6UInt32VtF
					U _$Ss27_allocateUninitializedArrayySayxG_BptBwlFyp_Tg5
					U _$Ss5print_9separator10terminatoryypd_S2StF
					U _$Ss5print_9separator10terminatoryypd_S2StFfA0_
					U _$Ss5print_9separator10terminatoryypd_S2StFfA1_
	0000000100000000 T __mh_execute_header
					U _swift_bridgeObjectRelease
					U _swift_bridgeObjectRetain
					U dyld_stub_binder

You'll notice that "foo", "bar", and "baz" do not exist in the names listed above!  They've been removed!

	➜  simple-symbolication git:(main) ✗ lldb a.out
	(lldb) target create "a.out"
	Current executable set to 'a.out' (x86_64).
	(lldb) pr la
	Process 53585 launched: '/Volumes/Data/Users/objceo/Projects/objectiveceo/simple-symbolication/a.out' (x86_64)
	foo
	bar
	baz
	Process 53585 stopped
	* thread #1, queue = 'com.apple.main-thread', stop reason = Fatal error: Unexpectedly found nil while unwrapping an Optional value
		frame #0: 0x00000001003a9b90 libswiftCore.dylib"_swift_runtime_on_report
	libswiftCore.dylib"_swift_runtime_on_report:
	->  0x1003a9b90 <+0>: pushq  %rbp
		0x1003a9b91 <+1>: movq   %rsp, %rbp
		0x1003a9b94 <+4>: popq   %rbp
		0x1003a9b95 <+5>: retq   
	Target 0: (a.out) stopped.
	(lldb) th b
	* thread #1, queue = 'com.apple.main-thread', stop reason = Fatal error: Unexpectedly found nil while unwrapping an Optional value
	* frame #0: 0x00000001003a9b90 libswiftCore.dylib"_swift_runtime_on_report
		frame #1: 0x00000001003fb5b1 libswiftCore.dylib"_swift_stdlib_reportFatalError + 113
		frame #2: 0x00000001001031da libswiftCore.dylib"function signature specialization <Arg[1] = [Closure Propagated : reabstraction thunk helper from @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> () to @escaping @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> (@out ()), Argument Types : [@callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> ()]> of generic specialization <()> of Swift.StaticString.withUTF8Buffer<A>((Swift.UnsafeBufferPointer<Swift.UInt8>) -> A) -> A + 58
		frame #3: 0x000000010038996e libswiftCore.dylib"partial apply forwarder for closure #2 (Swift.UnsafeBufferPointer<Swift.UInt8>) -> () in Swift._fatalErrorMessage(_: Swift.StaticString, _: Swift.StaticString, file: Swift.StaticString, line: Swift.UInt, flags: Swift.UInt32) -> Swift.Never + 110
		frame #4: 0x00000001001031da libswiftCore.dylib"function signature specialization <Arg[1] = [Closure Propagated : reabstraction thunk helper from @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> () to @escaping @callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> (@out ()), Argument Types : [@callee_guaranteed (@unowned Swift.UnsafeBufferPointer<Swift.UInt8>) -> ()]> of generic specialization <()> of Swift.StaticString.withUTF8Buffer<A>((Swift.UnsafeBufferPointer<Swift.UInt8>) -> A) -> A + 58
		frame #5: 0x00000001002cb9a9 libswiftCore.dylib"function signature specialization <Arg[2] = Dead, Arg[3] = Dead> of Swift._fatalErrorMessage(_: Swift.StaticString, _: Swift.StaticString, file: Swift.StaticString, line: Swift.UInt, flags: Swift.UInt32) -> Swift.Never + 105
		frame #6: 0x0000000100102cb3 libswiftCore.dylib"Swift._fatalErrorMessage(_: Swift.StaticString, _: Swift.StaticString, file: Swift.StaticString, line: Swift.UInt, flags: Swift.UInt32) -> Swift.Never + 19
		frame #7: 0x0000000100000e7d a.out"___lldb_unnamed_symbol4$$a.out + 349
		frame #8: 0x0000000100000d14 a.out"___lldb_unnamed_symbol3$$a.out + 180
		frame #9: 0x0000000100000c54 a.out"___lldb_unnamed_symbol2$$a.out + 180
		frame #10: 0x0000000100000b94 a.out"___lldb_unnamed_symbol1$$a.out + 20
		frame #11: 0x00007fff7b8b8015 libdyld.dylib"start + 1
	(lldb) q
	Quitting LLDB will kill one or more processes. Do you really want to proceed: [Y/n] y

In this case, we're using "lldb" to debug again.  We're taking advantage of LLDB's concise syntax to locate commands ("pr la", "th b", and "q").  But the main point is that we no longer see "foo", "bar", and "baz"!  Instead, we see "___lldb_unnamed_symbol<number>"!

This is great for our users!  They get a smaller binary and none of the symbols are included in the application.  They don't care about them and they don't have to pay the cost in terms of network bandwidth and disk space.

But we can't see what went wrong in our stack traces!  We need a way to get that info back.

# debugging SYMbols

Let's go ahead and rebuild the application, but also generate our debugging symbols while we're at it.

	➜  simple-symbolication git:(main) ✗ xcrun swiftc -g example.swift -o b.out
	example.swift:13:6: warning: variable 'x' was never mutated; consider changing to 'let' constant
			var x: String? = nil
			~~~ ^
			let

This time, it's very nearly the same, but we've compiled a new exectuable ("b.out") and also decided to output debugging symbols ("-g").  This creates a new folder called "b.out.dSYM".

	➜  simple-symbolication git:(main) ✗ ls b.out.dSYM/Contents/
	Info.plist Resources
	➜  simple-symbolication git:(main) ✗ ls b.out.dSYM/Contents/Resources/DWARF/b.out
	b.out.dSYM/Contents/Resources/DWARF/b.out

You can view the contents of this file using "dwarfdump".

	➜  simple-symbolication git:(main) ✗ xcrun dwarfdump b.out.dSYM/Contents/Resources/DWARF/b.out 
	----------------------------------------------------------------------
	File: b.out.dSYM/Contents/Resources/DWARF/b.out (x86_64)
	----------------------------------------------------------------------
	// more...

Rather than show the entirety of the output, I'd like to put it to specific usage.  You can take the information from the stack trace and locate specific information inside the DWARF symbols.

If we look back at "frame #7" of our "lldb" stacktrace, we can see an address-looking piece of information: "0x0000000100000e7d".  We can use that to look up information inside of the DWARF symbols folder:

	➜  simple-symbolication git:(main) ✗ xcrun dwarfdump --lookup=0x0000000100000e7d b.out.dSYM/Contents/Resources/DWARF/b.out
	----------------------------------------------------------------------
	File: b.out.dSYM/Contents/Resources/DWARF/b.out (x86_64)
	----------------------------------------------------------------------
	Looking up address: 0x0000000100000e7d in .debug_info... found!

	0x00000000: Compile Unit: length = 0x00000116  version = 0x0004  abbr_offset = 0x00000000  addr_size = 0x08  (next CU at 0x0000011a)

	0x0000000b: TAG_compile_unit [1] *
				AT_producer( "Apple Swift version 4.2.1 (swiftlang-1000.0.42 clang-1000.10.45.1) -emit-object -primary-file example.swift -emit-module-path <temporary-file> -emit-module-doc-path <temporary-file> -target x86_64-apple-darwin17.7.0 -enable-objc-interop -sdk /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -g -color-diagnostics -module-name b -o <temporary-file> -resource-dir /Library/Developer/CommandLineTools/usr/lib/swift" )
				AT_language( DW_LANG_Swift )
				AT_name( "/Volumes/Data/Users/objceo/Projects/objectiveceo/simple-symbolication/example.swift" )
				AT_stmt_list( 0x00000000 )
				AT_comp_dir( "/Volumes/Data/Users/objceo/Projects/objectiveceo/simple-symbolication" )
				AT_APPLE_flags( "-emit-object -primary-file example.swift -emit-module-path <temporary-file> -emit-module-doc-path <temporary-file> -target x86_64-apple-darwin17.7.0 -enable-objc-interop -sdk /Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk -g -color-diagnostics -module-name b -o <temporary-file> -resource-dir /Library/Developer/CommandLineTools/usr/lib/swift" )
				AT_APPLE_major_runtime_vers( 0x04 )
				AT_low_pc( 0x0000000100000b90 )
				AT_high_pc( 0x000002ff )

	0x00000093:     TAG_subprogram [4] *
					AT_low_pc( 0x0000000100000d30 )
					AT_high_pc( 0x0000015f )
					AT_frame_base( rbp )
					AT_linkage_name( "$S1b3bazyyF" )
					AT_name( "baz" )
					AT_decl_file( "/Volumes/Data/Users/objceo/Projects/objectiveceo/simple-symbolication/example.swift" )
					AT_decl_line( 11 )
					AT_type( {0x0000010e} ( $SytD ) )
					AT_external( true )

	0x000000b0:         TAG_lexical_block [5] *
						AT_low_pc( 0x0000000100000d42 )
						AT_high_pc( 0x0000014d )
	Line table file: 'example.swift' line 14, column 9 with start address 0x0000000100000e2e

There's a lot to learn from this.  First, you might notice that I haven't updated to a more modern version of Swift.  That's okay, I'm writing from my personal laptop and not my professional one.  I haven't upgraded to the latest macOS there so don't read too much into it.  This works on the latest versions of Apple's Swift compiler, I promise you.

Second, you might notice that there's a *lot* of information here!  It tells us the linkage name.  It gives us a nicer, human-legible name.  There's even information about where the file existed on disk when it was compiled!

# Filling in the blanks

With the information above, we can achieve two goals:

1. Deliver the most efficient binary to our users.
2. Provide vital information to our developers in the face of crashes and stack traces.

With the debugging symbols, we can "rehydrate" our stack traces from the addresses that we have.  We'll be able to deliver a small, efficient binary to our users and fill in information gaps if/when we get crash reports back.

Tools like Apple's dev portal and Microsoft's AppCenter can automatically fill in the details for you.  You merely need to upload your dSYM folders with your binary and they'll take care of the rest.  That's very handy and I highly recommend that you take advantage of those tools.  This is just a quick post to expose where that information comes from and the importance of the dSYM folder.
