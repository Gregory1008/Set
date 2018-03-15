//
//  ViewController.swift
//  Set
//
//  Created by Roland Herzfeld on 06.03.18.
//  Copyright © 2018 Roland Herzfeld. All rights reserved.
//

import UIKit

class SetViewController: UIViewController
{

    @IBAction func touchCard(_ sender: UIButton) {
        game.selectCard(at: cardButtons.index(of: sender)!)
        updateViewFromModel()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func deal3Cards(_ sender: UIButton) {
        
    }
    
    lazy var game = SetGame()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...4 {
            game.deal3Cards()
            
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in game.cardsInPlay.indices {
            let button = cardButtons[index]
            let card = game.cardsInPlay[index]
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            button.layer.cornerRadius = 0
            button.setAttributedTitle(symbol(for: card), for: .normal)
        }
        if game.selectedCards.count > 0 {
            for selectedCard in game.selectedCards {
                let index = game.cardsInPlay.index(of: selectedCard)!
                cardButtons[index].layer.borderWidth = 3
                if game.matchedCards.count > 2 {
                    cardButtons[index].layer.borderColor = UIColor.green.cgColor
                } else if game.selectedCards.count == 3 {
                    cardButtons[index].layer.borderColor = UIColor.red.cgColor
                } else {
                    cardButtons[index].layer.borderColor = UIColor.gray.cgColor
                }
                cardButtons[index].layer.cornerRadius = 8.0
            }
        }
        game.hiddenCards.forEach { let hiddenIndex = game.cardsInPlay.index(of: $0)!
            cardButtons[hiddenIndex].setTitle(nil , for: .normal)
            cardButtons[hiddenIndex].setAttributedTitle(nil , for: .normal)
        }
        for index in game.cardsInPlay.count..<cardButtons.count{
            cardButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        scoreLabel.text = String(game.score)
    }
    
   
//    private var symbolColor = UIColor.black
    
    private func symbol(for card: Card) -> NSAttributedString {
        let shape = card.shape.rawValue
        let shapeAndAmount: String = {
            switch card.amount {
            case .one:
                return shape
            case .two:
                return shape + " " + shape
            case .three:
                return shape + " " + shape + " " + shape
           
            }
        }()
        let symbolColor: UIColor = {
            switch card.color {
            case .one:
                return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .two:
                return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case .three:
                return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            
            }
        }()
        let attributes: [NSAttributedStringKey:Any] = {
            switch card.alpha {
            case .one: return [ .foregroundColor: symbolColor.withAlphaComponent(1.0), .strokeColor: symbolColor]
            case .two: return  [ .foregroundColor: symbolColor.withAlphaComponent(0.4), .strokeColor: symbolColor]
            case .three: return [ .strokeWidth: 10.0, .strokeColor: symbolColor]
            }
        }()
        return NSAttributedString(string: shapeAndAmount, attributes:attributes )
    }
    
}

