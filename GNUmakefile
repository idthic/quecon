# -*- mode: makefile-gmake -*-

all:
.PHONY: all

PREFIX := $(HOME)/.opt/idt
INSDIR := $(DESTDIR)$(PREFIX)

ifneq ($(V),)
  VERBOSE := 1
endif
export VERBOSE
MKTOOL := bash mktool.sh

install_files += $(INSDIR)/bin/quecon
install_files += $(INSDIR)/share/quecon/template/sub.sh
install_files += $(INSDIR)/share/quecon/template/node.sh
install_files += $(INSDIR)/share/quecon/template/work.sh
$(INSDIR)/bin/quecon: quecon
	@$(MKTOOL) install $< $@
$(INSDIR)/share/quecon/template/sub.sh: template/sub.sh
	@$(MKTOOL) install $< $@
$(INSDIR)/share/quecon/template/node.sh: template/node.sh
	@$(MKTOOL) install $< $@
$(INSDIR)/share/quecon/template/work.sh: template/work.sh
	@$(MKTOOL) install $< $@

install: $(install_files)
.PHONY: install
