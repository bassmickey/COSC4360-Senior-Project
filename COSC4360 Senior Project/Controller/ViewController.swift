//
//  ViewController.swift
//  COSC4360 Senior Project
//
//  Created by Miguel Barajas on 1/25/22.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swifter = Swifter(consumerKey: "LdbnnfG6c90V2tLGCo19jK5pF", consumerSecret: "m7WUxVpFvmM3wrkxm7TJxtnkknwX61wL5XMWbadrE08HtcBHWo")
        
        swifter.searchTweet(using: "#AMZN", lang: "en", count: 100, tweetMode: .extended) { results, searchMetadata in
            print(results)
        } failure: { error in
            print("Failed the fetch data from Twitter API, \(error)")
        }
    }

}

