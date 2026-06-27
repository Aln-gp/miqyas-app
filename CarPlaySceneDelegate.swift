import CarPlay
import UIKit
import WebKit

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    
    var interfaceController: CPInterfaceController?
    var carWindow: UIWindow?
    var carWebView: WKWebView?
    var syncTimer: Timer?
    
    let allApps = [
        CarAppItem(id: "yt", name: "YouTube", url: "https://www.youtube.com", icon: "play.rectangle.fill"),
        CarAppItem(id: "tt", name: "TikTok", url: "https://www.tiktok.com", icon: "video.circle.fill"),
        CarAppItem(id: "go", name: "Google", url: "https://www.google.com", icon: "magnifyingglass"),
        CarAppItem(id: "tw", name: "X / Twitter", url: "https://www.x.com", icon: "message.fill")
    ]
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carWindow = window
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        carWebView = WKWebView(frame: window.bounds, configuration: config)
        carWebView?.customUserAgent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        syncTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.updateCarScreen()
        }
    }
    
    func updateCarScreen() {
        let isMirroring = UserDefaults.standard.bool(forKey: "IsScreenMirroringActive")
        
        if isMirroring {
            launchUrlInCar(urlStr: "http://127.0.0.1:8080/stream")
        } else {
            let savedIDs = UserDefaults.standard.stringArray(forKey: "CarPlayEnabledApps") ?? []
            let activeApps = allApps.filter { savedIDs.contains($0.id) }
            
            var gridButtons: [CPGridButton] = []
            for app in activeApps {
                let btn = CPGridButton(titleVariants: [app.name], image: UIImage(systemName: app.icon)!) { _ in
                    self.launchUrlInCar(urlStr: app.url)
                }
                gridButtons.append(btn)
            }
            
            // التعديل هنا: تم تغيير التسمية لـ gridButtons ليوافق شروط أبل ويختفي خطأ صورة 41795.jpg
            let gridTemplate = CPGridTemplate(title: "تطبيقاتي المضافة", gridButtons: gridButtons)
            self.interfaceController?.setRootTemplate(gridTemplate, animated: true)
        }
    }
    
    func launchUrlInCar(urlStr: String) {
        guard let window = carWindow, let web = carWebView else { return }
        if web.url?.absoluteString != urlStr {
            web.load(URLRequest(url: URL(string: urlStr)!))
            window.addSubview(web)
            
            let homeBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 45, height: 45))
            homeBtn.setImage(UIImage(systemName: "house.circle.fill"), for: .normal)
            homeBtn.tintColor = .white
            homeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            homeBtn.layer.cornerRadius = 22.5
            homeBtn.addTarget(self, action: #selector(goBackToGrid), for: .touchUpInside)
            window.addSubview(homeBtn)
        }
    }
    
    @objc func goBackToGrid() {
        carWebView?.removeFromSuperview()
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnect interfaceController: CPInterfaceController) {
        syncTimer?.invalidate()
        self.interfaceController = nil
    }
}

// هيكل البيانات المطلوب لتعريف التطبيقات
struct CarAppItem: Identifiable, Codable {
    let id: String
    let name: String
    let url: String
    let icon: String
}
