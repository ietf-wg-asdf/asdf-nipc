DOCS=	draft-ietf-asdf-nipc.txt \
	draft-ietf-asdf-nipc.xml \
	draft-ietf-asdf-nipc.html

FTXT=

YAML=  nipc-openapi/NIPC.yaml

all: $(DOCS)

%.xml:	%.mkd $(YAML)
	kramdown-rfc2629 $< > $@

%.html:	%.xml
	xml2rfc --html $<

%.txt:	%.xml
	xml2rfc --text $<

%.ftxt: %.json $(JSON)
	python3 fold.py < $< > $@
