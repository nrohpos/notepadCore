//
//  File.swift
//  
//
//  Created by Eang Tithsophorn on 15/8/23.
//

import Foundation
import UIKit

@IBDesignable
/// EdgeInsetLabel is a just a label
/// with textpadding LTRB
/// also included the blur function
public class EdgeInsetLabel: UILabel {
    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public var isBlurring = false {
        didSet {
            setNeedsDisplay()
        }
    }

    public var blurRadius: Double = 2.5 {
        didSet {
            blurFilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        }
    }
    
    
    public lazy var blurFilter: CIFilter? = {
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        blurFilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
        return blurFilter
    }()
    

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                left: -textInsets.left,
                bottom: -textInsets.bottom,
                right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.isOpaque = false
        layer.needsDisplayOnBoundsChange = true
        layer.contentsScale = UIScreen.main.scale
        layer.contentsGravity = .center
        isOpaque = false
        isUserInteractionEnabled = false
        contentMode = .redraw
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func display(_ layer: CALayer) {
        let bounds = layer.bounds
        guard !bounds.isEmpty && bounds.size.width < CGFloat(UINT16_MAX) else {
            layer.contents = nil
            return
        }
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, layer.contentsScale)
        if let ctx = UIGraphicsGetCurrentContext() {
            self.layer.draw(in: ctx)
        
            var image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
            if isBlurring, let cgImage = image {
                blurFilter?.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
                let ciContext = CIContext(cgContext: ctx, options: nil)
                if let blurOutputImage = blurFilter?.outputImage,
                   let cgImage = ciContext.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
                    image = cgImage
                }
            }
            layer.contents = image
        }
        UIGraphicsEndImageContext()
    }
}

extension EdgeInsetLabel {
    @IBInspectable
    public var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }

    @IBInspectable
    public var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }

    @IBInspectable
    public var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }

    @IBInspectable
    public  var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

