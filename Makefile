.SILENT :
.PHONY : test push build

TAG=1.9.10

default: build

update-dependencies:
	docker pull jwilder/docker-gen:latest
	docker pull nginx:latest
	docker pull python:3
	docker pull rancher/socat-docker:latest
	docker pull appropriate/curl:latest
	docker pull docker:1.7

test:
	docker build -t jwilder/nginx-proxy:bats .
	bats test

push:
	docker push benhall/nginx-proxy:$(TAG)-sticky-letsencrypt

build: 
	docker build -t benhall/nginx-proxy:$(TAG)-sticky-letsencrypt .
