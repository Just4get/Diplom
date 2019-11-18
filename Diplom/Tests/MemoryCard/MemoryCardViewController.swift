//
//  MemoryCardViewController.swift
//  Diplom
//
//  Created by BigDude6 on 24/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class MemoryCardViewController: UIViewController, Test{
    
    @IBOutlet var CardButtons: [UIButton]!
    var results:[ResultItem]?
    var profession:Profession?
    var cardImages = ["🍏","🍎","🍒","🍉","🍇","🍀","🌹","🚀","🚘"]
    
    func launchNextTest() {
        if profession!.testNames.isEmpty {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ResultsTable") as! ResultTableViewController
            VC1.results = results
            let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.present(navController, animated:true, completion: nil)
        }
        else {
            let contoller = storyboard?.instantiateViewController(withIdentifier: "TestInfo") as! TestInfoViewController
            contoller.profession = profession
            contoller.results = results
            present(contoller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func skipDidPressed(_ sender: UIButton) {
        let res = ResultItem(type: .MemoryCard, time: 0, description: "", mistakes: 0)
        results?.append(res)
        launchNextTest()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if results == nil {
            results = []
        }
    }
    private lazy var game = MemoryCardTest(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (CardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            flipCount = 0
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = CardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        guard CardButtons != nil else { return }
        for index in CardButtons.indices {
            let button = CardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
        }
        
        // MemoryCard Test ends here
        
        if game.countOfMatchedCards == CardButtons.count {
            let result = ResultItem(type: TestTypes.MemoryCard, time: 0, description: "Тест на память", mistakes: flipCount)
            results?.append(result)
            launchNextTest()
        }
    }
    
    private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎"
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            
            let stringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: Int.random(in: 0..<emojiChoices.count))
            emoji[card] = String(emojiChoices.remove(at: stringIndex))
        }
        return emoji[card] ?? "?"
    }
    
}
