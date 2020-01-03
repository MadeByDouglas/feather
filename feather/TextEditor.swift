//
//  TextEditor.swift
//  MacTest
//
//  Created by Douglas Hewitt on 12/19/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation
import WebKit

typealias DataTaskResult = Swift.Result<(URLResponse, Data), Error>
typealias DataTaskCompletion = (DataTaskResult) -> Void

typealias StringResult = Swift.Result<String, Error>
typealias StringCompletion = (StringResult) -> Void

class TextEditor: WKWebView {
    var js: JSCommands!
    
    init(commands: JSCommands, frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        js = commands
        loadJS()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func runJS(_ js: String, completion: StringCompletion? = nil) {
        evaluateJavaScript(js) { (data, error) in
            
            guard let completion = completion else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }

            
            if let dataInt = data as? Int {
                completion(.success("\(dataInt)"))
                
            } else if let dataBool = data as? Bool {
                completion(.success(dataBool ? "true" : "false"))

            } else if let dataString = data as? String {
                completion(.success(dataString))
            } else {
                completion(.success(""))
            }

        }
    }
    
    func getHTML(completion: @escaping StringCompletion) {
        runJS(js.cleanEmptyTags) { (result) in
            switch result {
            case .success(_):
                self.runJS(self.js.getHTML) { (result) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    func insertHTML(text: String) {
        runJS(js.insertHTML(text: text)) { (result) in
            switch result {
            case .success(let html): print(html)
            case .failure(let error): print(error)
            }
        }
        
    }
    
    func toggleBold() {
        runJS(js.bold)
    }
    
    func toggleItalic() {
        runJS(js.italic)
    }
    
    func toggleUnderline() {
        runJS(js.underline)
    }
    
    func increaseIndent() {
        runJS(js.indent)
    }
    
    func reduceIndent() {
        runJS(js.outdent)
    }
    
    func hideToolBar() {
        runJS(js.showToolbar)
    }
}


extension TextEditor: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    //MARK: Load Rich Text
    fileprivate func loadJS() {
        
//        let configuration = WKWebViewConfiguration()
//        configuration.userContentController.addUserScript(
//            WKUserScript(source: scriptContent,
//                injectionTime: .atDocumentEnd,
//                forMainFrameOnly: true
//            )
//        )

        navigationDelegate = self
        uiDelegate = self
        
        if let url = Bundle.main.url(forResource: js.fileName, withExtension: "html") {
            let request = URLRequest(url: url)
            load(request)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        becomeFirstResponder()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //TODO: Any message handling from scripts to be done here
    }
    
}
