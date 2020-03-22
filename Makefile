PIMCORE_DOCKER=0.1

build:
	cd docker/pimcore/files; gtar cf ../files.tar * --owner=0 --group=0
	cd docker && DOCKER_BUILDKIT=1 docker build --secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN -t taywa/pimcore:$(PIMCORE_DOCKER) pimcore
	rm docker/pimcore/files.tar

push:
	docker push taywa/pimcore:$(PIMCORE_DOCKER)
