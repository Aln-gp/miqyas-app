import SwiftUI

struct PhoneMainView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "safari.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("متصفح يزن للكاربلاي")
                .font(.title2)
                .bold()
            
            Text("اشبك الجوال بالسيارة وسيفتح المتصفح تلقائياً على الشاشة الكبيرة.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
