//
//  WelcomeViewController.swift
//  Hangman Game


import UIKit
import AVFoundation
import GameKit
import StoreKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var howToPlayBtn: UIButton!
    @IBOutlet weak var leaderboardBtn: UIButton!
    
    var player: AVAudioPlayer?
    
    let defaults = UserDefaults.standard
    
    var reviewPopupShown = false
    
    var totalScore = 42 { // Fixed mock score for prototype
        didSet {
            totalScoreLabel.text = "Total Points: \(totalScore)"
        }
    }
    
    var soundFXOn = true
    var buttonClicked = false
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
        
        buttonClicked = false
        
        // Fixed score for prototype
        totalScore = 42
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatUI()
        animateViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle  {
        .lightContent
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        sender.pulsateBtn()
        
        Vibration.light.vibrate()
        
        if !buttonClicked {
            DispatchQueue.main.asyncAfter(deadline: .now()  + 0.6) {
                [weak self] in
                self?.performSegue(withIdentifier: K.gameSeugue, sender: self)
            }
        }
        
        buttonClicked = true
    }
    
    @IBAction func settingsBtnPressed(_ sender: UIButton) {
        sender.pulsateBtn()
        
        Vibration.light.vibrate()
        
        if !buttonClicked {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                [weak self] in
                self?.performSegue(withIdentifier: K.settingsSegue, sender: self)
            }
        }
        
        buttonClicked = true
        
    }
    
    @IBAction func howToPlayPressed(_ sender: UIButton) {
        sender.pulsateBtn()
        
        Vibration.light.vibrate()
        
        if !buttonClicked {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                [weak self] in
                self?.performSegue(withIdentifier: K.howToPlaySegue, sender: self)
            }
        }
        
        buttonClicked = true
    }
    
    @IBAction func leaderBoardBtnPressed(_ sender: Any) {
        // Show prototype message instead of actual Game Center
        let ac = UIAlertController(title: "Prototype", message: "Leaderboard functionality disabled in prototype", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        ac.formatUI()
        present(ac, animated: true)
    }
    
    private func authenticUserGameCenter() {
        // Disabled for prototype
    }
    
    
    private func requestReview() {
        // Disabled for prototype
    }
    
    
    private func animateViewController() {
        // Button animations
        titleLabel.typingTextAnimation(text: K.appName.uppercased(), timeInterval: 0.2)
        playBtn.fadeInBtn(duration: 1.0)
        settingsBtn.fadeInBtn(duration: 1.0)
        leaderboardBtn.fadeInBtn(duration: 1.0)
        howToPlayBtn.fadeInBtn(duration: 1.0)
    }
    
    private func formatUI() {
        view.backgroundColor = UIColor(named: K.Colours.bgColour)
        
        titleLabel.textColor = UIColor(named: K.Colours.labelColour)
        titleLabel.layer.shadowColor = UIColor.white.cgColor
        titleLabel.layer.shadowOffset = .zero
        titleLabel.layer.shadowRadius = 2.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shouldRasterize = true
        titleLabel.font = UIFont(name: K.Fonts.retroGaming, size: 46.0)
        
        totalScoreLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 22)
        totalScoreLabel.textColor = UIColor(named: K.Colours.labelColour)
        
        let buttons: [UIButton] = [playBtn, settingsBtn, howToPlayBtn, leaderboardBtn]
        
        buttons.forEach { button in
            button.titleLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 20.0)
            button.setTitleColor(UIColor(named: K.Colours.labelColour), for: .normal)
        }
    }
}
