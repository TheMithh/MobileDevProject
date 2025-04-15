//

//  GameManager.swift
//  Hangman Game

//
//  GameManager.swift
//  Hangman Game
//

import Foundation
protocol GameProtocol {
    func gameDataFetched(_ data: [String])
}

class GameDataManager {
    var delegate: GameProtocol?
    
    func fetchData(fromFile filename: String = "words") {
        if let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") {
            do {
                let wordString = try String(contentsOf: fileURL)
                let words = wordString.components(separatedBy: "\n")
                delegate?.gameDataFetched(words)
            } catch {
                print("Error loading \(filename).txt: \(error)")
            }
        } else {
            print("File \(filename).txt not found")
            // Fallback to the original words file
            if filename != "words" {
                fetchData(fromFile: "words")
            }
        }
    }
}
