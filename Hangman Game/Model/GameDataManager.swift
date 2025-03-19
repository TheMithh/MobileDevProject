//
//  GameManager.swift
//  Hangman Game

import UIKit

protocol GameProtocol: AnyObject {
    func gameDataFetched(_ data: [String])
}

class GameDataManager {
    
    weak var delegate: GameProtocol?
    
    func fetchData() {
        // Mock data instead of loading from file
        let mockWords = ["prototype", "design", "mockup", "sample", "demo"]
        delegate?.gameDataFetched(mockWords)
        
    }
}
