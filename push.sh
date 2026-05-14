#!/bin/bash
set -e

IMAGE_NAME="ghcr.io/cwa-tw/claude_code_docker"

# 取得版本 tag：使用傳入參數，或抓最新 git tag
if [ -n "$1" ]; then
  VERSION="$1"
else
  VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
  if [ -z "$VERSION" ]; then
    echo "錯誤：找不到 git tag，請傳入版本號作為參數"
    echo "用法：$0 [version]"
    echo "範例：$0 0.1.0"
    exit 1
  fi
fi

# 去掉 v 前綴（如 v0.1.0 -> 0.1.0）
TAG="${VERSION#v}"

echo "建置映像檔：${IMAGE_NAME}:${TAG}"
docker build -t "${IMAGE_NAME}:${TAG}" -t "${IMAGE_NAME}:latest" .

echo "推送映像檔：${IMAGE_NAME}:${TAG}"
docker push "${IMAGE_NAME}:${TAG}"

echo "推送映像檔：${IMAGE_NAME}:latest"
docker push "${IMAGE_NAME}:latest"

echo "完成！已推送 ${IMAGE_NAME}:${TAG} 及 ${IMAGE_NAME}:latest"
