#!/usr/bin/make -f
# Makefile for DISTRHO Plugins #
# ---------------------------- #
# Created by falkTX
#

include dpf/Makefile.base.mk

all: dgl plugins resources gen

# --------------------------------------------------------------
# Check for system-wide projectM

HAVE_PROJECTM = $(shell pkg-config --exists libprojectM && echo true)

# --------------------------------------------------------------

dgl:
	$(MAKE) -C dpf/dgl opengl3 FILE_BROWSER_DISABLED=true

plugins: dgl
	$(MAKE) all -C plugins/ProM

ifneq ($(HAVE_PROJECTM),true)
resources: gen
	# LV2 fonts
	install -d bin/ProM.lv2/resources/fonts
	ln -sf $(CURDIR)/plugins/ProM/projectM/fonts/*.ttf bin/ProM.lv2/resources/fonts/
	# LV2 presets
	install -d bin/ProM.lv2/resources/presets
	ln -sf $(CURDIR)/plugins/ProM/projectM/presets/presets_* bin/ProM.lv2/resources/presets/

ifeq ($(MACOS),true)
	# VST2 fonts
	install -d bin/ProM.vst/Contents/Resources/fonts
	ln -sf $(CURDIR)/plugins/ProM/projectM/fonts/*.ttf bin/ProM.vst/Contents/Resources/fonts/
	# VST2 presets
	install -d bin/ProM.vst/Contents/Resources/presets
	ln -sf $(CURDIR)/plugins/ProM/projectM/presets/presets_* bin/ProM.vst/Contents/Resources/presets/
else
	# VST2 fonts
	install -d bin/ProM.vst/resources/fonts
	ln -sf $(CURDIR)/plugins/ProM/projectM/fonts/*.ttf bin/ProM.vst/resources/fonts/
	# VST2 presets
	install -d bin/ProM.vst/resources/presets
	ln -sf $(CURDIR)/plugins/ProM/projectM/presets/presets_* bin/ProM.vst/resources/presets/
endif

	# VST3 fonts
	install -d bin/ProM.vst3/Contents/Resources/fonts
	ln -sf $(CURDIR)/plugins/ProM/projectM/fonts/*.ttf bin/ProM.vst3/Contents/Resources/fonts/
	# VST3 presets
	install -d bin/ProM.vst3/Contents/Resources/presets
	ln -sf $(CURDIR)/plugins/ProM/projectM/presets/presets_* bin/ProM.vst3/Contents/Resources/presets/
else
resources:
endif

ifneq ($(CROSS_COMPILING),true)
gen: plugins dpf/utils/lv2_ttl_generator
	@$(CURDIR)/dpf/utils/generate-ttl.sh

dpf/utils/lv2_ttl_generator:
	$(MAKE) -C dpf/utils/lv2-ttl-generator
else
gen:
endif

# --------------------------------------------------------------

clean:
	$(MAKE) clean -C dpf/dgl
	$(MAKE) clean -C dpf/utils/lv2-ttl-generator
	$(MAKE) clean -C plugins/ProM
	rm -rf bin build

# --------------------------------------------------------------

.PHONY: plugins
