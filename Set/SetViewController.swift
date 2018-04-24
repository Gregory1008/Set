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
        game.selectCard(at: visibleCardButtons.index(of: sender)!)
        updateViewFromModel()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter {!$0.superview!.isHidden }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @IBAction func newGame() {
        game = SetGame()
        for _ in 1...4 {
            game.deal3Cards()
        }
        updateViewFromModel()
    }
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var deal3CardsLabel: UIButton!
    
    @IBAction func deal3Cards(_ sender: UIButton) {
        if deal3CardsLabel.backgroundColor == #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) {
            if game.matchedCards.count == 3 {
                game.replaceOrHideMatchedCards()
            } else {
                game.deal3Cards()
            }
            updateViewFromModel()
        }
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
            let button = visibleCardButtons[index]
            let card = game.cardsInPlay[index]
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            button.layer.cornerRadius = 0
            button.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            button.setAttributedTitle(symbol(for: card), for: .normal)
        }
        if game.selectedCards.count > 0 {
            for selectedCard in game.selectedCards {
                let index = game.cardsInPlay.index(of: selectedCard)!
                visibleCardButtons[index].layer.borderWidth = 3
                if game.matchedCards.count > 2 {
                    visibleCardButtons[index].layer.borderColor = #colorLiteral(red: 0, green: 0.6077857614, blue: 0, alpha: 1)
                } else if game.selectedCards.count == 3 {
                    visibleCardButtons[index].layer.borderColor = UIColor.red.cgColor
                } else {
                    visibleCardButtons[index].layer.borderColor = UIColor.gray.cgColor
                }
                visibleCardButtons[index].layer.cornerRadius = 8.0
            }
        }
        game.hiddenCards.forEach { let hiddenIndex = game.cardsInPlay.index(of: $0)!
            visibleCardButtons[hiddenIndex].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            visibleCardButtons[hiddenIndex].setTitle(nil , for: .normal)
            visibleCardButtons[hiddenIndex].setAttributedTitle(nil , for: .normal)
        }
        for index in game.cardsInPlay.count..<visibleCardButtons.count{
            visibleCardButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            visibleCardButtons[index].setTitle(nil , for: .normal)
            visibleCardButtons[index].setAttributedTitle(nil , for: .normal)
        }
        
        scoreLabel.text = "Score: \(game.score)"
        
        if (visibleCardButtons.count > game.cardsInPlay.count) || (game.deck.count > 0 && !game.matchedCards.isEmpty) {
            deal3CardsLabel.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            deal3CardsLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5507199764, blue: 0.4773244262, alpha: 1)
        }
    }
    
   
//    private var symbolColor = UIColor.black
    
    private func symbol(for card: Card) -> NSAttributedString {
        let shape : String = {
            switch card.shape {
            case .one:
                return "●"
            case .two:
                return "▲"
            case .three:
                return "■"
            }
        }()
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
            case .one: return [ .foregroundColor: symbolColor.withAlphaComponent(1.0), .strokeColor: symbolColor, .font: UIFont.systemFont(ofSize: 20)]
            case .two: return  [ .foregroundColor: symbolColor.withAlphaComponent(0.4), .strokeColor: symbolColor, .font: UIFont.systemFont(ofSize: 20)]
            case .three: return [ .strokeWidth: 10.0, .strokeColor: symbolColor, .font: UIFont.systemFont(ofSize: 20)]
            }
        }()
        return NSAttributedString(string: shapeAndAmount, attributes:attributes )
    }
    
}

