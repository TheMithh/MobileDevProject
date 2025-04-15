


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
            updateScoreLabel()
        }
    }

    // Add total wins tracking
    var totalWins = 0 {
        didSet {
            defaults.set(totalWins, forKey: "totalWinsKey")
        }
    }

    let gameManager = GameDataManager()
    var difficultyManager = DifficultyManager.shared
    var currentLevel = 1 {
        didSet {
            title = "\(K.appName) - Level \(currentLevel)"
            defaults.set(currentLevel, forKey: "currentLevelKey")
        }
    }
    var wordsGuessedCorrectly = 0 {
        didSet {
            defaults.set(wordsGuessedCorrectly, forKey: "wordsGuessedKey")
        }
    }

    var word = ""
    var maskedWord = ""
    var maskedWordArray = [String]()
    var wordLetterArray = [String]()
    var allWords: [String] = []
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

    var score = 0 // Added score to track points in a round

    var livesRemaining = 0 {
        didSet {
            guessesRemainingLabel.text = "\(livesRemaining) lives left"
        }
    }

    // Add new labels for displaying wins and level
    private var winsLabel: UILabel!
    private var levelLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = true
        setupBackgroundImage()

        // Load saved data
        totalScore = defaults.integer(forKey: K.scoreKey)
        totalWins = defaults.integer(forKey: "totalWinsKey")
        currentLevel = defaults.integer(forKey: "currentLevelKey")
        if currentLevel == 0 { currentLevel = 1 }
        wordsGuessedCorrectly = defaults.integer(forKey: "wordsGuessedKey")

        title = "\(K.appName) - Level \(currentLevel)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clue", style: .plain, target: self, action: #selector(giveClue))

        gameManager.delegate = self
        livesRemaining = 10
        setupAdditionalLabels()
        formatUI()
        updateScoreLabel()
        updateWinsLabel()
        updateLevelLabel()
        startGame()
    }


    private func setupAdditionalLabels() {
        // Setup wins label
        winsLabel = UILabel()
        winsLabel.translatesAutoresizingMaskIntoConstraints = false
        winsLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 18.0)
        winsLabel.textColor = UIColor.black
        winsLabel.backgroundColor = UIColor(named: K.Colours.highlightColour)
        winsLabel.textAlignment = .center
        view.addSubview(winsLabel)

        // Setup level progress label
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 18.0)
        levelLabel.textColor = UIColor.black
        levelLabel.backgroundColor = UIColor(named: K.Colours.highlightColour)
        levelLabel.textAlignment = .center
        view.addSubview(levelLabel)


        // Position labels below the hangman image (adjust constraints as needed)
        NSLayoutConstraint.activate([
            winsLabel.topAnchor.constraint(equalTo: hangmanImgView.bottomAnchor, constant: 8),
            winsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            winsLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            winsLabel.heightAnchor.constraint(equalToConstant: 30),

            levelLabel.topAnchor.constraint(equalTo: hangmanImgView.bottomAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            levelLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            levelLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    func startGame() {
        let alert = UIAlertController(title: "Choose Difficulty", message: "Select the difficulty level:", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Easy", style: .default, handler: { [weak self] (_) in
            self?.difficultyManager.setDifficulty(.easy)
            self?.startGameSetup()
        }))

        alert.addAction(UIAlertAction(title: "Normal", style: .default, handler: { [weak self] (_) in
            self?.difficultyManager.setDifficulty(.normal)
            self?.startGameSetup()
        }))

        alert.addAction(UIAlertAction(title: "Hard", style: .default, handler: { [weak self] (_) in
            self?.difficultyManager.setDifficulty(.hard)
            self?.startGameSetup()
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func startGameSetup() {
        currentLevel = difficultyManager.getCurrentLevel()
        gameManager.fetchData(fromFile: difficultyManager.getWordFileForCurrentDifficulty())
        title = "\(K.appName) - Level \(currentLevel)"
        livesRemaining = 10
        hangmanImgNumber = 0
        enableAllButtons()
        score = 0
        updateScoreLabel()
        updateWinsLabel()
        updateLevelLabel()
        loadWord()
    }

    @objc func giveClue() {
        let filteredLetters = wordLetterArray.filter { !usedLetters.contains($0) }
        guard let randomElement = filteredLetters.randomElement()?.capitalized else { return }
        let wordLen = wordLetterArray.count

        Vibration.medium.vibrate()
        showAlertAction(title: "🕵️", message: "The current word is \(wordLen) characters, try '\(randomElement)'", actionClosure: {})

        livesRemaining -= 1
        hangmanImgNumber += difficultyManager.currentDifficulty.clueDeduction
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    @IBAction func letterTapped(_ sender: UIButton) {
        guard let letterChosen = sender.currentTitle?.lowercased() else { return }
        usedLetters.append(letterChosen)

        if wordLetterArray.contains(letterChosen) {
            // Correct guess: Add 4 points
            score += 4

            for (index, letter) in wordLetterArray.enumerated() {
                if letterChosen == letter {
                    maskedWordArray[index] = letter
                }
            }

            maskedWord = maskedWordArray.joined()
            Vibration.success.vibrate()
            playSound(sound: K.Audio.correctAnswerSound)

            if !maskedWordArray.contains("?") {
                totalScore += 4  // Add 4 points for correct guess
                totalWins += 1  // Increment total wins counter
                wordsGuessedCorrectly += 1

                updateWinsLabel()

                if wordsGuessedCorrectly >= 3 {
                    wordsGuessedCorrectly = 0
                    let levelBonus = currentLevel * 10 // Bonus points for leveling up
                    totalScore += levelBonus

                    gameFinishedAlert(title: "LEVEL UP! 🎉",
                                      message: "You guessed 3 words correctly!\nEarned 4 points for the last word.\nBonus \(levelBonus) points for leveling up!",
                                      word: word,
                                      actionTitle: "Next Level",
                                      completion: {
                                          self.nextLevel()
                                          self.loadWord()
                                          self.enableAllButtons()
                                          self.score = 0
                                          self.updateLevelLabel()
                                      })
                } else {
                    gameFinishedAlert(title: "You won! 🎉",
                                      message: "You guessed it! Earned 4 points for this word.\nGuess \(3 - wordsGuessedCorrectly) more to level up!",
                                      word: word,
                                      actionTitle: "Next Word",
                                      completion: {
                                          self.loadWord()
                                          self.enableAllButtons()
                                          self.score = 0
                                          self.updateLevelLabel()
                                      })
                }
            }
        } else {
            // Incorrect guess: Subtract 1 point
            score -= 1
            hangmanImgNumber += 1
            livesRemaining -= 1
            Vibration.error.vibrate()
            playSound(sound: K.Audio.wrongAnswerSound)

            if livesRemaining <= 0 {
                totalScore -= 1 // Deduct 1 point for losing the word

                // Keep current level but reset words guessed counter
                let savedLevel = currentLevel

                gameFinishedAlert(title: "Game Over ☠️",
                                  message: "The word was '\(word)'.\nYour total score is \(totalScore).",
                                  word: word,
                                  actionTitle: "Try Again",
                                  completion: {
                                      self.loadWord()
                                      self.enableAllButtons()
                                      self.level = savedLevel - 1
                                      self.currentLevel = savedLevel
                                      self.title = "\(K.appName) - Level \(self.currentLevel)"
                                      self.score = 0
                                      self.wordsGuessedCorrectly = 0
                                      self.updateLevelLabel()
                                  })
            }
        }

        sender.isEnabled = false
        sender.setTitleColor(UIColor(named: K.Colours.buttonColour), for: .disabled)
        wordLabel.text = maskedWord
        updateScoreLabel()
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
        level = 0
        score = 0
        currentLevel = difficultyManager.getCurrentLevel()
        wordsGuessedCorrectly = 0
        gameManager.fetchData(fromFile: difficultyManager.getWordFileForCurrentDifficulty())
        title = "\(K.appName) - Level \(currentLevel)"
        livesRemaining = 10
        hangmanImgNumber = 0
        enableAllButtons()
        // Don't reset total score or total wins when changing difficulty
        updateScoreLabel()
        updateWinsLabel()
        updateLevelLabel()
        loadWord()
    }

    func gameFinishedAlert(title: String, message: String, word: String, actionTitle: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    func showLevelUpAlert(from oldLevel: Int, to newLevel: Int) {
        let alertController = UIAlertController(
            title: "LEVEL UP",
            message: "Congratulations! You've advanced from Level \(oldLevel) to Level \(newLevel)!",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.loadWord()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
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
        allWords = data
        print("Loaded words: \(allWords)")
        loadWord()
    }

    func loadWord() {
        print("loadWord() called - level: \(level), allWords.count: \(allWords.count)")
        wordLetterArray = []
        word = ""
        maskedWord = ""
        maskedWordArray = []
        livesRemaining = 10
        hangmanImgNumber = 0
        usedLetters = ""
        score = 0
        navigationItem.rightBarButtonItem?.isEnabled = true
        updateScoreLabel()
        updateLevelLabel()

        if !allWords.isEmpty {
            if allWords.count > 0 {
                let randomIndex = Int.random(in: 0..<allWords.count)
                word = allWords[randomIndex].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
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
            print("Error: allWords is empty after fetching.")
            showAlertAction(title: "Error", message: "Failed to load word list.", actionClosure: {
            })
        }
    }

    func nextLevel() {
        let oldLevel = currentLevel
        difficultyManager.advanceLevel()
        level += 1
        currentLevel = difficultyManager.getCurrentLevel()
        title = "\(K.appName) - Level \(currentLevel)"
        levelCompleted = true
        showLevelUpAlert(from: oldLevel, to: currentLevel)
        print("nextLevel() called - level: \(level)")
    }

    func playSound(sound: String) {
        MusicPlayer.sharedHelper.playSound(soundURL: sound)
    }

    func submitScore(_ playerScore: Int) {
    }

    private func formatUI() {
        view.backgroundColor = UIColor(named: K.Colours.bgColour)

        hangmanImgView.image = UIImage(named: "\(K.hangmanImg)\(hangmanImgNumber)")?.withRenderingMode(.alwaysTemplate)
        hangmanImgView.tintColor = UIColor.black

        scoreLabel.text = "\(totalScore) points"
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
    
    private func updateScoreLabel() {
        scoreLabel.text = "\(totalScore) points"
    }
    
    private func updateWinsLabel() {
        winsLabel.text = "Total Wins: \(totalWins)"
        view.bringSubviewToFront(winsLabel)
    }
    
    private func updateLevelLabel() {
        levelLabel.text = "Level \(currentLevel): \(wordsGuessedCorrectly)/3 words"
        view.bringSubviewToFront(levelLabel)
    }
}
