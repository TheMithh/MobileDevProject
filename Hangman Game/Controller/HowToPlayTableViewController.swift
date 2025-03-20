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
        view.backgroundColor = UIColor.clear // Changed from specific color to clear
        
        // Make sure table view is properly configured
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.3)
        
        // Force reload to ensure cells are visible
        tableView.reloadData()
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
        
        // Configure cell appearance for better visibility over background
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.7) // Semi-transparent white background
        
        // Configure text appearance
        cell.textLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 20.0)
        cell.detailTextLabel?.font = UIFont(name: K.Fonts.rainyHearts, size: 20.0)
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.textColor = UIColor.black
        
        // Ensure text labels are visible
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        // Set content
        cell.textLabel?.text = rulesTitle[indexPath.row]
        cell.detailTextLabel?.text = rules[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Add some styling to make cells stand out against background
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.selectionStyle = .none // Remove selection highlight
        
        // Add some padding around cell content
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Automatically adjust based on content
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Estimated height
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