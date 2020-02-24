//
//  MessageView.swift
//  Operator
//
//  Created by Farini on 2/23/20.
//  Copyright © 2020 Farini. All rights reserved.
//

import UIKit

class MessageView: UIStackView {
    
    var idLabel = UILabel()
    var progressLabel = UILabel()
    var activityIndicator = UIActivityIndicatorView()
    var progressView = UIProgressView(progressViewStyle: .default)
    
    /// updates the message and the MessageView
    func change(message:Message) {
        
        var pLabelString:String = ""
        if let progress = message.progress {
            pLabelString += "\(progress)%"
            
            let pvValue = Float((message.progress ?? 0) / 100)
            progressView.setProgress(pvValue, animated: true)
            
        }else{
            if message.state == "success" {
                pLabelString += "✅ \(message.message) \(message.state!)"
            }else if message.state == "error" {
                pLabelString += "⚠️ completed \(message.state!)"
            }
            activityIndicator.stopAnimating()
            progressView.isHidden = true
        }
        
        progressLabel.text = pLabelString
    }
    
    // MARK: - Init
    
    init(message:Message) {
        
        super.init(frame:CGRect.zero)
        
        // Setup the Horizontal StackView
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
        spacing = 6
        
        activityIndicator.hidesWhenStopped = true
        
        idLabel.text = message.id
        
        var pLabelString:String = ""
        if let progress = message.progress {
            pLabelString += "\(progress)"
            
            // Add a UIProgressView
            let pvValue = Float(progress / 100)
            progressView.setProgress(pvValue, animated: true)
            self.progressView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            activityIndicator.startAnimating()
        }else{
            // no progress
            pLabelString += message.message
            // check state
            if let state = message.state {
                pLabelString += " \(state)"
            }
            activityIndicator.stopAnimating()
            self.progressView.isHidden = true
        }
        
        progressLabel.text = pLabelString
        
        // Add Views to Stack
        self.addArrangedSubview(activityIndicator)
        self.addArrangedSubview(idLabel)
        self.addArrangedSubview(progressLabel)
        self.addArrangedSubview(progressView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
