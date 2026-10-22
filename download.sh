#!/bin/bash
set -e
MODEL=${1:-unsloth/gemma-3-4b-it}
cd "$(dirname "$0")"
mkdir -p soft/deb soft/hf

docker run --rm --platform linux/amd64 -v "$PWD/soft/deb:/deb" ubuntu:24.04 bash -c '
set -e
mkdir -p /deb/partial
apt-get update
apt-get install -y curl gpg
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia.gpg
echo "deb [signed-by=/usr/share/keyrings/nvidia.gpg] https://nvidia.github.io/libnvidia-container/stable/deb/\$(ARCH) /" > /etc/apt/sources.list.d/nvidia.list
apt-get update
apt-get install -y --download-only -o Dir::Cache::archives=/deb linux-generic linux-headers-generic nvidia-driver-570-server docker.io nvidia-container-toolkit
rm -rf /deb/partial /deb/lock'

docker pull --platform linux/amd64 vllm/vllm-openai
docker save vllm/vllm-openai -o soft/vllm.tar

docker run --rm --platform linux/amd64 -v "$PWD/soft/hf:/root/.cache/huggingface" --entrypoint python3 vllm/vllm-openai \
  -c "from huggingface_hub import snapshot_download; snapshot_download('$MODEL')"
