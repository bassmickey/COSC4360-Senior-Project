//
//  NetworkManager.swift
//  COSC4360 Senior Project
//
//  Created by Miguel Barajas on 4/19/22.
//

import Foundation
import SwifteriOS
import SwiftyJSON

protocol APICall {
    /// Perform an API Call, filter the JSON and save the tweets into a string array
    /// - Parameter searchText: User's input
    func fetchTweets(with searchText: String)
    
    /// Returns tweets
    /// - Returns: tweets
    func getTweets() -> [String]
}

class NetworkManager: APICall {
    private let tweetCount = 100
    private let swifter = Swifter(consumerKey: "", consumerSecret: "")
    
    private var tweets: [String]?
    
    func fetchTweets(with searchText: String) {
        swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { results, searchMetadata in
            
            var tweets = [String]()
            
            for i in 0..<self.tweetCount {
                if let tweet = results[i]["full_text"].string {
                    tweets.append(tweet)
                }
            }
            
            self.tweets = tweets
            
        } failure: { error in
            print("Failed the fetch data from Twitter API, \(error)")
        }
    }
    
    func getTweets() -> [String] {
        return tweets ?? []
    }
}
