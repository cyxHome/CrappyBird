//
//  Extensions.swift
//  CrappyBirds
//
//  Created by caoyuxin on 4/7/16.
//  Copyright © 2016 Daniel Hauagge. All rights reserved.
//
import UIKit
import Foundation
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}