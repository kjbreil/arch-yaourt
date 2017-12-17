NS = kjbreil
VERSION ?= $(shell date +'%Y.%m.%d')

REPO = arch-yaourt
NAME = arch-yaourt
INSTANCE = default

# VOLUMES=-v $(CURDIR)/:/opt/build/ 

.PHONY: image push shell run start stop rm release

default: release

release: no-cache push 

image:
	docker build -t $(NS)/$(REPO) -t $(NS)/$(REPO):$(VERSION) .

no-cache:
	docker build --no-cache -t $(NS)/$(REPO) -t $(NS)/$(REPO):$(VERSION) .

push:
	docker push $(NS)/$(REPO):$(VERSION)
	docker push $(NS)/$(REPO)

heim:
	docker tag $(NS)/$(REPO):$(VERSION) heimdall.norgenet.net:5000/$(REPO):$(VERSION)
	docker tag $(NS)/$(REPO):$(VERSION) heimdall.norgenet.net:5000/$(REPO)

shell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash

bshell:
	docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/arch-build:$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)
