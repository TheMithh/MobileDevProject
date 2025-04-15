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
    private var backgroundImageView: UIImageView!
    
    var player: AVAudioPlayer?
    
    let defaults = UserDefaults.standard
    
    var reviewPopupShown = false
    
    //  var totalScore = 42 { // Fixed mock score for prototype
    //        didSet {
    //            totalScoreLabel.text = "Total Points: \(totalScore)"
    //        }
    //    }
    
    var totalScore = 0 {
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
        
        //  Fixed score for prototype
        //  totalScore = 42
        totalScore = defaults.integer(forKey: K.scoreKey)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImage()
        formatUI()
        animateViewController()
        
        // Darken the hangman image (logoImg)
        if let logo = logoImg.image {
            // Change the image to use the template rendering mode
            logoImg.image = logo.withRenderingMode(.alwaysTemplate)
            // Set the tint color to black (or another dark color)
            logoImg.tintColor = UIColor.black
        }
        
        totalScore = defaults.integer(forKey: K.scoreKey) //initial load
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
    
    
    private func setupBackgroundImage() {
        // Create background image view
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "game_background")
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundImageView, at: 0) // Add at the back
        
        // Set constraints
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        
        // Change from white to black
        titleLabel.textColor = UIColor.black
        titleLabel.layer.shadowColor = UIColor.lightGray.cgColor // Changed shadow color for better visibility
        titleLabel.layer.shadowOffset = .zero
        titleLabel.layer.shadowRadius = 2.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shouldRasterize = true
        titleLabel.font = UIFont(name: K.Fonts.retroGaming, size: 46.0)
        
        // Change from white to black
        totalScoreLabel.font = UIFont(name: K.Fonts.rainyHearts, size: 22)
        totalScoreLabel.textColor = UIColor.black
        
        let buttons: [UIButton] = [playBtn, settingsBtn, howToPlayBtn, leaderboardBtn]
        
        buttons.forEach { button in
            button.titleLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 20.0)
            // Change from white to black
            button.setTitleColor(UIColor.black, for: .normal)
        }
    }
}

