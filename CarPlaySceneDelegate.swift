import CarPlay
import UIKit
import WebKit

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var interfaceController: CPInterfaceController?
    var carWindow: CPWindow?
    var carWebView: WKWebView?
    
    let allApps = [
        CarAppItem(id: "yt", name: "YouTube", url: "https://www.youtube.com", icon: "play.rectangle.fill"),
        CarAppItem(id: "tt", name: "TikTok", url: "https://www.tiktok.com", icon: "video.circle.fill"),
        CarAppItem(id: "go", name: "Google", url: "https://www.google.com", icon: "magnifyingglass"),
        CarAppItem(id: "tw", name: "X / Twitter", url: "https://www.x.com", icon: "message.fill")
    ]
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carWindow = window
        showAppGrid()
    }
    
    func showAppGrid() {
        let savedIDs = UserDefaults.standard.stringArray(forKey: "CarPlayEnabledApps") ?? ["yt", "tt", "go", "tw"]
        let activeApps = allApps.filter { savedIDs.contains($0.id) }
        
        var gridButtons: [CPGridButton] = []
        for app in activeApps {
            let btn = CPGridButton(titleVariants: [app.name], image: UIImage(systemName: app.icon)!) { _ in
                self.launchUrlInCar(urlStr: app.url)
            }
            gridButtons.append(btn)
        }
        
        let gridTemplate = CPGridTemplate(title: "تطبيقات يزن الحقيقية", gridButtons: gridButtons)
        // استخدام الطريقة المتوافقة لتجنب التحذير
        self.interfaceController?.setRootTemplate(gridTemplate, animated: true, completion: nil)
    }
    
    func launchUrlInCar(urlStr: String) {
        guard let window = carWindow else { return }
        
        carWebView?.removeFromSuperview()
        window.subviews.forEach { $0.removeFromSuperview() }
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        let webViewFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
        carWebView = WKWebView(frame: webViewFrame, configuration: config)
        
        carWebView?.customUserAgent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        if let web = carWebView {
            window.addSubview(web)
            web.load(URLRequest(url: URL(string: urlStr)!))
            
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
        carWebView?.removeFromSuperview()
        carWindow?.subviews.forEach { $0.removeFromSuperview() }
        showAppGrid()
    }
    
    // تصحيح المسمى الرسمي لتجنب خطأ السطر 84
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectFrom interfaceController: CPInterfaceController) {
        self.interfaceController = nil
        self.carWindow = nil
    }
}
