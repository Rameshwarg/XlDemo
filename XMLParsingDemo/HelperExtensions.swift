//
//  HelperExtensions.swift
//  XMLParsingDemo
//
//  Created by Sandeep Kakde on 01/12/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import Foundation
import  UIKit

class BaseViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var greyView: UIView!
    
    
    func activityIndicatorBegin() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = .black
        activityIndicator.layer.cornerRadius = 15.0
        activityIndicator.layer.masksToBounds = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        greyView = UIView()
        greyView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        greyView.backgroundColor = .black
        greyView.alpha = 0.6
        self.view.addSubview(greyView)
    }
    
    func activityIndicatorEnd() {
        self.activityIndicator.stopAnimating()
        self.greyView.removeFromSuperview()
    }
    
}

