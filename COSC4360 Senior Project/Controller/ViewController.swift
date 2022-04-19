//
//  ViewController.swift
//  COSC4360 Senior Project
//
//  Created by Miguel Barajas on 1/25/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var network = NetworkManager()
    var classification = ClassificationLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        // keyboard listeners
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func updateUI() {
        let tweets = network.getTweets()
        classification.computeSentiment(with: tweets)
        sentimentLabel.text = classification.getEmoji()
        stopLoading()
    }
    
    func startLoading() {
        spinner.startAnimating()
        spinnerView.isHidden = false
    }
    
    func stopLoading() {
        spinnerView.isHidden = true
        spinner.stopAnimating()
    }
    
    @objc func keyboardWillShow(with notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            view.frame.origin.y = -keyboardHeight
        }
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
}

//MARK: -UITextfieldDelegate

extension ViewController: UITextFieldDelegate {
    @IBAction func sensePressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "How do people feel about..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchText = searchTextField.text {
            startLoading()
            network.fetchTweets(with: searchText)
            Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        }
    }
}

