TAG ?= latest
IMAGE := lucacri/docker-mkdocs

VMAJOR=`semver-cli get major ${TAG}`
VMINOR=`semver-cli get minor ${TAG}`
VPATCH=`semver-cli get patch ${TAG}`

THIS_FILE := $(lastword $(MAKEFILE_LIST))

build:
	@echo "------------------"
	@echo "BUILDING: "
	@echo "${IMAGE}:${TAG}"
	@echo "------------------"
	@echo ""
	@echo ""
	@docker build -t ${IMAGE}:${TAG} .
	@docker tag ${IMAGE}:${TAG} ${IMAGE}:latest

build-multi:
	@echo "------------------"
	@echo "BUILDING MULTI-ARCH: "
	@echo "${IMAGE}:${TAG}"
	@echo "------------------"
	@echo ""
	@echo ""
	@docker buildx build --platform linux/amd64 --push --tag ${IMAGE}:${TAG} --tag ${IMAGE}:latest .

push:
	@echo "------------------"
	@echo "PUSHING: "
	@echo "${IMAGE}:latest"
	@echo "${IMAGE}:${TAG}"
	@echo "${IMAGE}:${VMAJOR}"
	@echo "${IMAGE}:${VMAJOR}.${VMINOR}"
	@echo "${IMAGE}:${VMAJOR}.${VMINOR}.${VPATCH}"
	@echo "------------------"
	@echo ""
	@echo ""
	@docker push ${IMAGE}:${TAG}
	@docker push ${IMAGE}:${VMAJOR}
	@docker push ${IMAGE}:${VMAJOR}.${VMINOR}
	@docker push ${IMAGE}:${VMAJOR}.${VMINOR}.${VPATCH}
	@docker push ${IMAGE}:latest

tag:
	@echo "------------------"
	@echo "TAGGING: "
	@echo "${IMAGE}:latest"
	@echo "${IMAGE}:${TAG}"
	@echo "${IMAGE}:${VMAJOR}"
	@echo "${IMAGE}:${VMAJOR}.${VMINOR}"
	@echo "${IMAGE}:${VMAJOR}.${VMINOR}.${VPATCH}"
	@echo "------------------"
	@echo ""
	@echo ""
	@docker tag ${IMAGE}:${TAG} ${IMAGE}:latest
	@docker tag ${IMAGE}:${TAG} ${IMAGE}:${VMAJOR}
	@docker tag ${IMAGE}:${TAG} ${IMAGE}:${VMAJOR}.${VMINOR}
	@docker tag ${IMAGE}:${TAG} ${IMAGE}:${VMAJOR}.${VMINOR}.${VPATCH}

all:
	@$(MAKE) -f $(THIS_FILE) build
	@$(MAKE) -f $(THIS_FILE) tag
	@$(MAKE) -f $(THIS_FILE) push

all-last-tag:
	@$(MAKE) -f $(THIS_FILE) TAG=`git describe --tags $(git rev-list --tags --max-count=1)` all