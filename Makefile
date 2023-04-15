CC := gcc # or clang
SUBDIRS := $(wildcard tree-sitter-*)
EXT := so # dylib on MacOS and dll on Windows
SRC_DIR := src
CPPFLAGS := -shared -fPIC -g -O2
# HOME is defined on Unix like systems
OUTPUT_DIR := $(HOME)/.emacs.d/tree-sitter
EXECS := $(patsubst %,$(OUTPUT_DIR)/lib%.$(EXT),$(SUBDIRS)) # tree-sitter-python -> libtree-sitter-python.so
# For each subdir, find the files in the source folder which are parser.c* or scanner.c*
FILES := $(foreach dir,$(SUBDIRS),$(wildcard $(dir)/$(SRC_DIR)/parser.c* $(dir)/$(SRC_DIR)/scanner.c*))

all: $(SUBDIRS)

$(SUBDIRS):
# Compiler + flags + include source + filter only files from current dir and output with correct extension
	$(CC) $(CPPFLAGS) -I$@/$(SRC_DIR) $(filter $@%,$(FILES)) -o $(OUTPUT_DIR)/lib$@.$(EXT)

clean:
	rm -f $(EXECS) # use the del command on DOS systems

# avoids considering all, clean or the subdirs as files and override targets
.PHONY:	all clean $(SUBDIRS)
