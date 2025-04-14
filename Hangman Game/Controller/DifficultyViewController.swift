

//
//  DifficultyViewController.swift
//  Hangman Game
//
//  Created by usr on 2025-04-14.
//  Copyright © 2025 Ben Clarke. All rights reserved.
//

import Foundation
import UIKit

class DifficultyViewController: UIViewController {

    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!

    let difficultyManager = DifficultyManager.shared
    var backgroundImageView: UIImageView! // Declare as an optional or implicitly unwrapped optional

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupUI()
    }

    private func setupBackgroundImage() {
        // Create background image view
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        if let backgroundImage = UIImage(named: "Difficulty") {
            backgroundImageView.image = backgroundImage
        } else {
            print("Error: 'Difficulty' image not found in Assets. Check the spelling.")
            // Optionally set a default background color:
            view.backgroundColor = .lightGray
            return // Exit if the image couldn't be loaded and fallback is set
        }

        view.insertSubview(backgroundImageView, at: 0) // Add at the back

        // Set constraints
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    private func setupUI() {
        // Style buttons
        for button in [easyButton, normalButton, hardButton] {
            button?.titleLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 24.0)
            button?.setTitleColor(UIColor.black, for: .normal)
        }

    }

    @IBAction func easyButtonTapped(_ sender: UIButton) {
        difficultyManager.setDifficulty(.easy)
        startGame()
    }

    @IBAction func normalButtonTapped(_ sender: UIButton) {
        difficultyManager.setDifficulty(.normal)
        startGame()
    }

    @IBAction func hardButtonTapped(_ sender: UIButton) {
        difficultyManager.setDifficulty(.hard)
        startGame()
    }

    private func startGame() {
        // Play selection sound
        MusicPlayer.sharedHelper.playSound(soundURL: K.Audio.buttonPressedSound)

        // Navigate to game screen
        performSegue(withIdentifier: "goToGame", sender: self)
    }
}
