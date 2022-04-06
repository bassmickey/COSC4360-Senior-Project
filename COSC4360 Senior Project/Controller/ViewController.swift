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
    @IBOutlet weak var textField: UITextField!
    
    let sentimentClassifier: TweetSentimentClassifer = {
        do {
            return try TweetSentimentClassifer(configuration: MLModelConfiguration())
        } catch {
            print(error)
            fatalError()
        }
    }()
    
    let swifter = Swifter(consumerKey: "", consumerSecret: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sensePressed(_ sender: UIButton) {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended) { results, searchMetadata in
                
                var tweets = [TweetSentimentClassiferInput]()
                
                for i in 0..<100 {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassiferInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                do {
                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    var sentimentScore = 0
                    
                    for prediction in predictions {
                        let sentiment = prediction.label
                        if sentiment == "Pos" {sentimentScore += 1}
                        else if sentiment == "Neg" {sentimentScore -= 1}
                    }
                    
                    print(sentimentScore)
                    
                } catch {
                    print("There was an error with making a prediction \(error)")
                }
                
            } failure: { error in
                print("Failed the fetch data from Twitter API, \(error)")
            }
        }
    }

}

