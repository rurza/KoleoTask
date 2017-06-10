//
//  RoundedButton.swift
//  Demeo
//
//  Created by rurza on 10/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var border: CGFloat = 0 {
        didSet {
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = border
        }
    }

}
