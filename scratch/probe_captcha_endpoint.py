import requests
import json

BASE_URL = "https://clientapigateway-dev.midchains.com"
email = "joshi.sahil12+0312i_1@gmail.com"

def main():
    session = requests.Session()
    
    # 1. Session init
    r = session.get(f"{BASE_URL}/api/client/auth/session")
    session_data = r.json()
    print("Session Response:", json.dumps(session_data, indent=2))
    
    session_id = session_data.get("sessionId")
    
    headers = {
        "sessionId": session_id,
        "x-user-name": email,
        "Content-Type": "application/json"
    }
    
    # 2. Captcha request
    payload = {"email": email, "password": "Test@123"}
    r = session.post(f"{BASE_URL}/api/client/auth/login/captcha/request/v2", json=payload, headers=headers)
    captcha_data = r.json()
    print("Captcha Request Response:", json.dumps(captcha_data, indent=2))
    
    # Extract captchaId
    captcha_id = None
    if "data" in captcha_data and isinstance(captcha_data["data"], dict):
        captcha_id = captcha_data["data"].get("captchaId")
    else:
        captcha_id = captcha_data.get("captchaId")
        
    print("Extracted Captcha ID:", captcha_id)
    
    # 3. Captcha validate
    payload_validate = {"captchaId": captcha_id, "captchaInput": "slider-verified"}
    r = session.post(f"{BASE_URL}/api/client/auth/login/captcha/validate/v2", json=payload_validate, headers=headers)
    validate_data = r.json()
    print("Captcha Validate Response:", json.dumps(validate_data, indent=2))

if __name__ == "__main__":
    main()
