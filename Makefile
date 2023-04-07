MODULE = matrix

SRCDIR = src/bin
SRCS = $(SRCDIR)/$(MODULE).c
JSEXT = mjs

all: public/$(MODULE).wasm

public/$(MODULE).wasm: $(SRCDIR)/$(MODULE).$(JSEXT)

$(SRCDIR)/$(MODULE).$(JSEXT): $(SRCS)
	emcc --no-entry $(SRCS) -o $(SRCDIR)/$(MODULE).$(JSEXT)  \
	  --pre-js $(SRCDIR)/locateFile.js  \
	  -s ENVIRONMENT='web'  \
	  -s EXPORT_NAME='createModule'  \
	  -s USE_ES6_IMPORT_META=0  \
	  -s EXPORTED_FUNCTIONS='["_add", "_matrixMultiply", "_malloc", "_free"]'  \
	  -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]'  \
		-s ASSERTIONS \
	  -O3
	mv $(SRCDIR)/$(MODULE).wasm public/$(MODULE).wasm

.PHONY: clean
clean:
	rm public/$(MODULE).wasm $(SRCDIR)/$(MODULE).$(JSEXT)

.PHONY: re
re: clean all