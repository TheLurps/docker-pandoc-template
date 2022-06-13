BIB_FILES := $(shell find . -iname "*.bib")
MD_FILES := $(wildcard *.md)
DEFAULTS := 'pandoc.yml'

$(subst .md,-$(VERSION).pdf,$(MD_FILES)):
	@if [ -z $(TEMPLATE) ] && [ -z $(TO) ]; then\
		pandoc $(subst -$(VERSION).pdf,.yml,$@) $(subst -$(VERSION).pdf,.md,$@) \
		--defaults $(DEFAULTS) \
		--bibliography $(BIB_FILES) \
		--output $@;\
	elif [ -z $(TEMPLATE) ]; then\
		pandoc $(subst -$(VERSION).pdf,.yml,$@) $(subst -$(VERSION).pdf,.md,$@) \
		--defaults $(DEFAULTS) \
		--bibliography $(BIB_FILES) \
		--to $(TO) \
		--output $@;\
	elif [ -z $(TO) ]; then\
		pandoc $(subst -$(VERSION).pdf,.yml,$@) $(subst -$(VERSION).pdf,.md,$@) \
		--defaults $(DEFAULTS) \
		--bibliography $(BIB_FILES) \
		--template $(TEMPLATE) \
		--output $@;\
	else\
		pandoc $(subst -$(VERSION).pdf,.yml,$@) $(subst -$(VERSION).pdf,.md,$@) \
		--defaults $(DEFAULTS) \
		--bibliography $(BIB_FILES) \
		--template $(TEMPLATE) \
		--to $(TO) \
		--output $@;\
	fi

all:  $(subst .md,-$(VERSION).pdf,$(MD_FILES))

default: all

clean:
	-rm $(subst .md,-$(VERSION).pdf,$(MD_FILES))
