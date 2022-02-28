PIMCORE_DOCKER=10.3.1
PIMCORE_DOCKER_PREV=
PIMCORE_EXTRAS_DOCKER=10.3.1
PIMCORE_EXTRAS_DOCKER_PREV=

build-arch:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	cd docker && DOCKER_BUILDKIT=1 \
	docker buildx build \
		--load \
		--platform linux/`arch|sed 's/x86_64/amd64/'` \
		--secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore:$(PIMCORE_DOCKER) \
		pimcore
		# --cache-from taywa/pimcore:$(PIMCORE_DOCKER_PREV) \
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:latest
	rm docker/pimcore/files.tar

build-push:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	cd docker && DOCKER_BUILDKIT=1 \
	docker buildx build \
		--push \
		--platform linux/arm64,linux/amd64 \
		--secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore:$(PIMCORE_DOCKER) \
		pimcore
		# --cache-from taywa/pimcore:$(PIMCORE_DOCKER_PREV) \
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
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) \
		pimcore-extras
		# --cache-from taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER_PREV) \
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest

build-extras-push:
	cd docker && DOCKER_BUILDKIT=1 \
	docker buildx build \
		--push \
		--platform linux/arm64,linux/amd64/ \
		--secret id=GITHUBTOKEN,src=pimcore-extras/GITHUBTOKEN \
		--build-arg BUILDKIT_INLINE_CACHE=1 -t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) \
		pimcore-extras
		# --cache-from taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER_PREV) \
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest

push-extras-arch:
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)-`arch|sed 's/x86_64/amd64/'`
	docker push taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)-`arch|sed 's/x86_64/amd64/'`

push-manifest:
	manifest-tool --debug push from-spec manifest.yaml

push-extras-manifest:
	manifest-tool --debug push from-spec manifest-extras.yaml
