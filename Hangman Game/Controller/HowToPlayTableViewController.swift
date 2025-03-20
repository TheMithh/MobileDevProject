//
//  HowToPlayTableViewController.swift
//  Hangman Game


import UIKit

class HowToPlayTableViewController: UITableViewController {
    
    var rulesTitle = rulesData.gamesRulesTitle
    var rules = rulesData.gamesRules
    private var backgroundImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "PROTOTYPE: \(K.howTopPlayVCName)"
        view.backgroundColor = UIColor(named: K.Colours.bgColour)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgroundImage()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(goToGameScreen))
        
        tableView.reloadWithBounceAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.rulesCellName, for: indexPath)
        
        cell.textLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 20.0)
        cell.detailTextLabel?.font = UIFont(name: K.Fonts.rainyHearts, size: 20.0)
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.textColor = UIColor.black
        
        // Make cell background transparent
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.text = rulesTitle[indexPath.row]
        cell.detailTextLabel?.text = rules[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func goToGameScreen() {
        Vibration.light.vibrate()
        performSegue(withIdentifier: K.gameSeugue, sender: self)
    }

    private func setupBackgroundImage() {
        // Create background image view
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        
        if let image = UIImage(named: "game_background") {
            backgroundImageView.image = image
        } else {
            // Try Background as a fallback
            backgroundImageView.image = UIImage(named: "Background")
        }
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundImageView, at: 0) // Add at the back
        
        // Important: make sure background doesn't intercept touches
        backgroundImageView.isUserInteractionEnabled = false
        
        // Set constraints
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


}
