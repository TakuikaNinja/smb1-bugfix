GAME=smb1
FORMAT=fds
DIR=bin
OUTPUT=$(DIR)/$(GAME).$(FORMAT)
PATCH=$(DIR)/$(GAME)-bugfix-$(FORMAT).bps
ASSEMBLER=asm6f
FLAGS=-n -c -L -m

# place original nointro dumps in bin folder for BPS patch generation
ifeq ($(FORMAT),nes)
ORIG_PATH="bin/Super Mario Bros. (World).nes"
else ifeq ($(FORMAT),fds)
ORIG_PATH="bin/Super Mario Bros. (Japan).fds"
else
$(error invalid format $(FORMAT))
endif

all: clean $(OUTPUT) patch

$(OUTPUT) :
	$(ASSEMBLER) $(GAME).asm $(FLAGS) $(OUTPUT) > $(DIR)/assembler.log
ifeq ($(FORMAT),nes)
	./sssfix.py $(OUTPUT) -t "SUPER MARIO" -l 1
endif

# flips will detect if the files are identical anyway, so...
patch:
	flips -c -b $(ORIG_PATH) $(OUTPUT) $(PATCH)

.PHONY: clean

clean:
	rm -f *.lst $(OUTPUT) $(PATCH) $(DIR)/*.log $(DIR)/*.nl $(DIR)/*.mlb

