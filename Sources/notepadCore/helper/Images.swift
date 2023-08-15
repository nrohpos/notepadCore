//
//  Images.swift
//  
//
//  Created by Eang Tithsophorn on 15/8/23.
//

import Foundation
import UIKit
public enum Images: String {
    case imgGreenMonster = "img_green_monster"
}


public extension UIImage {
    convenience init?(img: Images) {
        self.init(named: img.rawValue, in: .module, compatibleWith: .current)
    }
}
