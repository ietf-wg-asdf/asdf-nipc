YAML_SOURCES= nipc-openapi/NIPC.yaml \
	nipc-openapi/extensions/Extension-Blob.yaml \
	nipc-openapi/extensions/Extension-Bulk.yaml \
	nipc-openapi/extensions/Extension-File.yaml \
	nipc-openapi/extensions/Extension-Property.yaml \
	nipc-openapi/extensions/Extension-ReadConditional.yaml \
	nipc-openapi/protocolmaps/ProtocolMap-BLE.yaml \
	nipc-openapi/protocolmaps/ProtocolMap-Zigbee.yaml \
	nipc-openapi/protocolmaps/ProtocolMap.yaml

YAML_FOLDED= $(YAML_SOURCES:.yaml=.yaml.folded)

DOCS= draft-ietf-asdf-nipc.txt \
	draft-ietf-asdf-nipc.xml \
	draft-ietf-asdf-nipc.html

all: $(DOCS)

$(DOCS): $(YAML_FOLDED)

# Ensure the rfcfold submodule is initialized
rfcfold/rfcfold:
	git submodule update --init rfcfold

%.yaml.folded: %.yaml rfcfold/rfcfold
	./rfcfold/rfcfold -i $< -o $@ || [ $$? -eq 255 ]

%.html %.txt %.xml:	%.mkd $(YAML_FOLDED)
	kdrfc -3 -h $<

clean:
	rm -f $(DOCS) $(YAML_FOLDED)

.PHONY: all clean

