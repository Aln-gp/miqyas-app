import CarPlay
import UIKit
import WebKit

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate, CPMapTemplateDelegate {
    
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?
    var carWebView: WKWebView?
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carWindow = window
        
        // إعداد متصفح الويب بكامل مساحة شاشة السيارة
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        let webViewFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        carWebView = WKWebView(frame: webViewFrame, configuration: config)
        
        // تغيير الـ User Agent لفتح نسخة الآيباد الكاملة لتخطي حجب الميديا
        carWebView?.customUserAgent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        if let web = carWebView {
            window.addSubview(web)
            // فتح محرك البحث الرئيسي جوجل
            web.load(URLRequest(url: URL(string: "https://www.google.com")!))
            
            // زر التحديث العائم
            let refreshBtn = UIButton(frame: CGRect(x: 15, y: 15, width: 45, height: 45))
            refreshBtn.setImage(UIImage(systemName: "arrow.clockwise.circle.fill"), for: .normal)
            refreshBtn.tintColor = .green
            refreshBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            refreshBtn.layer.cornerRadius = 22.5
            refreshBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
            window.addSubview(refreshBtn)
        }
        
        // إنشاء قالب الخرائط الرسمي وتفعيله
        let mapTemplate = CPMapTemplate()
        mapTemplate.mapDelegate = self
        self.interfaceController?.setRootTemplate(mapTemplate, animated: false, completion: nil)
    }
    
    @objc func refreshPage() {
        carWebView?.reload()
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectFrom interfaceController: CPInterfaceController) {
        self.interfaceController = nil
        self.carWindow = nil
    }
}
