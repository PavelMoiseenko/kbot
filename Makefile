APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=pavelmoiseenko
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64 #amd64

format:
	gofmt -s -w ./

lint:
	golint

get:
	go get	 	

test: 
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/PavelMoiseenko/kbot/cmd.appVersion=${VERSION}

linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/PavelMoiseenko/kbot/cmd.appVersion=${VERSION}

macOS:
	CGO_ENABLED=0 GOOS=darwin GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/PavelMoiseenko/kbot/cmd.appVersion=${VERSION}

windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/PavelMoiseenko/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	docker rmi <IMAGE_TAG>