import SwiftUI // Phải import SwiftUI mới có kiểu Color

extension Color {
    // Đặt tên là backgroundApp để tránh trùng với Color.background của hệ thống
    static let backgroundApp = Color(red: 18/255, green: 18/255, blue: 18/255)
    
    // Thêm màu xám nhẹ cho tên Artist giống Spotify
    static let grayText = Color(red: 179/255, green: 179/255, blue: 179/255)
    
    // Màu xanh đặc trưng nếu bạn muốn nhấn nhá
    static let zingPurple = Color(red: 136/255, green: 56/255, blue: 185/255)
}
extension Color {
    func lighter(by amount: CGFloat = 0.2) -> Color {
        // Chuyển Color sang UIColor để lấy thông số HSB
        let uiColor = UIColor(self)
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        // Trả về màu mới với Brightness tăng lên và Saturation giảm đi một chút để tươi hơn
        return Color(UIComponents: (h, max(s - amount/2, 0), min(b + amount, 1.0), a))
    }
}

// Hàm bổ trợ để khởi tạo Color từ bộ HSB
extension Color {
    init(UIComponents components: (CGFloat, CGFloat, CGFloat, CGFloat)) {
        self.init(hue: components.0, saturation: components.1, brightness: components.2, opacity: components.3)
    }
}
