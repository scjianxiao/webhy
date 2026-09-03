
#!/bin/bash

# Qwen3-14B-AWQ 一键启动脚本
# 确保在具有 GPU 环境的容器中或宿主机上运行

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/configs/deploy_params.json"

echo "🚀 Starting Qwen3-14B-AWQ Deployment..."

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# 读取配置参数 (使用 python 解析 json 以确保兼容性)
MODEL_PATH=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['model_path'])")
PORT=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['port'])")
GPU_UTIL=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['gpu_memory_utilization'])")
MAX_LEN=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['max_model_len'])")

echo "📂 Model Path: $MODEL_PATH"
echo "🔌 Port: $PORT"
echo "💾 GPU Utilization: $GPU_UTIL"

# 检查模型路径
if [ ! -d "$MODEL_PATH" ]; then
    echo "⚠️ Warning: Model directory not found. Attempting to download via ModelScope..."
    python3 -c "
from modelscope.hub.snapshot_download import snapshot_download
snapshot_download('Qwen/Qwen3-14B-AWQ', local_dir='$MODEL_PATH')
"
fi

# 启动 vLLM 服务
echo "🏃‍♂️ Launching vLLM API Server..."
python3 -m vllm.entrypoints.api_server \
    --model "$MODEL_PATH" \
    --port "$PORT" \
    --gpu-memory-utilization "$GPU_UTIL" \
    --max-model-len "$MAX_LEN" \
    --dtype auto \
    --trust-remote-code

echo "✅ Service started successfully."
