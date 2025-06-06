//
//  Constants.swift
//  Hangman Game


import Foundation

struct K {
    
    // VC Titles
    static let appName = "Hangman"
    static let settingsVCName = "Settings ⚙️"
    static let howTopPlayVCName = "How To Play 🕹"
    
    
    // New constants for difficulty and levels
    static let difficultyKey = "DifficultyKey"
    static let levelProgressKey = "LevelProgressKey"
    static let levelSelectSegue = "goToLevelSelect"
    
    // Hangman image name
    static let hangmanImg = "hangman"
    
    // Segues
    static let gameSeugue = "goToGame"
    static let howToPlaySegue = "goToHowToPlay"
    static let settingsSegue = "goToSettings"
    
    // Score
    static let scoreKey = "TotalScore"
    
    struct Audio {
        // Keys UserDefaults
        static let bgMusicKey = "Sound"
        static let fxSoundKey = "SoundFX"
        static let volumeKey = "Volume"
        
        // Music/sound constants
        static let bgMusic = "backgroundmusic"
        static let correctAnswerSound = "correct-answer"
        static let wrongAnswerSound = "wrong-answer"
        static let gameWonSound = "game-won"
        static let buttonPressedSound = "button-pressed"
    }
    
    struct Fonts {
        static let retroGaming = "RetroGaming"
        static let rainyHearts = "rainyhearts"
    }
    
    struct Colours {
        static let bgColour = "BackgroundColour"
        static let buttonColour = "PinkColour"
        static let highlightColour = "TurquoiseColour"
        static let labelColour = "WhiteColour"
    }
    
    struct wordsURL {
        static let fileName = "words"
        static let fileExtension = "txt"
    }
    
    
    // TableVIew Cells
    static let rulesCellName = "rulesCell"
    
    //MARK: - UserDefaults
    struct UserDefaultsKeys {
        static let noOfTimesAppOpened = "noTimesAppOpened"
    }
    
}
