.PHONY: default
default: all

.PHONY: all
all:
	goreleaser build --single-target --snapshot --clean

build-%: 
	goreleaser build --single-target --snapshot --clean --id $*

.PHONY: clean
clean:
	rm -rf ./dist

.PHONY: modules
modules:
	go mod tidy
