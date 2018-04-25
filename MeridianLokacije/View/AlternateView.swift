//
//  AlternateView.swift
//  MeridianLokacije
//
//  Created by Nikola Sabelnik on 11/7/17.
//  Copyright © 2017 SabelnikN. All rights reserved.
//

import UIKit

@IBDesignable

class AlternateView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        
        didSet {
         
            setView()
            
        }
    }
    
    
    func setView() {
        
        layer.cornerRadius = cornerRadius
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5.0
        
    }
    
    
    
}
