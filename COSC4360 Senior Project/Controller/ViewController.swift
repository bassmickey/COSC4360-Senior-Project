//
//  ViewController.swift
//  COSC4360 Senior Project
//
//  Created by Miguel Barajas on 1/25/22.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    let sentimentClassifer = TweetSentimentClassifer()
    
    let swifter = Swifter(consumerKey: "", consumerSecret: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swifter.searchTweet(using: "#AMZN", lang: "en", count: 100, tweetMode: .extended) { results, searchMetadata in
            
            var tweets = [TweetSentimentClassiferInput]()
            
            for i in 0..<100 {
                if let tweet = results[i]["full_text"].string {
                    let tweetForClassification = TweetSentimentClassiferInput(text: tweet)
                    tweets.append(tweetForClassification)
                }
            }
            
            do {
                let predictions = try self.sentimentClassifer.predictions(inputs: tweets)
                
                for prediction in predictions {
                    print(prediction.label)
                }
                
            } catch {
                print("There was an error with making a prediction \(error)")
            }
            
        } failure: { error in
            print("Failed the fetch data from Twitter API, \(error)")
        }
    }
}

