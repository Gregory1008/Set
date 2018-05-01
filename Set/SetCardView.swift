//
//  SetCardView.swift
//  Set
//
//  Created by Roland Herzfeld on 24.04.18.
//  Copyright © 2018 Roland Herzfeld. All rights reserved.
//

import UIKit


@IBDesignable
class SetCardView: UIView {
    
//    @IBInspectable
//    var p1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var yp1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var p2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var yp2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//
//    @IBInspectable
//    var q1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var yq1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var q2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var yq2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//
//   @IBInspectable
//    var r1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var yr1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var r2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var yr2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//
//   @IBInspectable
//    var s1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var ys1: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var s2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//    @IBInspectable
//    var ys2: CGFloat = 0.0 { didSet { setNeedsDisplay()}}
//
 
    

    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.red.setFill()
        UIColor.green.setStroke()
        roundedRect.lineWidth = 8
        roundedRect.fill()
        roundedRect.stroke()
        
        UIColor.white.set()
        let rect = UIBezierPath()
        rect.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        rect.addLine(to: CGPoint(x: bounds.minX + 50, y: bounds.minY ))
        rect.addLine(to: CGPoint(x: bounds.minX + 50, y: bounds.minY + 214))
        rect.lineWidth = 2
        rect.stroke()

        moveAndStrokeSquiggle(by: bounds.size.height / 5)
        
    }
    
    private func moveAndStrokeSquiggle(by moveDistance: CGFloat) {
        let path = UIBezierPath()
        let pointP = CGPoint(x:bounds.midX - (bounds.size.height / 12 ) + moveDistance, y: bounds.size.height / 5)
        let pointQ = CGPoint(x:bounds.midX + (bounds.size.height / 12 )  + moveDistance, y: bounds.size.height / 5)
        let pointR = CGPoint(x:bounds.midX + (bounds.size.height / 12 ) + moveDistance, y:( bounds.size.height / 5) * 4)
        let pointS = CGPoint(x:bounds.midX - (bounds.size.height / 12 ) +  moveDistance, y:( bounds.size.height / 5) * 4)
        
        let pointP1 = pointP.offsetBy(dx: -upperLeftOffsetX , dy: -upperLeftOffsetY )
        let pointP2 = pointQ.offsetBy(dx: -upperRightOffsetX , dy: -upperRightOffsetY )
        
        let pointQ1 = pointQ.offsetBy(dx: lowerRightOffsetX , dy: lowerRightOffsetY )
        let pointQ2 = pointR.offsetBy(dx: -lowerLeftOffsetX , dy: -lowerLeftOffsetY )
        
        let pointR1 = pointR.offsetBy(dx: upperLeftOffsetX , dy: upperLeftOffsetY )
        let pointR2 = pointS.offsetBy(dx: upperRightOffsetX , dy: upperRightOffsetY )
        
        let pointS1 = pointS.offsetBy(dx: -lowerRightOffsetX , dy: -lowerRightOffsetY )
        let pointS2 = pointP.offsetBy(dx: lowerLeftOffsetX , dy: lowerLeftOffsetY )
        
        path.move(to: pointP)
        path.addCurve(to: pointQ, controlPoint1: pointP1, controlPoint2: pointP2)
        path.addCurve(to: pointR, controlPoint1: pointQ1, controlPoint2: pointQ2)
        path.addCurve(to: pointS, controlPoint1: pointR1, controlPoint2: pointR2)
        path.addCurve(to: pointP, controlPoint1: pointS1, controlPoint2: pointS2)
        path.lineWidth = 2.0
        UIColor.green.set()
        path.stroke()
        
        for point in [pointP, pointP1, pointP2, pointQ, pointQ1, pointQ2, pointR, pointR1, pointR2, pointS, pointS1, pointS2] {
            point.strokePoint()
        }
    }
    
    
    private struct Constants {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.15
        static let upperLeftControlOffsetToCardHeightX: CGFloat = 0.1
        static let upperLeftControlOffsetToCardHeightY: CGFloat = 0.1
        static let upperRightControlOffsetToCardHeightX: CGFloat = 0.1
        static let upperRightControlOffsetToCardHeightY: CGFloat = 0.1
        static let lowerLeftControlOffsetToCardHeightX: CGFloat = 0.15
        static let lowerLeftControlOffsetToCardHeightY: CGFloat = 0.2
        static let lowerRightControlOffsetToCardHeightX: CGFloat = 0.15
        static let lowerRightControlOffsetToCardHeightY: CGFloat = 0.2
        }
    // upper half of the card --- the lower half is mirrored accordingly
    private var upperLeftOffsetX: CGFloat {  return bounds.size.height * Constants.upperLeftControlOffsetToCardHeightX }
    private var upperLeftOffsetY: CGFloat { return bounds.size.height * Constants.upperLeftControlOffsetToCardHeightY }
    private var upperRightOffsetX: CGFloat { return bounds.size.height * Constants.upperRightControlOffsetToCardHeightX }
    private var upperRightOffsetY: CGFloat { return bounds.size.height * Constants.upperRightControlOffsetToCardHeightY }
    private var lowerLeftOffsetX: CGFloat { return bounds.size.height * Constants.lowerLeftControlOffsetToCardHeightX }
    private var lowerLeftOffsetY: CGFloat { return bounds.size.height * Constants.lowerLeftControlOffsetToCardHeightY }
    private var lowerRightOffsetX: CGFloat { return bounds.size.height * Constants.lowerRightControlOffsetToCardHeightX }
    private var lowerRightOffsetY: CGFloat { return bounds.size.height * Constants.lowerRightControlOffsetToCardHeightY }
    
    
    var cornerRadius: CGFloat {
       return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
}

extension CGPoint {
    func offsetBy( dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx , y: self.y + dy)
    }
    func strokePoint()  {
        let path = UIBezierPath()
        path.move(to: self.offsetBy(dx: 2, dy: 2))
        path.addArc(withCenter: self, radius: 2, startAngle: 0.0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.lineWidth = 1
        UIColor.white.set()
        path.stroke()
    }
}
