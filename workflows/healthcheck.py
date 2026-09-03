
import requests
import sys
import json
import time

def check_health(base_url="http://localhost:8000"):
    """
    检查 vLLM 服务是否正常运行
    """
    url = f"{base_url}/v1/models"
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            data = response.json()
            print("✅ Health Check Passed!")
            print(f"   Available Models: {json.dumps(data, indent=2)}")
            return True
        else:
            print(f"❌ Health Check Failed: Status Code {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ Connection Error: {e}")
        return False

if __name__ == "__main__":
    # 等待服务启动
    print("⏳ Waiting for service to start...")
    time.sleep(5)
    success = check_health()
    sys.exit(0 if success else 1)
