PIMCORE_DOCKER=6.8.8
PIMCORE_EXTRAS_DOCKER=6.8.8
PIMCORE_DOCKER_PREV=6.8.7
PIMCORE_EXTRAS_DOCKER_PREV=6.8.7

build:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	cd docker && DOCKER_BUILDKIT=1 \
	docker build pimcore \
		--secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN \
		--cache-from taywa/pimcore:$(PIMCORE_DOCKER_PREV) \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore:$(PIMCORE_DOCKER)
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:latest
	rm docker/pimcore/files.tar

push:
	docker push taywa/pimcore:$(PIMCORE_DOCKER)
	docker push taywa/pimcore:latest

build-extras:
	cd docker && DOCKER_BUILDKIT=1 \
	docker build pimcore-extras \
		--secret id=GITHUBTOKEN,src=pimcore-extras/GITHUBTOKEN \
		--cache-from taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER_PREV) \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest


push-extras:
	docker push taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)
	docker push taywa/pimcore-extras:latest
