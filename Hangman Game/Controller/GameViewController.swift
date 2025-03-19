//
//  ViewController.swift
//  Hangman Game

import UIKit
import AVFoundation
import GameKit

class GameViewController: UIViewController, GameProtocol {
   
    @IBOutlet weak var hangmanImgView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var guessesRemainingLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    var player: AVAudioPlayer?
    
    let defaults = UserDefaults.standard
    var totalScore = 0 {
        didSet {
            defaults.set(totalScore, forKey: K.scoreKey)
        }
    }
    
    let gameManager = GameDataManager()
    
    // Fixed mock data for prototype
    var word = "prototype"
    var maskedWord = "?????????"
    var maskedWordArray = ["?", "?", "?", "?", "?", "?", "?", "?", "?"]
    var wordLetterArray = ["p", "r", "o", "t", "o", "t", "y", "p", "e"]
    
    var wordStrings = [String]()
    var level = 0
    var levelCompleted = false
    var usedLetters = ""
    
    var hangmanImgNumber = 0 {
        didSet {
            hangmanImgView.image = UIImage(named: "\(K.hangmanImg)\(hangmanImgNumber)")
        }
    }
    
    var score = 0 {
        didSet {
            if score == 1 {
                scoreLabel.text = "\(score) point"
            } else {
                scoreLabel.text = "\(score) points"

            }
        }
    }
    
    var livesRemaining = 10 {
        didSet {
            guessesRemainingLabel.text = "\(livesRemaining) lives left"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = K.appName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clue", style: .plain, target: self, action: #selector(giveClue))
        
        gameManager.delegate = self
        
        gameManager.fetchData()
        
        totalScore = defaults.integer(forKey: K.scoreKey)
        
        formatUI()
    }
        
    @objc func giveClue() {
        // Simplified clue for prototype
        Vibration.medium.vibrate()
        showAlertAction(title: "🕵️", message: "This is a prototype version. Clues would appear here in the full game!", actionClosure: {})
    }
    
    
    @IBAction func letterTapped(_ sender: UIButton) {
        guard let letterChosen = sender.currentTitle?.lowercased() else { return }
        
        usedLetters.append(letterChosen)
        
        // Recognize all letters in "prototype"
        if wordLetterArray.contains(letterChosen) {
            // Show the letter in all positions where it appears
            for (index, letter) in wordLetterArray.enumerated() {
                if letterChosen == letter {
                    maskedWordArray[index] = letter
                }
            }
            
            maskedWord = maskedWordArray.joined()
            Vibration.success.vibrate()
            playSound(sound: K.Audio.correctAnswerSound)
            
        } else {
            // For letters not in the word, show incorrect guess
            hangmanImgNumber += 1
            livesRemaining -= 1
            
            Vibration.error.vibrate()
            playSound(sound: K.Audio.wrongAnswerSound)
        }
        
        sender.isEnabled = false
        sender.setTitleColor(UIColor(named: K.Colours.buttonColour), for: .disabled)
        wordLabel.text = maskedWord
        
        // Always stop at a certain point to prevent game from ending
        if hangmanImgNumber >= 5 {
            livesRemaining = 5
            hangmanImgNumber = 5
        }
    }
    
    
    func gameDataFetched(_ data: [String]) {
        wordStrings += data
        loadWord()
    }
    
    
    func checkToSeeIfCompleted() {
        // Disabled for prototype - don't check for game completion
    }
    
    func loadWord() {
        // Always use the same mock word for prototype
        word = "prototype"
        wordLetterArray = ["p", "r", "o", "t", "o", "t", "y", "p", "e"]
        maskedWord = "?????????"
        maskedWordArray = ["?", "?", "?", "?", "?", "?", "?", "?", "?"]
        
        livesRemaining = 10
        hangmanImgNumber = 0
        
        wordLabel.text = maskedWord
        wordLabel.typingTextAnimation(text: maskedWord, timeInterval: 0.2)
    }
    
    func nextLevel() {
        level += 1
        levelCompleted = true
    }
    
    func playSound(sound: String) {
        MusicPlayer.sharedHelper.playSound(soundURL: sound)
    }

    func submitScore(_ playerScore: Int) {
        // Disabled for prototype
    }
    
    private func formatUI(){
        view.backgroundColor = UIColor(named: K.Colours.bgColour)
        
        hangmanImgView.image = UIImage(named: "\(K.hangmanImg)\(hangmanImgNumber)")
        scoreLabel.text = "0 points"
        scoreLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 20.0)
        scoreLabel.textColor = UIColor(named: K.Colours.bgColour)
        scoreLabel.backgroundColor = UIColor(named: K.Colours.highlightColour)
        guessesRemainingLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 20.0)
        wordLabel.font = UIFont(name: K.Fonts.retroGaming, size: 36.0)
        
        for button in letterButtons {
            button.titleLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 24.0)
            button.setTitleColor(UIColor(named: K.Colours.labelColour), for: .normal)
        }
    }
    
}
