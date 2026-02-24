import CoreGraphics
import Foundation
import ImageIO
import UIKit

/// 업로드 전 이미지 데이터를 리사이징 및 JPEG 압축하여 전송 크기를 줄이는 유틸리티입니다.
public enum ImageUploadOptimizer {
    /// 원본 이미지 데이터를 업로드용 JPEG 데이터로 최적화합니다.
    ///
    /// 긴 변 기준으로 이미지를 다운샘플링한 뒤 JPEG 압축을 적용합니다.
    /// 다운샘플링 또는 인코딩에 실패하면 원본 데이터를 반환합니다.
    ///
    /// - Parameters:
    ///   - data: 원본 이미지 데이터입니다.
    ///   - maxLongEdge: 다운샘플링 시 허용할 긴 변의 최대 픽셀 크기입니다. 기본값은 `1920`입니다.
    ///   - compressionQuality: JPEG 압축 품질입니다. `0.0...1.0` 범위를 사용하며 기본값은 `0.85`입니다.
    /// - Returns: 최적화된 JPEG 데이터 또는 실패 시 원본 데이터입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let optimizedData = ImageUploadOptimizer.optimizedJPEGData(
    ///     from: imageData,
    ///     maxLongEdge: 1600,
    ///     compressionQuality: 0.8
    /// )
    /// ```
    public static func optimizedJPEGData(
        from data: Data,
        maxLongEdge: CGFloat = 1920,
        compressionQuality: CGFloat = 0.85
    ) -> Data {
        guard let downsampledImage = downsampledImage(from: data, maxPixelSize: maxLongEdge) else {
            return data
        }

        return downsampledImage.jpegData(compressionQuality: compressionQuality) ?? data
    }

    private static func downsampledImage(from data: Data, maxPixelSize: CGFloat) -> UIImage? {
        let sourceOptions: CFDictionary = [
            kCGImageSourceShouldCache: false
        ] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
            return nil
        }

        let downsampleOptions: CFDictionary = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true, // respects EXIF orientation
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
