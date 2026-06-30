import CarPlay
import UIKit
import WebKit

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?
    var carWebView: WKWebView?
    
    // الدالة الرسمية التي تطلقها السيارة عند الاتصال
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carWindow = window
        
        // إعداد المتصفح الحقيقي للسيارة مع تخطي قيود أبل للميديا
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        // إجبار المتصفح على اتخاذ حجم شاشة السيارة بالكامل
        let webViewFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        carWebView = WKWebView(frame: webViewFrame, configuration: config)
        
        // تغيير الـ User Agent ليوهم المواقع أنه جهاز iPad حقيقي عشان تفتح النسخة الكاملة للموقع وتشتغل الفيديوهات
        carWebView?.customUserAgent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        if let web = carWebView {
            window.addSubview(web)
            // فتح محرك بحث جوجل كصفحة رئيسية ومنها تنطلق لأي موقع
            web.load(URLRequest(url: URL(string: "https://www.google.com")!))
            
            // زر تحديث الصفحة (Refresh) عائم فوق المتصفح في حال علّق الاتصال
            let refreshBtn = UIButton(frame: CGRect(x: 15, y: 15, width: 45, height: 45))
            refreshBtn.setImage(UIImage(systemName: "arrow.clockwise.circle.fill"), for: .normal)
            refreshBtn.tintColor = .green
            refreshBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            refreshBtn.layer.cornerRadius = 22.5
            refreshBtn.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
            window.addSubview(refreshBtn)
        }
        
        // إنشاء واجهة فارغة في الخلفية لتلبية متطلبات النظام
        let template = CPBlankTemplate()
        self.interfaceController?.setRootTemplate(template, animated: false, completion: nil)
    }
    
    @objc func refreshPage() {
        carWebView?.reload()
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectFrom interfaceController: CPInterfaceController) {
        self.interfaceController = nil
        self.carWindow = nil
    }
}
