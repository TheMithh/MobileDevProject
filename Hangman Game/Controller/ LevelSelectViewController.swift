//
//   LevelSelectViewController.swift
//  Hangman Game
//
//  Created by usr on 2025-04-14.
//  Copyright © 2025 Ben Clarke. All rights reserved.
//
//
import Foundation
import UIKit

class LevelSelectViewController: UIViewController {

    private let titleLabel = UILabel()
    private let easyButton = UIButton()
    private let normalButton = UIButton()
    private let hardButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Select Difficulty"
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: K.Colours.bgColour)

        // Title Label
        titleLabel.text = "CHOOSE DIFFICULTY"
        titleLabel.font = UIFont(name: K.Fonts.retroGaming, size: 28.0)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Easy Button
        setupDifficultyButton(button: easyButton, title: "Easy")
        easyButton.addTarget(self, action: #selector(easyButtonTapped), for:.touchUpInside)
        view.addSubview(easyButton)

        // Normal Button
        setupDifficultyButton(button: normalButton, title: "Normal")
        normalButton.addTarget(self, action: #selector(normalButtonTapped), for: .touchUpInside)
        view.addSubview(normalButton)

        // Hard Button
        setupDifficultyButton(button: hardButton, title: "Hard")
        hardButton.addTarget(self, action: #selector(hardButtonTapped), for: .touchUpInside)
        view.addSubview(hardButton)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            easyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            easyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            easyButton.widthAnchor.constraint(equalToConstant: 200),
            easyButton.heightAnchor.constraint(equalToConstant: 60),

            normalButton.topAnchor.constraint(equalTo: easyButton.bottomAnchor, constant: 30),
            normalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            normalButton.widthAnchor.constraint(equalToConstant: 200),
            normalButton.heightAnchor.constraint(equalToConstant: 60),

            hardButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: 30),
            hardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hardButton.widthAnchor.constraint(equalToConstant: 200),
            hardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    private func setupDifficultyButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 24.0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.brown // Or your desired button background color
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        if let systemImage = UIImage(systemName: "play.fill") {
            let imageView = UIImageView(image: systemImage)
            imageView.tintColor = .black
            imageView.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
                imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 40)
    }

    @objc private func easyButtonTapped() {
        DifficultyManager.shared.currentDifficulty = .easy
        performSegue(withIdentifier: K.gameSeugue, sender: self)
    }

    @objc private func normalButtonTapped() {
        DifficultyManager.shared.currentDifficulty = .normal
        performSegue(withIdentifier: K.gameSeugue, sender: self)
    }

    @objc private func hardButtonTapped() {
        DifficultyManager.shared.currentDifficulty = .hard
        performSegue(withIdentifier: K.gameSeugue, sender: self)
    }
}
