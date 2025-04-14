


//  ViewController.swift
//  Hangman Game
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
    var difficultyManager = DifficultyManager.shared
    var currentLevel = 1

    var word = ""
    var maskedWord = ""
    var maskedWordArray = [String]()
    var wordLetterArray = [String]()
    var wordStrings = [String]()
    var level = 0
    var levelCompleted = false
    var usedLetters = ""

    var hangmanImgNumber = 0 {
        didSet {
            hangmanImgNumber = max(0, min(hangmanImgNumber, 10))
            if let hangmanImage = UIImage(named: "\(K.hangmanImg)\(hangmanImgNumber)") {
                let tintedImage = hangmanImage.withRenderingMode(.alwaysTemplate)
                hangmanImgView.image = tintedImage
                hangmanImgView.tintColor = UIColor.black
            }
        }
    }

    var score = 0 {
        didSet {
            scoreLabel.text = score == 1 ? "\(score) point" : "\(score) points"
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
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = true
        setupBackgroundImage()

        title = "\(K.appName) - Level \(difficultyManager.getCurrentLevel())"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clue", style: .plain, target: self, action: #selector(giveClue))

        gameManager.delegate = self
        currentLevel = difficultyManager.getCurrentLevel()
        gameManager.fetchData(fromFile: difficultyManager.getWordFileForCurrentDifficulty())
        totalScore = defaults.integer(forKey: K.scoreKey)
        livesRemaining = difficultyManager.currentDifficulty.livesCount
        formatUI()
    }

    @objc func giveClue() {
        let filteredLetters = wordLetterArray.filter { !usedLetters.contains($0) }
        guard let randomElement = filteredLetters.randomElement()?.capitalized else { return }
        let wordLen = wordLetterArray.count

        Vibration.medium.vibrate()
        showAlertAction(title: "🕵️", message: "The current word is \(wordLen) characters, try '\(randomElement)'", actionClosure: {})

        livesRemaining -= difficultyManager.currentDifficulty.clueDeduction
        hangmanImgNumber += difficultyManager.currentDifficulty.clueDeduction
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @IBAction func letterTapped(_ sender: UIButton) {
        guard let letterChosen = sender.currentTitle?.lowercased() else { return }
        usedLetters.append(letterChosen)

        if wordLetterArray.contains(letterChosen) {
            for (index, letter) in wordLetterArray.enumerated() {
                if letterChosen == letter {
                    maskedWordArray[index] = letter
                }
            }

            maskedWord = maskedWordArray.joined()
            Vibration.success.vibrate()
            playSound(sound: K.Audio.correctAnswerSound)

            if !maskedWordArray.contains("?") {
                gameFinishedAlert(title: "You won! 🎉", message: "You guessed it!", word: word, actionTitle: "Next Level", completion: {
                    self.nextLevel() // Advance level
                    self.loadWord() // Load next word
                    self.enableAllButtons()
                })
                let pointsEarned = 1 * difficultyManager.currentDifficulty.pointMultiplier
                score += pointsEarned
            }

        } else {
            hangmanImgNumber += 1
            livesRemaining -= 1

            Vibration.error.vibrate()
            playSound(sound: K.Audio.wrongAnswerSound)

            if livesRemaining <= 0 {
                gameFinishedAlert(title: "Game Over ☠️", message: "The word was '\(word)'.", word: word, actionTitle: "Try Again", completion: {
                    self.loadWord()
                    self.enableAllButtons()
                    self.level = 0 // Reset level on game over if you want to restart from the first word
                    self.currentLevel = 1
                    self.title = "\(K.appName) - Level \(self.currentLevel)"
                })
            }
        }

        sender.isEnabled = false
        sender.setTitleColor(UIColor(named: K.Colours.buttonColour), for: .disabled)
        wordLabel.text = maskedWord
    }
    
    
    @IBAction func setDifficultyEasy(_ sender: UIButton) {
        difficultyManager.setDifficulty(.easy)
        resetAndStartGame()
    }

    @IBAction func setDifficultyNormal(_ sender: UIButton) {
        difficultyManager.setDifficulty(.normal)
        resetAndStartGame()
    }

    @IBAction func setDifficultyHard(_ sender: UIButton) {
        difficultyManager.setDifficulty(.hard)
        resetAndStartGame()
    }

    func resetAndStartGame() {
        // Reset game state
        level = 0
        score = 0
        currentLevel = difficultyManager.getCurrentLevel()
        
        // Load words from the appropriate file
        gameManager.fetchData(fromFile: difficultyManager.getWordFileForCurrentDifficulty())
        
        // Update UI
        title = "\(K.appName) - Level \(currentLevel)"
        livesRemaining = difficultyManager.currentDifficulty.livesCount
        hangmanImgNumber = 0
        
        // Enable all buttons
        enableAllButtons()
    }
    
    func gameFinishedAlert(title: String, message: String, word: String, actionTitle: String, completion: @escaping () -> Void) {
        // Create custom alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add action
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion()
        }
        alertController.addAction(action)
        
        // Present the alert
        present(alertController, animated: true)
        
        // Optional: Submit score to Game Center if game is over
        if title.contains("Game Over") {
            totalScore += score
            // submitScore(totalScore) // Uncomment when implementing Game Center
        } else {
            // Level completed
            totalScore += score
        }
    }

    func showLevelUpAlert(from oldLevel: Int, to newLevel: Int) {
        // Create custom alert controller
        let alertController = UIAlertController(title: "LEVEL UP", message: "Congratulations!", preferredStyle: .alert)
        
        // Add action
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.loadWord()
        }
        alertController.addAction(action)
        
        // Present the alert
        present(alertController, animated: true)
        
        // Play level up sound
        playSound(sound: K.Audio.gameWonSound)
    }

    func showAlertAction(title: String, message: String, actionClosure: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            actionClosure()
        }
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }

    func enableAllButtons() {
        for button in letterButtons {
            button.isEnabled = true
            button.setTitleColor(.black, for: .normal)
        }
    }

    func gameDataFetched(_ data: [String]) {
        wordStrings = data // Assign the fetched data
        print("Loaded wordStrings: \(wordStrings)") // Debugging
        loadWord()
    }

    func loadWord() {
        print("loadWord() called - level: \(level), wordStrings.count: \(wordStrings.count)") // Debugging
        wordLetterArray = []
        word = ""
        maskedWord = ""
        maskedWordArray = []
        livesRemaining = difficultyManager.currentDifficulty.livesCount
        hangmanImgNumber = 0
        usedLetters = ""

        if !wordStrings.isEmpty {
            if level < wordStrings.count {
                word = wordStrings[level].trimmingCharacters(in: .whitespacesAndNewlines) // Trim whitespace
            } else {
                level = 0 // Cycle back to the first word if all are used
                word = wordStrings[level].trimmingCharacters(in: .whitespacesAndNewlines) // Trim whitespace
            }

            for letter in word {
                wordLetterArray.append(String(letter))
            }

            for _ in 0..<wordLetterArray.count {
                maskedWord += "?"
                maskedWordArray.append("?")
            }

            wordLabel.text = maskedWord
            wordLabel.typingTextAnimation(text: maskedWord, timeInterval: 0.2)
            title = "\(K.appName) - Level \(currentLevel)"
        } else {
            print("Error: wordStrings is empty after fetching.")
            // Handle the case where no words were loaded
            showAlertAction(title: "Error", message: "Failed to load word list.", actionClosure: {
                // Optionally navigate back or take other action
            })
        }
    }

    func nextLevel() {
        difficultyManager.advanceLevel()
        level += 1
        currentLevel = difficultyManager.getCurrentLevel()
        title = "\(K.appName) - Level \(currentLevel)"
        levelCompleted = true
        print("nextLevel() called - level: \(level)") // Debugging
    }

    func playSound(sound: String) {
        MusicPlayer.sharedHelper.playSound(soundURL: sound)
    }

    func submitScore(_ playerScore: Int) {
        // Optional: re-enable when needed
    }

    private func formatUI() {
        view.backgroundColor = UIColor(named: K.Colours.bgColour)

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
        }
    }

    private func setupBackgroundImage() {
        for subview in view.subviews {
            if subview is UIImageView && subview != hangmanImgView {
                subview.removeFromSuperview()
            }
        }

        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill

        if let image = UIImage(named: "Background") {
            backgroundImageView.image = image
        } else if let image = UIImage(named: "game_background") {
            backgroundImageView.image = image
        } else {
            backgroundImageView.backgroundColor = .lightGray
        }

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.isUserInteractionEnabled = false
        view.insertSubview(backgroundImageView, at: 0)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.layoutIfNeeded()
        wordLabel.backgroundColor = .clear
        guessesRemainingLabel.backgroundColor = .clear

        view.bringSubviewToFront(hangmanImgView)
        view.bringSubviewToFront(scoreLabel)
        view.bringSubviewToFront(wordLabel)
        view.bringSubviewToFront(guessesRemainingLabel)
        for button in letterButtons {
            view.bringSubviewToFront(button)
        }
    }
}
