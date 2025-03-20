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
        
        // Make sure the table view can be seen
        tableView.alpha = 1.0
        tableView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the background first
        setupBackgroundImage()
        
        // Configure table view for visibility
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(goToGameScreen))
        
        // Ensure data is loaded
        print("Rules count: \(rules.count)")
        
        // Force table view to update
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(rules.count)")
        return rules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.rulesCellName, for: indexPath)
        
        // Make cell visible with white background
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        // Configure fonts
        cell.textLabel?.font = UIFont(name: K.Fonts.retroGaming, size: 20.0) ?? UIFont.boldSystemFont(of: 20.0)
        cell.detailTextLabel?.font = UIFont(name: K.Fonts.rainyHearts, size: 20.0) ?? UIFont.systemFont(of: 20.0)
        
        // Set text color to black for visibility
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.textColor = UIColor.black
        
        // Set content with debug print
        cell.textLabel?.text = rulesTitle[indexPath.row]
        cell.detailTextLabel?.text = rules[indexPath.row]
        
        print("Cell \(indexPath.row) configured: \(rulesTitle[indexPath.row])")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Fixed height to ensure visibility
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func goToGameScreen() {
        Vibration.light.vibrate()
        performSegue(withIdentifier: K.gameSeugue, sender: self)
    }
    
    private func setupBackgroundImage() {
        // Remove any existing background
        for subview in view.subviews {
            if subview is UIImageView {
                subview.removeFromSuperview()
            }
        }
        
        // Create background image view with proper size
        backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        
        if let image = UIImage(named: "game_background") {
            backgroundImageView.image = image
        } else if let image = UIImage(named: "Background") {
            backgroundImageView.image = image
        }
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Insert background at index 0 to ensure it's behind the table view
        view.insertSubview(backgroundImageView, at: 0)
        
        // Make sure background doesn't intercept touches
        backgroundImageView.isUserInteractionEnabled = false
        
        // Set constraints to cover full screen
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}