#!/bin/bash

# Run clean darkrp server with ulx admin mode

# git clone https://github.com/AMD-NICK/docker-garrysmod-server.git gmod-docker
# cd gmod-docker
# sh start.sh

mkdir -p addons data luabin gmas
touch sv.db
chown 1000:1000 sv.db data/ gmas/

if [ ! -d "darkrp" ]; then
	echo "Installing DarkRP"
	git clone https://github.com/FPtje/DarkRP.git darkrp
fi

if [ ! -d "addons/ulx_ulib" ]; then
	echo "Installing Ulx and Ulib"

	mkdir -p tmp/ulx_ulib
	cd tmp

	git clone 'https://github.com/TeamUlysses/ulx.git'
	git clone 'https://github.com/TeamUlysses/ulib.git'

	cp -r 'ulx/lua' ulx_ulib/
	cp -r 'ulib/lua' ulx_ulib/

	mv ulx_ulib/ ../addons

	cd ..
	rm -rf tmp
fi

docker compose up --force-recreate
