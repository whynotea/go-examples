PKG  := github.com/whynotea/go-examples
CLI_PLATFORMS ?= linux-amd64 windows-amd64

# Default to the native architecture type
NATIVE_GOOS := $(shell env -u GOOS go env GOOS)
NATIVE_GOARCH := $(shell env -u GOARCH go env GOARCH)
ARCH ?= $(NATIVE_GOOS)-$(NATIVE_GOARCH)

platform_temp = $(subst -, ,$(ARCH))
GOOS = $(word 1, $(platform_temp))
GOARCH = $(word 2, $(platform_temp))


# Dereference variable $(1), return value if non-empty, otherwise raise an error.
err_if_empty = $(if $(strip $($(1))),$(strip $($(1))),$(error Required variable $(1) value is undefined, whitespace, or empty))

PREFIX ?= /usr/local
RELEASE_PREFIX = /usr
BINDIR ?= ${PREFIX}/bin
ifeq ($(GOOS),windows)
BINSUFFIX=.exe
else
BINSUFFIX=
endif
# Conditional required to produce empty-output if binary not built yet.
RELEASE_VERSION = $(shell if test -x test/version/version; then test/version/version; fi)
RELEASE_NUMBER = $(shell echo "$(call err_if_empty,RELEASE_VERSION)" | sed -e 's/^v\(.*\)/\1/')

.PHONY: default
default: all

.PHONY: all
all:
	@$(MAKE) build BIN=basic

.PHONY: all-platforms
all-platforms: $(addprefix build-,$(CLI_PLATFORMS))

build-%:
	@$(MAKE) --no-print-directory ARCH=$* build BIN=basic

build: _build/bin/$(GOOS)/$(GOARCH)/$(BIN)

_build/bin/$(GOOS)/$(GOARCH)/$(BIN): build-dirs
	@echo "building: $@"
	GOOS=$(GOOS) \
	GOARCH=$(GOARCH) \
	PKG=$(PKG) \
	BIN=$(BIN) \
	OUTPUT_DIR=./build/$(GOOS)/$(GOARCH) \
	./scripts/build.sh

build-dirs:
	@mkdir -p ./build/${GOOS}/${GOARCH}
	@mkdir -p ./release

###
### Release/Packaging targets
###

.PHONY: release
release: release/release-$(GOARCH).tar.gz

.PHONY: release-all-platforms
release-all-platforms: $(foreach platform,$(CLI_PLATFORMS),release/release-$(platform).tar.gz)

release/release-%.tar.gz: test/version/version
	@echo releasing
	$(eval TMPDIR := $(shell mktemp -d release_tmp_XXXX))
	$(eval SUBDIR := v$(call err_if_empty,RELEASE_NUMBER))
	$(eval _DSTARGS := "DESTDIR=$(TMPDIR)/$(SUBDIR)" "PREFIX=$(RELEASE_PREFIX)")
	$(eval ARCH := $*)
	mkdir -p "$(call err_if_empty,TMPDIR)/$(SUBDIR)"
	$(MAKE) GOOS=$(GOOS) GOARCH=$(GOARCH) build-$(ARCH)
	$(MAKE) GOOS=$(GOOS) GOARCH=$(GOARCH) $(_DSTARGS) install.bin
	tar -czvf $@ --xattrs -C "$(TMPDIR)" "./$(SUBDIR)"
	-rm -rf "$(TMPDIR)"

# The ./test/version/version binary is executed in other make steps
# so we have to make sure the version binary is built for NATIVE_GOARCH.
test/version/version: version/version.go
	GOARCH=$(NATIVE_GOARCH) go build -o $@ ./test/version/

.PHONY: install.bin
install.bin:
	install -d -m 755 $(DESTDIR)$(BINDIR)
	install -m 755 build/$(GOOS)/$(GOARCH)/basic$(BINSUFFIX) $(DESTDIR)$(BINDIR)/basic$(BINSUFFIX)

.PHONY: clean
clean:
	rm -rf ./build
	rm -rf ./release

.PHONY: modules
modules:
	go mod tidy
