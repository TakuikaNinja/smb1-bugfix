#!/bin/sh

# sha256sum of original nointro disk (will likely never match because the file structure differs)
ORIG="56ba4c39fd7f9628bffac4c6ee0d5364f86de36d27c904ffc70f0abc97ae0d3a"

# place original nointro disk in bin folder for xdelta patch generation
ORIG_PATH="bin/Super Mario Bros. (Japan).fds"


compareHash() {
	echo $1 $2 | sha256sum --check > /dev/null 2>&1
}

build() {
	./asm6f smb1.asm -n -c -L bin/smb1.fds "$@" > bin/assembler.log
}



if [ "$1" = "patch" ] ; then

	echo 'Assembling...'
	build

	if [ $? -ne 0 ] ; then
		echo 'Failed building disk!'
		exit 1
	elif ! compareHash $ORIG 'bin/smb2.fds' ; then
		echo 'Did not match original disk - Generating xdelta patch...'
		xdelta3 -fs "$ORIG_PATH" bin/smb1.fds bin/smb1-bugfix-fds.xdelta || echo 'Failed to generate xdelta patch'
		exit $?
	else
		echo 'Matched original disk - No patches required'
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

if compareHash $ORIG 'bin/smb1.fds' -eq 0 ; then
	echo 'Matched original disk'
	exit 0
else
	echo 'Did not match original disk'
	exit -1
fi



