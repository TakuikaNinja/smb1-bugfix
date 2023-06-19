#!/bin/sh

# sha256sum of original nointro ROM w/ NES2.0 header
ORIG="0b3d9e1f01ed1668205bab34d6c82b0e281456e137352e4f36a9b2cfa3b66dea"

# place original nointro ROM in bin folder for xdelta patch generation
ORIG_PATH="bin/Super Mario Bros. (World).nes"


compareHash() {
	echo $1 $2 | sha256sum --check > /dev/null 2>&1
}

build() {
	./asm6f smb1.asm -n -c -L bin/smb1.nes "$@" > bin/assembler.log
}



if [ "$1" = "patch" ] ; then

	echo 'Assembling...'
	build

	if [ $? -ne 0 ] ; then
		echo 'Failed building ROM!'
		exit 1
	elif ! compareHash $ORIG 'bin/smb2.nes' ; then
		echo 'Did not match original ROM - Generating xdelta patch...'
		xdelta3 -fs "$ORIG_PATH" bin/smb1.nes bin/smb1-bugfix.xdelta || echo 'Failed to generate xdelta patch'
		exit $?
	else
		echo 'Matched original ROM - No patches required'
		exit 0
	fi

fi

echo 'Assembling...'
build $@

if [ $? -ne 0 ] ; then
	echo 'Build failed!'
	exit 1
fi

echo 'Build succeeded.'

if compareHash $ORIG 'bin/smb1.nes' -eq 0 ; then
	echo 'Matched original ROM'
	exit 0
else
	echo 'Did not match original ROM'
	exit -1
fi



