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
        // Do any additional setup after loading the view.
        
        let swifter = Swifter(consumerKey: "", consumerSecret: "")
        
        swifter.searchTweet(using: "@Apple") { results, searchMetadata in
            print(results)
        } failure: { error in
            print("Failed the fetch data from Twitter API, \(error)")
        }

    }


}

