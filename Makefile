YAML_SOURCES= nipc-openapi/NIPC.yaml \
	nipc-openapi/extensions/Extension-Blob.yaml \
	nipc-openapi/extensions/Extension-Bulk.yaml \
	nipc-openapi/extensions/Extension-File.yaml \
	nipc-openapi/extensions/Extension-Property.yaml \
	nipc-openapi/extensions/Extension-ReadConditional.yaml \
	nipc-openapi/extensions/Extension-EventConditional.yaml \
	nipc-openapi/protocolmaps/ProtocolMap-BLE.yaml \
	nipc-openapi/protocolmaps/ProtocolMap-Zigbee.yaml \
	nipc-openapi/protocolmaps/ProtocolMap.yaml \
	nipc-openapi/protocolinfo/ProtocolInfo-BLE.yaml \
	nipc-openapi/protocolinfo/ProtocolInfo-Zigbee.yaml \
	nipc-openapi/protocolinfo/ProtocolInfo.yaml

YAML_FOLDED= $(YAML_SOURCES:.yaml=.yaml.folded)

# API Schema CDDL files (to be combined)
CDDL_API_SOURCES= \
	cddl/api/action_response.cddl \
	cddl/api/action.cddl \
	cddl/api/data_app.cddl \
	cddl/api/event_status_array.cddl \
	cddl/api/failure_response.cddl \
	cddl/api/group_event_status_response_array.cddl \
	cddl/api/trigger_status_array.cddl \
	cddl/api/property_value_array.cddl \
	cddl/api/property_value_read_response_array.cddl \
	cddl/api/property_value_response_array.cddl \
	cddl/api/sdf_reference.cddl \
	cddl/api/connection.cddl

# Other CDDL files (not included in combined)
CDDL_OTHER_SOURCES= \
	cddl/data_subscription.cddl \
	cddl/nipc_well_known.cddl

CDDL_SOURCES= $(CDDL_API_SOURCES) $(CDDL_OTHER_SOURCES)

CDDL_FOLDED= $(CDDL_SOURCES:.cddl=.cddl.folded)

CDDL_COMBINED= cddl/api/combined.cddl
CDDL_COMBINED_FOLDED= cddl/api/combined.cddl.folded

DOCS= draft-ietf-asdf-nipc.txt \
	draft-ietf-asdf-nipc.xml \
	draft-ietf-asdf-nipc.html

all: $(DOCS)

$(DOCS): $(YAML_FOLDED) $(CDDL_FOLDED) $(CDDL_COMBINED_FOLDED)

# Combine API CDDL files into one
$(CDDL_COMBINED): $(CDDL_API_SOURCES)
	@echo "; This file is auto-generated from individual NIPC API CDDL files" > $@
	@echo "" >> $@
	@for file in $(CDDL_API_SOURCES); do \
		echo "; ============================================" >> $@; \
		echo "; From: $$file" >> $@; \
		echo "; ============================================" >> $@; \
		cat $$file >> $@; \
		echo "" >> $@; \
	done

# Ensure the rfcfold submodule is initialized
rfcfold/rfcfold:
	git submodule update --init rfcfold

%.yaml.folded: %.yaml rfcfold/rfcfold
	./rfcfold/rfcfold -i $< -o $@ || [ $$? -eq 255 ]

%.cddl.folded: %.cddl rfcfold/rfcfold
	./rfcfold/rfcfold -i $< -o $@ || [ $$? -eq 255 ]

%.html %.txt %.xml:	%.mkd $(YAML_FOLDED) $(CDDL_FOLDED)
	kdrfc -3 -h $<

clean:
	rm -f $(DOCS) $(YAML_FOLDED) $(CDDL_FOLDED) $(CDDL_COMBINED) $(CDDL_COMBINED_FOLDED)

.PHONY: all clean
