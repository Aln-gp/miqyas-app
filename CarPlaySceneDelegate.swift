import CarPlay
import UIKit
import WebKit

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?
    var carWebView: WKWebView?
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carWindow = window
        
        // إعداد المتصفح وتكبير الحجم على كامل الشاشة
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        let webViewFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        carWebView = WKWebView(frame: webViewFrame, configuration: config)
        
        // إيهام النظام بأنه آيباد لتخطي الحجب وتشغيل اللمس والفيديوهات كاملة
        carWebView?.customUserAgent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        if let web = carWebView {
            window.addSubview(web)
            // فتح جوجل مباشرة
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
        
        // الحل القاطع: استخدام قالب الشبكة الرسمي والمضمون 100% في مكتبة CarPlay
        let gridTemplate = CPGridTemplate(title: "Yazan Web", gridButtons: [])
        self.interfaceController?.setRootTemplate(gridTemplate, animated: false, completion: nil)
    }
    
    @objc func refreshPage() {
        carWebView?.reload()
    }
}
