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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = K.settingsVCName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.backgroundColor = UIColor(named: K.Colours.bgColour)
        soundFXLabel.font = UIFont(name: K.Fonts.retroGaming, size: 20.0)
        soundFXLabel.textColor = UIColor.black // Changed to black
        
        soundFXSwitch.onTintColor = UIColor(named: K.Colours.buttonColour)
        soundFXSwitch.tintColor = UIColor(named: K.Colours.buttonColour)
    }
    
}
