PIMCORE_DOCKER=6.9.6b
PIMCORE_DOCKER_PREV=6.9.6a
PIMCORE_EXTRAS_DOCKER=6.9.6b
PIMCORE_EXTRAS_DOCKER_PREV=6.9.6a-02

build-arch:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	cd docker && DOCKER_BUILDKIT=1 \
	docker buildx build \
		--load \
		--platform linux/`arch|sed 's/x86_64/amd64/'` \
		--secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN \
		--cache-from taywa/pimcore:$(PIMCORE_DOCKER_PREV) \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore:$(PIMCORE_DOCKER) \
		pimcore
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:latest
	rm docker/pimcore/files.tar

build-push:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	cd docker && DOCKER_BUILDKIT=1 \
	docker buildx build \
		--push \
		--platform linux/arm64,linux/amd64 \
		--secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN \
		--cache-from taywa/pimcore:$(PIMCORE_DOCKER_PREV) \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore:$(PIMCORE_DOCKER) \
		pimcore
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:latest
	rm docker/pimcore/files.tar

push-arch:
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:$(PIMCORE_DOCKER)-`arch|sed 's/x86_64/amd64/'`
	docker push taywa/pimcore:$(PIMCORE_DOCKER)-`arch|sed 's/x86_64/amd64/'`

build-extras-arch:
	cd docker && DOCKER_BUILDKIT=1 \
	docker buildx build \
		--load \
		--platform linux/`arch|sed 's/x86_64/amd64/'` \
		--secret id=GITHUBTOKEN,src=pimcore-extras/GITHUBTOKEN \
		--cache-from taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER_PREV) \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) \
		pimcore-extras
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest


build-extras-push:
	cd docker && DOCKER_BUILDKIT=1 \
	docker buildx build \
		--push \
		--platform linux/arm64,linux/amd64/` \
		--secret id=GITHUBTOKEN,src=pimcore-extras/GITHUBTOKEN \
		--cache-from taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER_PREV) \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) \
		pimcore-extras
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest

push-extras-arch:
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)-`arch|sed 's/x86_64/amd64/'`
	docker push taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)-`arch|sed 's/x86_64/amd64/'`