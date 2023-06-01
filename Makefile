dummy:

build:
	HUGO_ENV=production hugo

deploy: build
	rsync -av public/ objceo:objectiveceo/v2/

syncnginx:
	scp objectiveceo.conf objceo:objectiveceo/v2.objectiveceo.conf
	ssh objceo "docker stop ngx && ./bin/rebuildNginx.sh"
