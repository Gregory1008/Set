//
//  SetGame.swift
//  Set
//
//  Created by Roland Herzfeld on 07.03.18.
//  Copyright © 2018 Roland Herzfeld. All rights reserved.
//

import Foundation

class  SetGame
{
    
    private(set) var deck = [Card]()
    private(set) var cardsInPlay = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var matchedCards = [Card]()
    private(set) var hiddenCards = [Card]()
    private(set) var score = 0
    
    func draw()  {
        if !deck.isEmpty {
            cardsInPlay.append(deck.remove(at: deck.count.arc4random))
        }
    }
    
    func deal3Cards() {
        if deck.count > 2 {
            for _ in 1...3 {
                draw()
            }
        }
        print(cardsInPlay)
    }
    
    func shuffleCardsInPlay() {
        var tempCards = [Card]()
        for _ in 0..<cardsInPlay.count {
            tempCards.append(cardsInPlay.remove(at: cardsInPlay.count.arc4random))
        }
        cardsInPlay = tempCards
    }
    
    func replaceOrHideMatchedCards() {
        for card in matchedCards {
            if deck.isEmpty {
                print(card)
                hiddenCards.append(card)
            } else {
                cardsInPlay[cardsInPlay.index(of: card)!] = deck.remove(at: deck.count.arc4random)
            }
        }
        matchedCards.removeAll()
        selectedCards.removeAll()
    }
    
    
    func selectCard(at index: Int) {
        print(index)
        if cardsInPlay.count > index {
            let chosenCard = cardsInPlay[index]
            if !hiddenCards.contains(chosenCard){
                if !matchedCards.isEmpty, matchedCards.contains(chosenCard) {
                    replaceOrHideMatchedCards()
                }else if !matchedCards.isEmpty {
                    replaceOrHideMatchedCards()
                    selectedCards.append(chosenCard)
                } else if selectedCards.count == 3 {
                    selectedCards.removeAll()
                    selectedCards.append(chosenCard)
                    score -= 5
                } else if selectedCards.count < 3 {
                    if !selectedCards.contains(chosenCard) {
                        selectedCards.append(chosenCard)
                    } else {
                        selectedCards.remove(at: selectedCards.index(of: chosenCard)!)
                        score -= 1
                    }
                }
                if selectedCards.count == 3 {
                    checkForMatch()
                }
            }
        }
    }
    
    private func checkForMatch() {
        if (selectedCards.map {$0.shape }.uniquified.oddCount &&
            selectedCards.map { $0.color}.uniquified.oddCount &&
            selectedCards.map {$0.alpha}.uniquified.oddCount &&
            selectedCards.map { $0.amount}.uniquified.oddCount) {
            selectedCards.forEach { matchedCards.append($0)}
            score += 3
        }
    }
    
    init() {
        for shape in Card.Shape.all {
            for color in Card.Color.all {
                for alpha in Card.Alpha.all {
                    for amount in Card.Amount.all {
                        deck.append(Card(shape: shape, color: color, alpha: alpha, amount: amount))
                    }
                }
            }
        }
        print(deck)
    }
}

extension Array where Element: Equatable {
    var uniquified: [Element]{
        var elements = [Element]()
        forEach { if !elements.contains($0) { elements.append($0)} }
        return elements
    }
    var oddCount: Bool {
        return self.count % 2 == 1
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
