import SwiftUI

struct SliderCustom: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State private var isDragging: Bool = false
    @State private var dragLocation: CGFloat = 0
    
    // Các tham số cấu hình để tái sử dụng
    var height: CGFloat = 4          // Độ dày thanh nhạc
    var heightFrame: CGFloat = 20    // Vùng chạm (bấm)
    var showThumb: Bool = true       // Có hiện cục tròn hay không
    var accentColor: Color = .white  // Màu thanh tiến độ

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let progressPercentage = viewModel.duration > 0 ? (viewModel.currentTime / viewModel.duration) : 0
            let currentWidth = isDragging ? dragLocation : (totalWidth * CGFloat(progressPercentage))

            ZStack(alignment: .leading) {
                // 1. THANH NỀN (Track)
                Rectangle()
                    .fill(Color.white.opacity(showThumb ? 0.2 : 0.1))
                    .frame(height: height)

                // 2. THANH TIẾN ĐỘ (Progress)
                Rectangle()
                    .fill(accentColor)
                    .frame(width: max(0, min(currentWidth, totalWidth)), height: height)

                // 3. CỤC TRÒN (Thumb) - Chỉ hiện khi showThumb = true
                if showThumb {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 12, height: 12)
                        .shadow(radius: 2)
                        .offset(x: max(0, min(currentWidth - 6, totalWidth - 12)))
                        // Nếu đang kéo thì hiện rõ, không kéo thì mờ đi một chút (giống Spotify)
                        .opacity(isDragging ? 1 : 0.8)
                        .animation(.easeInOut(duration: 0.1), value: isDragging)
                }
            }
            .frame(height: heightFrame)
            .contentShape(Rectangle())
            .gesture(
                // Chỉ cho phép kéo nếu showThumb = true (trong Player to)
                showThumb ?
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        dragLocation = value.location.x
                        let percentage = max(0, min(value.location.x / totalWidth, 1))
                        viewModel.seek(to: Double(percentage) * viewModel.duration)
                    }
                    .onEnded { _ in isDragging = false }
                : nil // Trong Mini Player thì không cho kéo (hoặc tùy Daz)
            )
        }
        .frame(height: heightFrame)
    }
}
