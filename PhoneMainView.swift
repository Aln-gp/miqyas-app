import SwiftUI
import ReplayKit

// الـ Struct الأساسي اللي كان ناقص وتسبب بالخطأ في الصورة 41808.jpg
struct CarAppItem: Identifiable, Codable {
    let id: String
    let name: String
    let url: String
    let icon: String
}

struct PhoneMainView: View {
    let availableApps = [
        CarAppItem(id: "yt", name: "YouTube", url: "https://www.youtube.com", icon: "play.rectangle.fill"),
        CarAppItem(id: "tt", name: "TikTok", url: "https://www.tiktok.com", icon: "video.circle.fill"),
        CarAppItem(id: "go", name: "Google", url: "https://www.google.com", icon: "magnifyingglass"),
        CarAppItem(id: "tw", name: "X / Twitter", url: "https://www.x.com", icon: "message.fill")
    ]
    
    @State private var addedAppIDs: [String] = ["yt", "tt", "go", "tw"]
    @State private var isMirroring = false
    let recorder = RPScreenRecorder.shared()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // قسم البث الحقيقي
                VStack {
                    Text("بث شاشة الآيفون كاملة للسيارة")
                        .font(.headline).foregroundColor(.primary)
                    
                    Button(action: toggleRealMirroring) {
                        HStack {
                            Image(systemName: isMirroring ? "stop.fill" : "play.fill")
                            Text(isMirroring ? "إيقاف البث المباشر" : "بدء بث الشاشة الحقيقي")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isMirroring ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: Color.black.withAlphaComponent(0.1), radius: 5, x: 0, y: 2)
                
                // إدارة التطبيقات
                Text("تخصيص تطبيقات شاشة السيارة")
                    .font(.subheadline).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                
                List(availableApps) { app in
                    HStack {
                        Image(systemName: app.icon).foregroundColor(.blue).font(.title3).frame(width: 35)
                        Text(app.name).font(.body)
                        Spacer()
                        
                        Button(action: { toggleApp(app.id) }) {
                            Image(systemName: addedAppIDs.contains(app.id) ? "checkmark.seal.fill" : "plus.circle")
                                .foregroundColor(addedAppIDs.contains(app.id) ? .green : .gray)
                                .font(.title2)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Yazan CarPlay")
            .onAppear(perform: loadSettings)
        }
    }
    
    func toggleApp(_ id: String) {
        if addedAppIDs.contains(id) { addedAppIDs.removeAll { $0 == id } }
        else { addedAppIDs.append(id) }
        UserDefaults.standard.set(addedAppIDs, forKey: "CarPlayEnabledApps")
    }
    
    func loadSettings() {
        addedAppIDs = UserDefaults.standard.stringArray(forKey: "CarPlayEnabledApps") ?? ["yt", "tt", "go", "tw"]
        isMirroring = UserDefaults.standard.bool(forKey: "IsScreenMirroringActive")
    }
    
    func toggleRealMirroring() {
        if isMirroring {
            recorder.stopCapture { _ in
                DispatchQueue.main.async {
                    self.isMirroring = false
                    UserDefaults.standard.set(false, forKey: "IsScreenMirroringActive")
                }
            }
        } else {
            recorder.startCapture(handler: { (_, _, _) in }) { error in
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
