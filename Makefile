IMAGE ?= cds2413-data-science:1.0

.PHONY: build run shell git-shell
build:      ## Build the Docker image
	docker build -t $(IMAGE) .
run:        ## Run the CLO1-CLO3 pipeline inside Docker
	docker run --rm -v "$(PWD)/data:/workspace/project/data" -v "$(PWD)/reports:/workspace/project/reports" -u root $(IMAGE)
shell:      ## Interactive shell inside the container
	docker run --rm -it $(IMAGE) bash
git-shell:  ## Long-running container used for the CLO4 Git workflow
	docker run -d --name cds2413-git $(IMAGE) sleep infinity
	docker exec -it cds2413-git bash
