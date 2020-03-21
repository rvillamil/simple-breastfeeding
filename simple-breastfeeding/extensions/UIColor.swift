//
//  NSColor.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 1/8/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Setup custom colours we can use throughout the app using hex values
    static let rbTextChronometerStopped = UIColor(hex: 0xE82A71) // Rosa fuerte
    static let rbTextChronometerRunning = UIColor(hex: 0xD0021B)
    
        
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
