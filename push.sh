#!/bin/bash
set -e

IMAGE_NAME="ghcr.io/cwa-tw/claude_code_docker"

# Release versions must use an exact major.minor.patch tag.
VERSION="${1:-}"
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "錯誤：版本必須符合 <major>.<minor>.<patch>（例如 0.3.0）"
  echo "用法：$0 <major>.<minor>.<patch>"
  exit 1
fi
TAG="$VERSION"

if [ -n "$(git status --porcelain)" ]; then
  echo "錯誤：工作目錄不是乾淨狀態，請先 commit 所有 release 變更"
  exit 1
fi

if ! git rev-parse --verify --quiet "refs/tags/$TAG" > /dev/null; then
  echo "錯誤：找不到指向目前 release commit 的 tag：$TAG"
  exit 1
fi

if [ "$(git rev-parse HEAD)" != "$(git rev-list -n 1 "$TAG")" ]; then
  echo "錯誤：tag $TAG 並未指向目前的 HEAD"
  exit 1
fi

echo "建置映像檔：${IMAGE_NAME}:${TAG}"
docker build -t "${IMAGE_NAME}:${TAG}" -t "${IMAGE_NAME}:latest" .

echo "推送映像檔：${IMAGE_NAME}:${TAG}"
docker push "${IMAGE_NAME}:${TAG}"

echo "推送映像檔：${IMAGE_NAME}:latest"
docker push "${IMAGE_NAME}:latest"

echo "完成！已推送 ${IMAGE_NAME}:${TAG} 及 ${IMAGE_NAME}:latest"
