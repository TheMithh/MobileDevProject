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
    private var backgroundImageView: UIImageView!
    
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
            // Ensure our image number stays within bounds (0-10)
            hangmanImgNumber = max(0, min(hangmanImgNumber, 10))
            
            if let hangmanImage = UIImage(named: "\(K.hangmanImg)\(hangmanImgNumber)") {
                // Apply a black tint to the image
                let tintedImage = hangmanImage.withRenderingMode(.alwaysTemplate)
                hangmanImgView.image = tintedImage
                hangmanImgView.tintColor = UIColor.black
            }
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
        
        setupBackgroundImage()
        
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
        
        // Simplified for prototype - recognize all letters in "prototype"
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
            
            // Check if word is complete
            if !maskedWordArray.contains("?") {
                // Word complete - show success message
                gameFinishedAlert(title: "You won! 🎉", message: "Congratulations! You guessed the word correctly.", word: word, actionTitle: "New Word") {
                    self.loadWord()
                    self.enableAllButtons()
                }
                score += 5  // Give bonus points for completing the word
            }
            
        } else {
            // For letters not in the word, show incorrect guess
            hangmanImgNumber += 1
            livesRemaining -= 1
            
            Vibration.error.vibrate()
            playSound(sound: K.Audio.wrongAnswerSound)
            
            // Check if game is over (no lives left)
            if livesRemaining <= 0 {
                gameFinishedAlert(title: "Game Over ☠️", message: "Sorry, you've run out of lives. The word was '\(word)'.", word: word, actionTitle: "Try Again") {
                    self.loadWord()
                    self.enableAllButtons()
                }
            }
        }
        
        sender.isEnabled = false
        sender.setTitleColor(UIColor(named: K.Colours.buttonColour), for: .disabled)
        wordLabel.text = maskedWord
    }

    // Add this helper method to re-enable all buttons for a new game
    func enableAllButtons() {
        for button in letterButtons {
            button.isEnabled = true
            button.setTitleColor(UIColor.black, for: .normal)
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
        
        // Set hangman image with black tint
        hangmanImgView.image = UIImage(named: "\(K.hangmanImg)\(hangmanImgNumber)")?.withRenderingMode(.alwaysTemplate)
        hangmanImgView.tintColor = UIColor.black
        
        scoreLabel.text = "0 points"
        scoreLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 20.0)
        scoreLabel.textColor = UIColor.black
        scoreLabel.backgroundColor = UIColor(named: K.Colours.highlightColour)
        
        guessesRemainingLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 20.0)
        guessesRemainingLabel.textColor = UIColor.black
        
        wordLabel.font = UIFont(name: K.Fonts.retroGaming, size: 36.0)
        wordLabel.textColor = UIColor.black
        
        for button in letterButtons {
            button.titleLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 24.0)
            button.setTitleColor(UIColor.black, for: .normal)
            button.isEnabled = true
            button.alpha = 1.0
        }
    }

    
    private func setupBackgroundImage() {
        // Remove existing background view if any
        backgroundImageView?.removeFromSuperview()
        
        // Create background image view that covers entire screen
        backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        
        // Try different image options
        if let image = UIImage(named: "Background") {
            backgroundImageView.image = image
        } else if let image = UIImage(named: "game_background") {
            backgroundImageView.image = image
        } else {
            print("Warning: No background image found!")
            backgroundImageView.backgroundColor = UIColor.lightGray
        }
        
        // Insert at the back (index 0)
        view.insertSubview(backgroundImageView, at: 0)
        
        // Important: make sure background doesn't intercept touches
        backgroundImageView.isUserInteractionEnabled = false
        
        // Extend beyond safe area to cover entire screen
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Make sure other UI elements are above the background
        view.sendSubviewToBack(backgroundImageView)
        
        // Ensure all UI text elements have their backgrounds set to clear
        wordLabel.backgroundColor = UIColor.clear
        guessesRemainingLabel.backgroundColor = UIColor.clear
        // Leave scoreLabel with its background color for visibility
    }
}
