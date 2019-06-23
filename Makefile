AUTHORS = $(shell head -1 LICENSE.txt |cut -d\  -f3-)

SRC = $(notdir $(wildcard src/*))
OBJ = build/obj/ecv.ins build/obj/ecv.dtx
DOC_PDF = build/doc/ecv.pdf
TEMPLATE_PDFS = $(patsubst %.tex,build/doc/%.pdf,$(notdir $(wildcard static/template/*.tex)))
LICENSE = build/dist/COPYING
ARCHIVE = dist/ecv.zip
LICENSE_TEXT = $(shell cat LICENSE.txt)

VPATH = src

LATEX = latexmk -latexoption=-interaction=nonstopmode -latexoption=-halt-on-error -pdf
MAKEDTX = build/tools/makedtx/makedtx.pl
MAKEDTX_ARCHIVE = makedtx-1_2.zip

default: compile

compile: $(OBJ) $(DOC_PDF) $(TEMPLATE_PDFS)

dist : $(ARCHIVE)

$(ARCHIVE) : $(OBJ) $(DOC_PDF) $(TEMPLATE_PDFS) $(LICENSE)
	mkdir -p build/dist
	cp -r static/* build/dist
	cp $(OBJ) $(DOC_PDF) build/dist
	mkdir -p build/dist/template
	cp $(TEMPLATE_PDFS) build/dist/template
	mkdir -p dist
	cd build/dist; zip -r ../../$@ *

# Extract makedtx.pl
$(MAKEDTX) : dependencies/$(MAKEDTX_ARCHIVE)
	mkdir -p build/tools
	cd build/tools; unzip -o ../../$<
	cd build/tools/makedtx; latex makedtx.ins

# build dtx and ins files
$(OBJ) : $(SRC) $(MAKEDTX)
	mkdir -p build/obj
	perl $(MAKEDTX) \
		-macrocode ".*" \
		-src "($(subst $() $(),|,$(SRC)))=>\1" \
		-dir "src" \
		-author "$(AUTHORS)" \
		-date "2006-$(shell date +%Y)" \
		-setambles ".*=>\nopreamble" \
		-doc "doc/ecv.tex" \
		-preamble "$(LICENSE_TEXT)" \
		ecv
	cat ecv.ins
	echo -e $$'/endbat/kx\nr patch/msg.txt\n\'xm $$\nwq' | ed -v -s ecv.ins
	cat ecv.ins
	mv $(notdir $(OBJ)) build/obj

# Build template PDFs
build/doc/%.pdf : static/template/%.tex
	mkdir -p build/doc
	cp $< build/doc
	cd build/doc; $(LATEX) $(notdir $<)

# Build Documentation PDF from ecv.dtx
$(DOC_PDF) : build/obj/ecv.dtx
	mkdir -p build/doc
	cp $< build/doc
	cd build/doc; $(LATEX) ecv.dtx

$(LICENSE) : LICENSE.txt
	mkdir -p build/dist
	cp $^ $@

clean:
	rm -rf build
	rm -rf dist

.PHONY: default compile dist clean