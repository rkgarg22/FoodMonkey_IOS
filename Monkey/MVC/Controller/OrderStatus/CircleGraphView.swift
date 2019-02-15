//
//  CircleGraphView.swift
//  Swift Ring Graph
//
//  Created by Steven Lipton on 3/10/15.
//  Copyright (c) 2015 MakeAppPie.Com. All rights reserved.
//

import UIKit

class CircleGraphView: UIView {
    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    var arcWidth:CGFloat = 10.0
    var arcColor = UIColor.yellow
    var arcBackgroundColor = UIColor.black
    var isPie = false
    
    override func draw(_ rect: CGRect) {
        
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = -0.5 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
        
        //find the centerpoint of the rect
        var centerPoint = CGPoint.init(x:rect.midX, y: rect.midY)
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if rect.width > rect.height{
            radius = (rect.width - arcWidth) / 2.0
        }else{
            radius = (rect.height - arcWidth) / 2.0
        }
       
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        let colorspace = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        context!.setLineWidth(arcWidth)
        context!.setLineCap(CGLineCap.round)
        
        //make the circle background
        
        context!.setStrokeColor(arcBackgroundColor.cgColor)
        context!.setFillColor(arcBackgroundColor.cgColor)
      //  CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        context?.addArc(center: CGPoint.init(x: centerPoint.x, y: centerPoint.y), radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: true)
        context!.strokePath()
        

        //draw the arc or pie
        
        if isPie {
            context!.setFillColor(arcColor.cgColor)
            context?.move(to: CGPoint.init(x: centerPoint.x, y: centerPoint.y))
            //CGContextMoveToPoint(context, , centerPoint.y)
          //  CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
            context?.addArc(center: CGPoint.init(x: centerPoint.x, y: centerPoint.y), radius: radius, startAngle: start, endAngle: end, clockwise: false)
            context?.fillPath()
        }else{
            context!.setStrokeColor(arcColor.cgColor)
            context!.setLineWidth(arcWidth * 0.8 )
            //CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
            context?.addArc(center: CGPoint.init(x: centerPoint.x, y: centerPoint.y), radius: radius, startAngle: start, endAngle: end, clockwise: false)
            context?.strokePath()
        }
        
    }

}
