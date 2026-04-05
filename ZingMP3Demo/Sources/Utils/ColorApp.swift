import SwiftUI // Phải import SwiftUI mới có kiểu Color

extension Color {
    // Đặt tên là backgroundApp để tránh trùng với Color.background của hệ thống
    static let backgroundApp = Color(red: 18/255, green: 18/255, blue: 18/255)
    
    // Thêm màu xám nhẹ cho tên Artist giống Spotify
    static let grayText = Color(red: 179/255, green: 179/255, blue: 179/255)
    
    // Màu xanh đặc trưng nếu bạn muốn nhấn nhá
    static let zingPurple = Color(red: 136/255, green: 56/255, blue: 185/255)
}
