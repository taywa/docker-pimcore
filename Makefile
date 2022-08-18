PIMCORE_DOCKER=10.5.2c
PIMCORE_EXTRAS_DOCKER=10.5.2c
ARCHS=linux/arm64,linux/amd64

build-arch:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	shasum docker/pimcore/files.tar
	cd docker && docker buildx build \
		--load \
		--platform linux/`arch|sed 's/x86_64/amd64/'` \
		--secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from taywa/pimcore:latest \
		-t taywa/pimcore:$(PIMCORE_DOCKER) \
		pimcore
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:latest
	rm docker/pimcore/files.tar

build-push-archs:
	cd docker/pimcore/files-00; gtar cf ../files.tar * --owner=0 --group=0
	shasum docker/pimcore/files.tar
	cd docker && DOCKER_BUILDKIT=1 docker buildx build \
		--push \
		--platform $(ARCHS) \
		--secret id=GITHUBTOKEN,src=pimcore/GITHUBTOKEN \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from taywa/pimcore:latest \
		-t taywa/pimcore:$(PIMCORE_DOCKER) \
		pimcore
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:latest
	docker push taywa/pimcore:$(PIMCORE_DOCKER)
	rm docker/pimcore/files.tar

push-arch:
	docker tag taywa/pimcore:$(PIMCORE_DOCKER) taywa/pimcore:$(PIMCORE_DOCKER)-`arch|sed 's/x86_64/amd64/'`
	docker push taywa/pimcore:$(PIMCORE_DOCKER)-`arch|sed 's/x86_64/amd64/'`

build-extras-arch:
	cd docker && docker buildx build \
		--load \
		--platform linux/`arch|sed 's/x86_64/amd64/'` \
		--secret id=GITHUBTOKEN,src=pimcore-extras/GITHUBTOKEN \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from taywa/pimcore-extras:latest \
		-t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) \
		pimcore-extras
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest

# build-extras-push-archs:
# 	cd docker && DOCKER_BUILDKIT=1 \
# 	docker buildx build \
# 		--push \
# 		--platform $(ARCHS) \
# 		--secret id=GITHUBTOKEN,src=pimcore-extras/GITHUBTOKEN \
# 		--build-arg BUILDKIT_INLINE_CACHE=1
# 		--cache-from taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER_PREV) \
# 		-t taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) \
# 		pimcore-extras
# 	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:latest

push-extras-arch:
	docker tag taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER) taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)-`arch|sed 's/x86_64/amd64/'`
	docker push taywa/pimcore-extras:$(PIMCORE_EXTRAS_DOCKER)-`arch|sed 's/x86_64/amd64/'`

push-manifest:
	manifest-tool --debug push from-spec manifest.yaml

push-extras-manifest:
	manifest-tool --debug push from-spec manifest-extras.yaml

start:
	docker-compose exec pimcore s6-svc -u /var/run/s6/services/php-fpm
	docker-compose exec pimcore s6-svc -u /var/run/s6/services/nginx

fix-permissions:
	docker-compose exec pimcore chown www-data:www-data /opt/pimcore/var
	docker-compose exec pimcore sh -c "cd /opt/pimcore/var && chown www-data:www-data -R application-logger cache classes email log tmp config /opt/pimcore/public/var"

install:
	docker-compose exec pimcore ./vendor/bin/pimcore-install --no-interaction --ignore-existing-config

link-default-bundles:
	docker-compose exec -w /opt/pimcore/public/bundles pimcore ln -fs ../../vendor/pimcore/pimcore/bundles/CoreBundle/Resources/public/ pimcorecore
	docker-compose exec -w /opt/pimcore/public/bundles pimcore ln -fs ../../vendor/pimcore/pimcore/bundles/AdminBundle/Resources/public/ pimcoreadmin
	docker-compose exec -w /opt/pimcore/public/bundles pimcore ln -fs ../../vendor/friendsofsymfony/jsrouting-bundle/Resources/public/ fosjsrouting

init: install

enter:
	docker-compose exec pimcore bash
