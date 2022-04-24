//
//  File.swift
//  Private
//
//  Created by Ikmal Azman on 21/04/2022.
//

import UIKit

extension UIImage {
    private func croppedImage(inRect rect: CGRect) -> UIImage? {
        let rad: (Double) -> CGFloat = { deg in
            return CGFloat(deg / 180.0 * .pi)
        }
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            let rotation = CGAffineTransform(rotationAngle: rad(90))
            rectTransform = rotation.translatedBy(x: 0, y: -size.height)
        case .right:
            let rotation = CGAffineTransform(rotationAngle: rad(-90))
            rectTransform = rotation.translatedBy(x: -size.width, y: 0)
        case .down:
            let rotation = CGAffineTransform(rotationAngle: rad(-180))
            rectTransform = rotation.translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = .identity
        }
        rectTransform = rectTransform.scaledBy(x: scale, y: scale)
        let transformedRect = rect.applying(rectTransform)
        let imageRef = cgImage!.cropping(to: transformedRect)!
        let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return result
    }
    
    // https://stackoverflow.com/a/34105273/9253314
    private func blurImage(withRadius radius: Double) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        let originalOrientation = self.imageOrientation
        let originalScale = self.scale
        
        let filter = CIFilter(name: "CIPixellate")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: "inputScale")
        let outputImage = filter?.outputImage

        var cgImage: CGImage?

        if let asd = outputImage {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }

        if let cgImageA = cgImage {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }

        return nil
    }

    private func drawImageInRect(inputImage: UIImage, inRect imageRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        inputImage.draw(in: imageRect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }

    func applyBlur(rect: CGRect, withRadius radius: Double) -> UIImage? {
        if let subImage = self.croppedImage(inRect: rect),
            let blurredZone = subImage.blurImage(withRadius: radius) {
            return self.drawImageInRect(inputImage: blurredZone, inRect: rect)
        }
        return nil
    }
}
