all: patch

.PHONY: patch crates check clean-patch clean-html clean-svd clean lint mmaps
.PRECIOUS: svd/%.svd .deps/%.d

SHELL := /usr/bin/env bash

# Path to `svd`/`svdtools`
SVDTOOLS ?= svd


CRATES ?= mspm0l110x mspm0l130x mspm0l134x mspm0g110x mspm0g150x mspm0g310x mspm0g350x mspm0c110x msps003fx

# All yaml files in devices/ will be used to patch an SVD
YAMLS := $(foreach crate, $(CRATES), \
	       $(wildcard devices/$(crate)*.yaml))

# Each yaml file in devices/ exactly name-matches an SVD file in svd/
PATCHED_SVDS := $(patsubst devices/%.yaml, svd/%.svd.patched, $(YAMLS))
FORMATTED_SVDS := $(patsubst devices/%.yaml, svd/%.svd.formatted, $(YAMLS))

# Each yaml file also corresponds to a mmap in mmaps/
MMAPS := $(patsubst devices/%.yaml, mmaps/%.mmap, $(YAMLS))

# Turn a devices/device.yaml and svd/device.svd into svd/device.svd.patched
svd/%.svd.patched: devices/%.yaml svd/%.svd .deps/%.d
	$(SVDTOOLS) patch $<
	scripts/ti_patch_dimarrayindex.py $@

svd/%.svd.formatted: svd/%.svd.patched
	xmllint $< --format -o $@

# Generate mmap from patched SVD
mmaps/%.mmap: svd/%.svd.patched
	@mkdir -p mmaps
	$(SVDTOOLS) mmap $< > $@

patch: $(PATCHED_SVDS)

svdformat: $(FORMATTED_SVDS)

html/index.html: $(PATCHED_SVDS) scripts/makehtml.py scripts/makehtml.index.template.html scripts/makehtml.template.html
	@mkdir -p html
	python3 scripts/makehtml.py html/ $(PATCHED_SVDS)

html/comparisons.html: $(PATCHED_SVDS) scripts/htmlcomparesvdall.sh scripts/htmlcomparesvd.py
	scripts/htmlcomparesvdall.sh

html: html/index.html html/comparisons.html

lint: $(PATCHED_SVDS)
	xmllint --schema svd/cmsis-svd.xsd --noout $(PATCHED_SVDS)

mmaps: $(MMAPS)

clean-patch:
	rm -f $(PATCHED_SVDS)
	rm -f $(FORMATTED_SVDS)

clean-html:
	rm -rf html

clean: clean-patch clean-html clean-svd
	rm -rf .deps

# As alternative to `pip install --user svdtools`:
# run `make venv update-venv` and `source venv/bin/activate'
venv:
	python3 -m venv venv

update-venv:
	venv/bin/pip install -U pip
	venv/bin/pip install -U -r requirements.txt

install:
	scripts/tool_install.sh

# Generate dependencies for each device YAML
.deps/%.d: devices/%.yaml
	@mkdir -p .deps
	$(SVDTOOLS) makedeps $< $@

-include .deps/*
