//
//  Card.swift
//  Set
//
//  Created by Roland Herzfeld on 06.03.18.
//  Copyright © 2018 Roland Herzfeld. All rights reserved.
//

import Foundation

struct Card: CustomStringConvertible, Equatable
{
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.shape == rhs.shape && lhs.color == rhs.color && lhs.alpha == rhs.alpha && lhs.amount == rhs.amount)
    }
    
    var description: String {
        return "\(shape)\(color)\(alpha)\(amount)"
    }
    
    var shape: Shape
    var color: Color
    var alpha: Alpha
    var amount: Amount
    
    enum Shape: String, CustomStringConvertible {
        var description: String { return rawValue }
        
        case one = "●"
        case two = "▲"
        case three = "■"
        
        static var all: [Shape] {
            return [.one, .two, .three]
        }
    }
    
    enum Color: String, CustomStringConvertible {
        var description: String { return rawValue }
        
        case one = "g"
        case two = "r"
        case three = "p"
        
        static var all: [Color] {
            return [.one, .two, .three]
        }
    }
    
    enum Alpha: String, CustomStringConvertible {
        var description: String { return rawValue }
        
        case one = "F"
        case two = "S"
        case three = "O"
        
        static var all: [Alpha] {
            return [.one, .two, .three]
        }
    }
    
    enum Amount: String, CustomStringConvertible {
        var description: String { return rawValue }
        
        case one = "1"
        case two = "2"
        case three = "3"
        
        static var all: [Amount] {
            return [.one, .two, .three]
        }
    }
    
}
