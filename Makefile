# Makefile
# See LICENSE file for copyright and license information
#
# Doing a `make all` does the following:
#   - converts all .adoc files to .html files using asciidoc
#   - removes noscript tags from .html files using phantomjs
#   - converts all .html files to .pdf files using weasyprint
#

ADOCS=$(wildcard *.adoc)
HTMLS=$(ADOCS:.adoc=.html)
PDFS=$(HTMLS:.html=.pdf)

TMPFILE := $(shell mktemp -u XXXXXXXX.html)

all : $(PDFS) $(HTMLS)

clean :
	$(RM) $(PDFS) $(HTMLS)

%.pdf : %.html
	weasyprint $< $@

%.html : %.adoc
#	asciidoc -a linkcss -a stylesdir=css -b html5 -o $@ $<
	asciidoc \
    -a icons -a data-uri \
    -a linkcss -a stylesdir=css -a scriptsdir=js \
    -a revnumber=`git log -n 1 --format=format:"%h" HEAD -p -- $< | head -1` \
    -a revdate=`git log -n 1 --date=short --format=format:"%ad" HEAD -p -- $< | head -1` \
    -b html5 -o $@ $<
