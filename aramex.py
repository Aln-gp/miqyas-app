import os
import time
import requests
from bs4 import BeautifulSoup

# بيانات الشحنة ورابط الويب هوكس
TRACKING_NUMBER = "52529891256"
IFTTT_URL = os.environ.get("IFTTT_URL", "https://maker.ifttt.com/trigger/aramex_alert/with/key/lNLcTQ5evpSK37m4Mo5Fae4h_L-3AbVmsalk4szrS0r")
STATE_FILE = "aramex_state.txt"

def get_shipment_status():
    try:
        # رابط صفحة أرامكس العامة للتتبع
        url = f"https://www.aramex.com/sa/en/track/shipments?TrackingShipments={TRACKING_NUMBER}"
        headers = {"User-Agent": "Mozilla/5.0"}
        response = requests.get(url, headers=headers, timeout=10)
        
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            # هنا يمكنك إضافة كود استخراج الحالة، أو الاعتماد على الفحص التجريبي
            # بما أن الصفحة تتطلب جافاسكريبت، سنبسط الطريقة أو نقرأ محتواها
            return "In Transit"
    except Exception as e:
        print(f"Error checking status: {e}")
    return None

def main():
    print(f"Starting Aramex monitor for tracking: {TRACKING_NUMBER}")
    last_status = ""
    
    # استرجاع الحالة السابقة إن وجدت
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            last_status = f.read().strip()

    while True:
        # فحص الحالة كل 5 ثوانٍ
        print("Checking shipment status...")
        
        # لو حابب تختبر وتجرب إرسال الإنبيه الآن، شيل علامة التعجب من السطر التجريبي تحت:
        # current_status = "Out for Delivery"
        
        current_status = get_shipment_status()
        
        if current_status and "Out for Delivery" in current_status and last_status != "Out for Delivery":
            print("Status changed to Out for Delivery! Triggering IFTTT...")
            res = requests.post(IFTTT_URL)
            if res.status_code == 200:
                print("Alert sent successfully! Your phone should ring now.")
                last_status = "Out for Delivery"
                with open(STATE_FILE, "w") as f:
                    f.write(last_status)
            else:
                print("Failed to trigger IFTTT webhook.")
                
        time.sleep(5)

if __name__ == "__main__":
    main()
