import UIKit
import SwiftUI

extension UIImage {
    // Hàm lấy màu trung bình của tấm ảnh
    var averageColor: Color? {
        guard let inputImage = CIImage(image: self) else { return nil }
        
        // Tạo bộ lọc để thu nhỏ ảnh về 1x1 pixel (lấy màu trung bình)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                   y: inputImage.extent.origin.y,
                                   z: inputImage.extent.size.width,
                                   w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [
            kCIInputImageKey: inputImage,
            kCIInputExtentKey: extentVector
        ]) else { return nil }
        
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        
        // Vẽ pixel đó ra để lấy thông số RGBA
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        return Color(red: CGFloat(bitmap[0]) / 255,
                     green: CGFloat(bitmap[1]) / 255,
                     blue: CGFloat(bitmap[2]) / 255)
    }
}
