import SwiftUI
import ReplayKit

struct PhoneMainView: View {
    // قائمة المواقع الجاهزة للاختيار
    let availableApps = [
        CarAppItem(id: "yt", name: "YouTube", url: "https://www.youtube.com", icon: "play.rectangle.fill"),
        CarAppItem(id: "tt", name: "TikTok", url: "https://www.tiktok.com", icon: "video.circle.fill"),
        CarAppItem(id: "go", name: "Google", url: "https://www.google.com", icon: "magnifyingglass"),
        CarAppItem(id: "tw", name: "X / Twitter", url: "https://www.x.com", icon: "message.fill")
    ]
    
    @State private var addedAppIDs: [String] = []
    @State private var isMirroring = false
    let recorder = RPScreenRecorder.shared()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // ميزة 1: بث شاشة الجوال
                VStack(alignment: .leading) {
                    Text("بث الشاشة الكامل للسيارة")
                        .font(.caption).foregroundColor(.gray).padding(.horizontal)
                    
                    Button(action: toggleMirroring) {
                        HStack {
                            Image(systemName: isMirroring ? "stop.circle.fill" : "tv.and.mediabox.fill")
                            Text(isMirroring ? "إيقاف بث شاشة الآيفون" : "بدء بث الشاشة المباشر")
                        }
                        .font(.headline) // تعديل: تم استخدام .font(.headline) البديل الآمن لـ .bold()
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(isMirroring ? Color.red : Color.blue)
                        .foregroundColor(.white).cornerRadius(10).padding(.horizontal)
                    }
                }
                .padding(.vertical, 10).background(Color(.secondarySystemBackground)).cornerRadius(12).padding(.horizontal)
                
                // ميزة 2: إضافة التطبيقات بالزر الأخضر
                Text("إضافة تطبيقات ومتصفحات لشاشة السيارة")
                    .font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                
                List(availableApps) { app in
                    HStack {
                        Image(systemName: app.icon).font(.title2).frame(width: 40)
                        Text(app.name).font(.headline)
                        Spacer()
                        
                        // الزر الأخضر (+) للإضافة أو الحذف
                        Button(action: { toggleApp(app.id) }) {
                            Image(systemName: addedAppIDs.contains(app.id) ? "checkmark.circle.fill" : "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        }
                    }
                }
            }
            .navigationTitle("ريموت الكاربلاي")
            .onAppear(perform: loadSettings)
        }
    }
    
    func toggleApp(_ id: String) {
        if addedAppIDs.contains(id) { addedAppIDs.removeAll { $0 == id } }
        else { addedAppIDs.append(id) }
        UserDefaults.standard.set(addedAppIDs, forKey: "CarPlayEnabledApps")
    }
    
    func loadSettings() {
        addedAppIDs = UserDefaults.standard.stringArray(forKey: "CarPlayEnabledApps") ?? []
    }
    
    func toggleMirroring() {
        if isMirroring {
            recorder.stopCapture { _ in
                DispatchQueue.main.async {
                    self.isMirroring = false
                    UserDefaults.standard.set(false, forKey: "IsScreenMirroringActive")
                }
            }
        } else {
            recorder.startCapture(handler: { _, _, _ in }) { error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.isMirroring = true
                        UserDefaults.standard.set(true, forKey: "IsScreenMirroringActive")
                    }
                }
            }
        }
    }
}
