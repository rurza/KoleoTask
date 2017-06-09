//
//  UINavigationController+StatusBar.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return topViewController?.preferredStatusBarStyle ?? .default
        }
    }
}
