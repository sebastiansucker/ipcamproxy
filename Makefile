GOPATH=$(shell pwd)/vendor:$(shell pwd)
GOBIN=$(shell pwd)/bin
GOFILES=$(wildcard *.go)
GONAME=$(shell basename "$(PWD)")
HOSTPORT=9000
CONTAINERPORT=9000

all: clean build test smoketest

clean:
	rm -f ./$(GONAME).image
	rm -f ./source.png
	rm -f ./result.png
	rm -f ./ipcamproxy

build:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go build -o $(GONAME) $(GOFILES)

test:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go test -cover

smoketest: docker_run
	@docker stop $(GONAME) || true
	@docker rm $(GONAME) || true

	# working comparison
	@docker run -p $(HOSTPORT):$(CONTAINERPORT) -d --name $(GONAME) $(GONAME):latest http://www.gstatic.com:80/webp/gallery3/1.png false
	@wget -q http://localhost:9000 -O result.png
	@wget -q http://www.gstatic.com:80/webp/gallery3/1.png -O source.png

	@if cmp result.png source.png; then \
    	echo "files match" ; \
	else \
    	echo "files DONT match" ; \
    	echo "foo" ; \
	fi

	@rm result.png
	@rm source.png

	@docker stop $(GONAME) || true
	@docker rm $(GONAME) || true

	# failing comparison
	@docker run -p $(HOSTPORT):$(CONTAINERPORT) -d --name $(GONAME) $(GONAME):latest http://www.gstatic.com:80/webp/gallery3/1.png false
	@wget -q http://localhost:9000 -O result.png
	@wget -q http://www.gstatic.com:80/webp/gallery3/2.png -O source.png

	@if !(cmp result.png source.png); then \
    	echo "files DONT match" ; \
	else \
    	echo "files match" ; \
    	echo "foo" ; \
	fi

	@rm result.png
	@rm source.png

	@docker stop $(GONAME) || true
	@docker rm $(GONAME) || true

run: build
	./$(GONAME) "http://www.gstatic.com:80/webp/gallery3/1.png" false
	
docker_build:
	docker build -t $(GONAME) .

docker_run : docker_stop docker_build
	docker run -p $(HOSTPORT):$(CONTAINERPORT) -d --name $(GONAME) $(GONAME) http://www.gstatic.com:80/webp/gallery3/1.png false

docker_stop:
	docker stop $(GONAME) || true
	docker rm $(GONAME) || true