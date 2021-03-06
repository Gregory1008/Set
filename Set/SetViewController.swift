//
//  SetViewController.swift
//  Set
//
//  Created by Roland Herzfeld on 06.03.18.
//  Copyright © 2018 Roland Herzfeld. All rights reserved.
//
//  See the rules of Set to play the game
//  Swipe down to deal three cards
//  RotateGesture with an angle of PI/4 shuffles the cards in play

import UIKit

class SetViewController: UIViewController
{
    var game = SetGame()
    
    private var visibleCardsInPlay: [Card] {
        return game.cardsInPlay.filter { !game.hiddenCards.contains($0)}
    }
    
    @IBOutlet weak var setGameView: SetGameView!
    @IBAction func deal3Cards(_ sender: UIButton) {
        deal3CardsAndUpdateView()
    }
    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        for _ in 1...4 {
            game.deal3Cards()
        }
        print("newGameButton UpdateViewFromModel")
        updateViewFromModel()
    }
    
    private lazy var grid = Grid(layout: .aspectRatio(8/5))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCard(_:))))
        setGameView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(shuffleGamesCardsInPlay(_:))))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(deal3CardsAndUpdateView))
        swipeDown.direction = .down
        setGameView.addGestureRecognizer(swipeDown)
        for _ in 1...4 {
            game.deal3Cards()
        }
        //print("viewDidLoad UpdateViewFromModel")
        updateViewFromModel()
    }
    
    @objc private func deal3CardsAndUpdateView() {
        if game.matchedCards.isEmpty {
            for subview in setGameView.subviews {
                subview.removeFromSuperview()
            }
            game.deal3Cards()
        } else {
            if game.deck.isEmpty {
                for subview in setGameView.subviews {
                    subview.removeFromSuperview()
                }
            }
            game.replaceOrHideMatchedCards()
        }
        
        print("deal3Cards UpdateViewFormModel")
        updateViewFromModel()
    }
    
    @objc private func shuffleGamesCardsInPlay(_ recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .changed,.ended:
            if abs(recognizer.rotation) > CGFloat.pi / 4  {
                game.shuffleCardsInPlay()
                //print("shuffleGameCardsInPlay Button UpdateViewFromModel")
                updateViewFromModel()
                recognizer.rotation = 0.0
            }
            print(recognizer.rotation, separator: " ", terminator: " ")
        default:
            break
        }
    }
    
    @objc private func selectCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            let touchPoint = recognizer.location(in: setGameView)
            visibleCardsLoop: for index in 0 ..< visibleCardsInPlay.count {
                if (grid[index]?.contains(touchPoint))!{
                    print(index)
                    if !game.matchedCards.isEmpty {
                        for subview in setGameView.subviews {
                            subview.removeFromSuperview()
                        }
                    }
                    game.selectCard(at: game.cardsInPlay.index(of: visibleCardsInPlay[index])!)
                    //print("selectCard Button updateViewFromModel     ", separator: " ", terminator: "")
                    updateViewFromModel()
                    break // visibleCardsLoop
                }
            }
        default:
            break
        }
    }
    
    private func updateScoreLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 5.0,
            .strokeColor : UIColor.black
        ]
        let attributedString = NSAttributedString(
            string:   "Score: \(game.score)" ,
            attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for subview in setGameView.subviews {
            subview.removeFromSuperview()
        }
        //print("viewDidLayoutSubviews UpdateViewFromModel")
        updateViewFromModel()
    }
    
    private let cardColors = [Card.Color.one: UIColor.green, .two:.red, .three: .purple ]
    private let cardAmounts = [ Card.Amount.one: SetCardView.NumberOfSymbols.one, .two: .two, .three: .three]
    private let cardShadings = [ Card.Alpha.one: SetCardView.Shading.solid, .two: .striped, .three: .unfilled]
    private let cardSymbols = [ Card.Shape.one: SetCardView.Symbol.diamond, .two: .oval, .three: .squiggle]
    
    
    private func updateViewFromModel() {
        
        grid.frame = CGRect(
            origin: CGPoint(x: setGameView.bounds.minX ,y: setGameView.bounds.minY),
            size: CGSize(width: setGameView.frame.size.width, height: setGameView.frame.size.height))
        grid.cellCount = visibleCardsInPlay.count
        //print("visibleCardsInPlay.count: \(visibleCardsInPlay.count)")
        for index in 0 ..< visibleCardsInPlay.count {
            // print(index, separator: " ", terminator: " ")
            let card = visibleCardsInPlay[index]
            let setCardView = SetCardView()
            setGameView.addSubview(setCardView)
            setCardView.frame.origin = (self.grid[index]?.origin)!
            setCardView.frame.size = grid.cellSize
            setCardView.frame = setCardView.frame.insetBy(dx: grid.cellSize.width / Constants.setCardViewInset, dy: grid.cellSize.height / Constants.setCardViewInset)

            setCardView.backgroundColor = .clear
            
            setCardView.colorOfSymbols = cardColors[card.color]!
            setCardView.numberOfSymbols = cardAmounts[card.amount]!
            setCardView.shading = cardShadings[card.alpha]!
            setCardView.symbol = cardSymbols[card.shape]!
            setCardView.layer.cornerRadius = setCardView.frame.height / Constants.cornerRadiusToViewHeight
            setCardView.layer.borderWidth = setCardView.frame.height / Constants.borderWidthToViewHeight
            setCardView.layer.borderColor = UIColor.lightGray.cgColor
            if game.selectedCards.contains(card) {
                setCardView.layer.borderWidth = setCardView.frame.height / Constants.selectedOrMatchedBorderWidthToViewHeight
                setCardView.layer.borderColor  = UIColor.gray.cgColor
            }
            if game.matchedCards.contains(card) {
                setCardView.layer.borderWidth = setCardView.frame.height / Constants.selectedOrMatchedBorderWidthToViewHeight
                setCardView.layer.borderColor = UIColor.green.cgColor
            }
            
            
            
            
        }
        updateScoreLabel()
        //print("updated ScoreLabel")
    }
    
    private struct Constants {
        static let cornerRadiusToViewHeight: CGFloat = 4
        static let borderWidthToViewHeight: CGFloat = 30
        static let selectedOrMatchedBorderWidthToViewHeight: CGFloat = 15
        static let setCardViewInset: CGFloat = 16
    }
    
    
}

