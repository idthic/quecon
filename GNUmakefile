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

install_files += $(INSDIR)/bin/idtsub
install_files += $(INSDIR)/share/idtsub/template/sub.sh
install_files += $(INSDIR)/share/idtsub/template/job.sh
$(INSDIR)/bin/idtsub: idtsub
	@$(MKTOOL) install $< $@
$(INSDIR)/share/idtsub/template/sub.sh: template/sub.sh
	@$(MKTOOL) install $< $@
$(INSDIR)/share/idtsub/template/job.sh: template/job.sh
	@$(MKTOOL) install $< $@

install: $(install_files)
.PHONY: install
