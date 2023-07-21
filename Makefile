PKG  := github.com/whynotea/go-examples
ARCH ?= linux-amd64

platform_temp = $(subst -, ,$(ARCH))
GOOS = $(word 1, $(platform_temp))
GOARCH = $(word 2, $(platform_temp))

CLI_PLATFORMS ?= linux-amd64 windows-amd64

all:
	@$(MAKE) build BIN=basic

all-build: $(addprefix build-,$(CLI_PLATFORMS))

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

clean:
	rm -rf ./build

.PHONY: modules
modules:
	go mod tidy
