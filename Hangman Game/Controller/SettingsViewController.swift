//
//  SettingsViewController.swift
//  Hangman Game

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var soundFXLabel: UILabel!
    @IBOutlet weak var soundFXSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    var soundFXOn = true
    var currentVolume: Float = 1.0
    
    var player: AVAudioPlayer?
    
    // Add a background image view property
    private var backgroundImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = K.settingsVCName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Extend layout to cover the whole screen, even under the navigation bar.
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = true
        
        // Set up the background image first
        setupBackgroundImage()
        
        formatUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(goToGameScreen))
        
        soundFXLabel.alpha = 0
        UIView.animate(withDuration: 1.0) {
            self.soundFXLabel.alpha = 1.0
        }
        
        // Always on for prototype
        soundFXOn = true
        currentVolume = 1.0
        
        soundFXSwitch.setOn(soundFXOn, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = " "
    }
        
    @IBAction func soundFXSwitch(_ sender: UISwitch) {
        // Visual toggle only for prototype, doesn't change behavior
        playButtonSound() // Always play sound to demonstrate
    }
    
    private func playButtonSound() {
        MusicPlayer.sharedHelper.playSound(soundURL: K.Audio.buttonPressedSound)
    }
    
    @objc func goToGameScreen() {
        Vibration.light.vibrate()
        performSegue(withIdentifier: K.gameSeugue, sender: self)
    }
    
    private func formatUI() {
        // Instead of setting the view's backgroundColor, our background image is now used.
        // Format the label and switch as needed.
        soundFXLabel.font = UIFont(name: K.Fonts.retroGaming, size: 20.0)
        soundFXLabel.textColor = UIColor.black
        
        soundFXSwitch.onTintColor = UIColor(named: K.Colours.buttonColour)
        soundFXSwitch.tintColor = UIColor(named: K.Colours.buttonColour)
    }
    
    private func setupBackgroundImage() {
        // Create and configure the background image view
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        
        if let image = UIImage(named: "game_background") {
            backgroundImageView.image = image
        } else if let image = UIImage(named: "Background") {
            backgroundImageView.image = image
        }
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        // Insert it at index 0 so it appears behind all other views
        view.insertSubview(backgroundImageView, at: 0)
        
        // Set constraints to cover the entire view
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
