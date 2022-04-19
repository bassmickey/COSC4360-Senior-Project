//
//  ClassificationLogic.swift
//  COSC4360 Senior Project
//
//  Created by Miguel Barajas on 4/19/22.
//

import Foundation
import CoreML

protocol SentimentClassification {
    /// Compute sentiment classification and compute an overall sentiment score
    mutating func computeSentiment(with tweets: [String])
    
    /// Returns an emoji that represents the sentiment score
    /// - Returns: emoji
    func getEmoji() -> String
}

struct ClassificationLogic: SentimentClassification {
    private let sentimentClassifier: TweetSentimentClassifer = {
        do {
            return try TweetSentimentClassifer(configuration: MLModelConfiguration())
        } catch {
            print(error)
            fatalError()
        }
    }()
    
    private var emoji: String?
    
    mutating func computeSentiment(with tweets: [String]) {
        var tweetsForClassification = [TweetSentimentClassiferInput]()
        
        for tweet in tweets {
            let tweetForClassification = TweetSentimentClassiferInput(text: tweet)
            tweetsForClassification.append(tweetForClassification)
        }
        
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweetsForClassification)
            var sentimentScore = 0
            
            for prediction in predictions {
                let sentiment = prediction.label
                if sentiment == "Pos" {sentimentScore += 1}
                else if sentiment == "Neg" {sentimentScore -= 1}
            }
            
            computeScore(with: sentimentScore)
            
        } catch {
            print("There was an error with making a prediction \(error)")
        }
    }
    
    private mutating func computeScore(with sentimentScore: Int) {
        print(sentimentScore)
        
        if sentimentScore > 25 {
            
            emoji = "🤩"
            
        } else if sentimentScore > 20 {
            
            emoji = "😍"
            
        } else if sentimentScore > 15 {
            
            emoji = "😁"
            
        } else if sentimentScore > 10 {
            
            emoji = "😀"
            
        } else if sentimentScore > 5 {
            
            emoji = "🙂"
            
        } else if sentimentScore > 0 {
            
            emoji = "😌"
            
        } else if sentimentScore == 0 {
            
            emoji = "😐"
            
        } else if sentimentScore > -5 {
            
            emoji = "🙁"
            
        } else if sentimentScore > -10 {
            
            emoji = "☹️"
            
        } else if sentimentScore > -15 {
            
            emoji = "😖"
            
        } else if sentimentScore > -20 {
            
            emoji = "😩"
            
        } else if sentimentScore > -25 {
            
            emoji = "😡"
            
        } else {
            
            emoji = "🤮"
            
        }
    }
    
    func getEmoji() -> String {
        return emoji ?? "☠️"
    }
    
}
