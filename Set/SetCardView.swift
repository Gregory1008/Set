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
    
    var symbol: Symbol = .oval
    var colorOfSymbols: UIColor = .black
    var shading: Shading = .striped
    var numberOfSymbols: NumberOfSymbols = .one
    
   // var cardBorder: Border = .normal
    
    enum Shading {
        case solid
        case striped
        case unfilled
    }
    
    enum NumberOfSymbols {
        case one
        case two
        case three
    }
    
    enum Symbol {
        case oval
        case diamond
        case squiggle
    }
    
//    enum Border {
//        case selected
//        case normal
//        case matched
//        case notMatched
//    }
    
    // MARK: shape funktions return value is a UIBezierPath, shape functions argument is the offset in X-axis direction
    
    private func diamond(moveBy moveDistance: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX + moveDistance, y: bounds.size.height / 10))
        path.addLine(to: CGPoint(x: bounds.midX + (bounds.size.height / 8) + moveDistance, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX + moveDistance, y: bounds.size.height / 10 * 9))
        path.addLine(to: CGPoint(x: bounds.midX - (bounds.size.height / 8) + moveDistance, y: bounds.midY))
        path.close()
        return path
    }
    
    private func oval(moveBy moveDistance: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath()
        let pointP = CGPoint(x:bounds.midX - halfOvalWidth + moveDistance, y: bounds.size.height / 5)
        let pointR = CGPoint(x:bounds.midX + halfOvalWidth + moveDistance, y:( bounds.size.height / 5) * 4)
        
        path.move(to: pointP)
        path.addArc(withCenter: CGPoint(x: bounds.midX + moveDistance, y: pointP.y ), radius: halfOvalWidth, startAngle: -CGFloat.pi, endAngle: 0.0, clockwise: true)
        path.addLine(to: pointR)
        path.addArc(withCenter: CGPoint(x: bounds.midX + moveDistance, y: pointR.y), radius: halfOvalWidth, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: true)
        path.close()
        return path
    }
    
    private func squiggle(moveBy moveDistance: CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        let pointP = CGPoint(x:bounds.midX - halfSquigglelWidth + moveDistance, y: bounds.size.height / 5)
        let pointQ = CGPoint(x:bounds.midX + halfSquigglelWidth  + moveDistance, y: bounds.size.height / 5)
        let pointR = CGPoint(x:bounds.midX + halfSquigglelWidth + moveDistance, y:( bounds.size.height / 5) * 4)
        let pointS = CGPoint(x:bounds.midX - halfSquigglelWidth +  moveDistance, y:( bounds.size.height / 5) * 4)
        
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
        
         // path.lineWidth = linewidth
        
        return path
        
        // for point in [pointP, pointP1, pointP2, pointQ, pointQ1, pointQ2, pointR, pointR1, pointR2, pointS, pointS1, pointS2] {
        // point.strokePoint()
        //}
    }
    
    //  MARK: Paint 
    
    private func paint() {
        
        let createSymbol: (CGFloat) -> UIBezierPath
        
        switch symbol {
        case .diamond:
            createSymbol = diamond(moveBy:)
        case .oval:
            createSymbol = oval(moveBy:)
        case .squiggle:
            createSymbol = squiggle(moveBy:)
        }
        
        let path = UIBezierPath()
        path.lineWidth = linewidth
        switch numberOfSymbols {
        case .one:
        path.append(createSymbol(0.0))
        case .two:
            path.append(createSymbol(-twoSymbolOffset))
            path.append(createSymbol( twoSymbolOffset))
        case .three:
            path.append(createSymbol( -threeSymbolOffset))
            path.append(createSymbol( 0.0))
            path.append(createSymbol( threeSymbolOffset))
        }
        
        colorOfSymbols.set()
        
        switch shading {
        case .solid:
            path.fill()
        case .unfilled:
            path.stroke()
        case .striped:
            path.stroke()
            path.addClip()
            let stripes = UIBezierPath()
            stripes.lineWidth = linewidth
           for stripeY in stride(from:bounds.minY, through:bounds.maxY, by: bounds.size.height / 17) {
            let stripePath  = UIBezierPath()
            //stripePath.lineWidth = linewidth
            stripePath.move(to: CGPoint(x: bounds.minX, y: stripeY))
            stripePath.addLine(to: CGPoint(x: bounds.maxX, y: stripeY))
            stripes.append(stripePath)
            }
            stripes.stroke()
        }
        
    }
    
    
    // 😀😀😀😀😀

    override func draw(_ rect: CGRect) {
        self.isOpaque = true
        self.backgroundColor = .clear
       let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        // let rect = UIBezierPath(rect: bounds)
        #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).set()
        roundedRect.fill()
        paint()
    }
    
    // 🤢🤢🤢🤢🤢
    
    private struct Constants {
        
        static let cornerRadiusToBoundsHeight: CGFloat = 4.0
        static let upperLeftControlOffsetToCardHeightX: CGFloat = 0.1
        static let upperLeftControlOffsetToCardHeightY: CGFloat = 0.1
        static let upperRightControlOffsetToCardHeightX: CGFloat = 0.1
        static let upperRightControlOffsetToCardHeightY: CGFloat = 0.1
        
        static let lowerLeftControlOffsetToCardHeightX: CGFloat = 0.15
        static let lowerLeftControlOffsetToCardHeightY: CGFloat = 0.2
        static let lowerRightControlOffsetToCardHeightX: CGFloat = 0.15
        static let lowerRightControlOffsetToCardHeightY: CGFloat = 0.2
        
        static let halfSquigglelWidthToCardHeight: CGFloat = 0.083
        static let halfOvalWidthToCardHeight: CGFloat = 0.105
        static let twoSymbolOffsetToCardHeight: CGFloat = 0.2
        static let threeSymbolOffsetToCardHeight: CGFloat = 0.4
        
        static let linewidthToCardHeight: CGFloat = 0.02
        
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
    
    
    private var halfSquigglelWidth: CGFloat { return bounds.size.height * Constants.halfSquigglelWidthToCardHeight }
    private var halfOvalWidth: CGFloat { return bounds.size.height * Constants.halfOvalWidthToCardHeight }
    private var twoSymbolOffset: CGFloat { return bounds.size.height * Constants.twoSymbolOffsetToCardHeight }
    private var threeSymbolOffset: CGFloat { return bounds.size.height * Constants.threeSymbolOffsetToCardHeight }
    private var linewidth: CGFloat { return bounds.size.height * Constants.linewidthToCardHeight }
    
    var cornerRadius: CGFloat {
       return bounds.size.height / Constants.cornerRadiusToBoundsHeight
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
