#!/bin/sh

# sha256sum of original nointro ROM w/ NES2.0 header
ORIG="0b3d9e1f01ed1668205bab34d6c82b0e281456e137352e4f36a9b2cfa3b66dea"

# place original nointro ROM in bin folder for BPS patch generation
ORIG_PATH="bin/Super Mario Bros. (World).nes"


compareHash() {
	echo $1 $2 | sha256sum --check > /dev/null 2>&1
}

build() {
	echo 'Assembling...'
	asm6f smb1.asm -n -c -L -m bin/smb1.nes > bin/assembler.log || return 1
	echo 'Generating Nintendo header...'
	./sssfix.py bin/smb1.nes -t "SUPER MARIO" -l 1
}



if [ "$1" = "patch" ] ; then
	build

	if [ $? -ne 0 ] ; then
		echo 'Failed building ROM!'
		exit 1
	elif ! compareHash $ORIG 'bin/smb1.nes' ; then
		echo 'Did not match original ROM - Generating BPS patch...'
		flips -c -b "$ORIG_PATH" bin/smb1.nes bin/smb1-bugfix-nes.bps || echo 'Failed to generate BPS patch'
		exit $?
	else
		echo 'Matched original ROM - No patches required'
		exit 0
	fi

fi

build

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



