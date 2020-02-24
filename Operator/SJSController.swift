//
//  SJSController.swift
//  Operator
//
//  Created by Farini on 2/23/20.
//  Copyright © 2020 Farini. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class SJSController: UIViewController {
    
    static let javaScriptURL = URL(string: "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js")!
    
    var jsWebView: WKWebView!
    var verticalStackView: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create Configurations and get source code
        let config = WKWebViewConfiguration()
        let sourceCode:String = getJSContents()
        
        // Add the script and WKScriptMessageHandler
        let script = WKUserScript(source: sourceCode, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "jumbo")
        
        // Evaluate script
        let context = JSContext()
        context?.exceptionHandler = { (jsContext, jsValue) in
            print("JS Exception. Value:\(jsValue?.description ?? "n/a") Context:\(jsContext?.description ?? "n/a")")
        }
        context?.evaluateScript(sourceCode)
        
        // Create and add WKWebView
        jsWebView = WKWebView(frame: view.bounds, configuration: config)
        jsWebView.navigationDelegate = self
        view.addSubview(jsWebView)
        
        // Constraints
        jsWebView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.layoutMarginsGuide
        
        jsWebView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        jsWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        jsWebView.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
        jsWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Setup and add the Stackview
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 6
        view.addSubview(verticalStackView)
        
        // Constraints
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.topAnchor.constraint(equalTo: jsWebView.bottomAnchor, constant: 12).isActive = true
        verticalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12).isActive = true
        
        updateViewConstraints()
        
        // Add a label to the Stackview as a title
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "Operations from JS"
        verticalStackView.addArrangedSubview(titleLabel)
        
        // Load an html file in the WKWebView
        let indexUrl = Bundle.main.url(forResource: "index", withExtension: "html")!
        jsWebView.loadFileURL(indexUrl, allowingReadAccessTo: indexUrl)
    }
    
    /// Gets the JavaScript source code from the URL provided
    func getJSContents() -> String {
        
        let url = SJSController.javaScriptURL
        
        guard let sourceCode = try? String(contentsOf:url), sourceCode.isEmpty == false else {
            print("Source code doesn't work")
            
            // Delay this action by 1 sec, as the view has not been presented yet
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                // Present an alert with the error
                let alert = UIAlertController(title: "Error", message: "Could not load source code.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.viewDidLoad()
                }
                alert.addAction(action)
                self.present(alert, animated: true)
            }
            return ""
        }
        
        return sourceCode
    }
    
    /// Starts the operations in the js code
    func startOperations() {
        for i in 1...12 {
            let id = "A\(i)"
            // print("startOperation('\(id)')")
            jsWebView.evaluateJavaScript("startOperation('\(id)')", completionHandler: nil)
        }
    }
}

extension SJSController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let string = message.body as? String {
            
            // Decode Message Model
            let data = Data(string.utf8)
            let decoder = JSONDecoder()
            if let messageObject = try? decoder.decode(Message.self, from: data) {
                
                // Look for an existing message to update its view by their id
                for item in verticalStackView.arrangedSubviews {
                    if let messageView = item as? MessageView {
                        if messageView.accessibilityIdentifier == messageObject.id {
                            // Return here, so we don't create a new view every time
                            messageView.change(message: messageObject)
                            return
                        }
                    }
                }
                
                // Create new MessageView (When a new operation starts) and add to the stack view
                let messageView = MessageView(message: messageObject)
                
                // set accessibilityIdentifier, to track back which view this is
                messageView.accessibilityIdentifier = messageObject.id
                self.verticalStackView.addArrangedSubview(messageView)
            }
        }
    }
}

extension SJSController: WKNavigationDelegate {
    
    /*
     In order to  get the user to see the "start" of operations,
     I wait for the webView to load first, and then start the operations here
     */
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("HTML loaded")
        startOperations()
    }
}
