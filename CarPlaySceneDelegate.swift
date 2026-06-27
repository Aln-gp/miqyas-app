import CarPlay
import UIKit
import WebKit

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow? // تعديل: استخدام نوع النافذة المخصصة للكاربلاي حقيقية
    var carWebView: WKWebView?
    
    let allApps = [
        CarAppItem(id: "yt", name: "YouTube", url: "https://www.youtube.com", icon: "play.rectangle.fill"),
        CarAppItem(id: "tt", name: "TikTok", url: "https://www.tiktok.com", icon: "video.circle.fill"),
        CarAppItem(id: "go", name: "Google", url: "https://www.google.com", icon: "magnifyingglass"),
        CarAppItem(id: "tw", name: "X / Twitter", url: "https://www.x.com", icon: "message.fill")
    ]
    
    // الدالة الرسمية التي تطلقها السيارة عند الاتصال الحقيقي
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carWindow = window
        
        // إظهار شبكة التطبيقات فوراً عند تشغيل شاشة السيارة
        showAppGrid()
    }
    
    func showAppGrid() {
        let savedIDs = UserDefaults.standard.stringArray(forKey: "CarPlayEnabledApps") ?? ["yt", "tt", "go", "tw"]
        let activeApps = allApps.filter { savedIDs.contains($0.id) }
        
        var gridButtons: [CPGridButton] = []
        for app in activeApps {
            // عند الضغط على أي تطبيق، يتم فتح الرابط الحقيقي فوراً داخل شاشة السيارة
            let btn = CPGridButton(titleVariants: [app.name], image: UIImage(systemName: app.icon)!) { _ in
                self.launchUrlInCar(urlStr: app.url)
            }
            gridButtons.append(btn)
        }
        
        let gridTemplate = CPGridTemplate(title: "تطبيقات يزن الحقيقية", gridButtons: gridButtons)
        self.interfaceController?.setRootTemplate(gridTemplate, animated: true)
    }
    
    func launchUrlInCar(urlStr: String) {
        guard let window = carWindow else { return }
        
        // تنظيف الشاشة من أي متصفح قديم
        carWebView?.removeFromSuperview()
        window.subviews.forEach { $0.removeFromSuperview() }
        
        // إعداد المتصفح الحقيقي للسيارة مع تخطي قيود أبل للميديا
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        // إجبار المتصفح على اتخاذ حجم شاشة السيارة بالكامل
        let webViewFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        carWebView = WKWebView(frame: webViewFrame, configuration: config)
        
        // تغيير الـ User Agent ليوهم المواقع أنه جهاز iPad حقيقي عشان تفتح النسخة الكاملة للموقع
        carWebView?.customUserAgent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        if let web = carWebView {
            window.addSubview(web)
            web.load(URLRequest(url: URL(string: urlStr)!))
            
            // زر الهوم العائم للرجوع لقائمة التطبيقات
            let homeBtn = UIButton(frame: CGRect(x: 15, y: 15, width: 45, height: 45))
            homeBtn.setImage(UIImage(systemName: "house.circle.fill"), for: .normal)
            homeBtn.tintColor = .green
            homeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            homeBtn.layer.cornerRadius = 22.5
            homeBtn.addTarget(self, action: #selector(goBackToGrid), for: .touchUpInside)
            window.addSubview(homeBtn)
        }
    }
    
    @objc func goBackToGrid() {
        // حذف المتصفح والرجوع للقائمة الأساسية
        carWebView?.removeFromSuperview()
        carWindow?.subviews.forEach { $0.removeFromSuperview() }
        showAppGrid()
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnect interfaceController: CPInterfaceController) {
        self.interfaceController = nil
        self.carWindow = nil
    }
}
