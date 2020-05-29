define USAGE
USAGE:
> make [
	...
]
endef
export USAGE

SHELL := /bin/bash
BIN := $(PWD)/bin

help:
	@echo "$$USAGE"

usage:
	@echo "$$USAGE"

sense:
	@echo "$$USAGE"

install-golangci-lint:
	# binary will be $(go env GOPATH)/bin/golangci-lint
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(BIN) v1.27.0

install-dep-tools: install-golangci-lint
ifeq ($(OS),Windows_NT)
	mkdir -p $(BIN)
	curl https://github.com/golang/dep/releases/download/v0.5.4/dep-windows-amd64.exe -JLo $(BIN)/dep.exe
	curl https://github.com/protocolbuffers/protobuf/releases/download/v3.9.2/protoc-3.9.2-win64.zip -JLo $(BIN)/protoc.zip
	7z x $(BIN)/protoc.zip -o$(BIN) -aoa
	mv $(BIN)/bin/protoc.exe $(BIN)
	ls -lah $(BIN)
else
ifeq ($(shell uname -s),Linux)

	mkdir $(BIN)
	echo "HIIII"
	curl https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 -JLo $(BIN)/dep
	chmod +x $(BIN)/dep
	PROTOC_ZIP := protoc-3.8.0-linux-x86_64.zip
	curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.8.0/$(PROTOC_ZIP)
	unzip -o $(PROTOC_ZIP) -d /usr/local bin/protoc
	unzip -o $(PROTOC_ZIP) -d /usr/local include/*
else
	brew install dep
	brew install protobuf
endif
endif
