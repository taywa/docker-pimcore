PIMCORE_DOCKER=6.7.2
PIMCORE_EXTRAS_DOCKER=6.7.2b

build:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	cd docker && DOCKER_BUILDKIT=1 docker build --secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN -t taywa/pimcore:$(PIMCORE_DOCKER) pimcore
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:latest
	rm docker/pimcore/files.tar

push:
	docker push taywa/pimcore:$(PIMCORE_DOCKER)
	docker push taywa/pimcore:latest

build-extras:
	cd docker && DOCKER_BUILDKIT=1 docker build --secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN -t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) pimcore-extras
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest


push-extras:
	docker push taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)
	docker push taywa/pimcore-extras:latest
