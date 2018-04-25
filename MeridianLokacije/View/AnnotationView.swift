//
//  AnnotationView.swift
//  MeridianLokacije
//
//  Created by Nikola Sabelnik on 11/16/17.
//  Copyright © 2017 SabelnikN. All rights reserved.
//

import UIKit
import MapKit

class AnnotationView: MKAnnotationView {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet var blurOverlay: UIVisualEffectView!
    
    var path = UIBezierPath()
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        popUpView()
    }
    
    func popUpView() {
        
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width/2 - 20, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height + 5))
        path.addLine(to: CGPoint(x: self.frame.size.width/2 + 20,y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width ,y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.yellow.cgColor
//        shapeLayer.cornerRadius = 10
        
        self.layer.mask = shapeLayer
       
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView != nil {
            superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside = rect.contains(point)
        if !isInside {
            for view in subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
    
    
    
}
