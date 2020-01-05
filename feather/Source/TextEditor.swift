//
//  TextEditor.swift
//  MacTest
//
//  Created by Douglas Hewitt on 12/19/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation
import WebKit

public typealias DataTaskResult = Swift.Result<(URLResponse, Data), Error>
public typealias DataTaskCompletion = (DataTaskResult) -> Void

public typealias StringResult = Swift.Result<String, Error>
public typealias StringCompletion = (StringResult) -> Void

public enum EditorType {
    case froala
    case quill
}

public class TextEditor: WKWebView {
    var js: JSCommands!
    
    public init(type: EditorType, frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        super.init(frame: frame, configuration: configuration)
        switch type {
        case .froala: js = JSCommands.froala
        case .quill: js = JSCommands.quill
        }
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
    
    public func getHTML(completion: @escaping StringCompletion) {
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
    
    public func insertHTML(text: String) {
        runJS(js.insertHTML(text: text)) { (result) in
            switch result {
            case .success(let html): print(html)
            case .failure(let error): print(error)
            }
        }
        
    }
    
    public func toggleBold() {
        runJS(js.bold)
    }
    
    public func toggleItalic() {
        runJS(js.italic)
    }
    
    public func toggleUnderline() {
        runJS(js.underline)
    }
    
    public func increaseIndent() {
        runJS(js.indent)
    }
    
    public func reduceIndent() {
        runJS(js.outdent)
    }
    
    public func hideToolBar() {
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
                
        let myBundle = Bundle(identifier: "doug.feather")!
        
        if let url = myBundle.url(forResource: js.fileName, withExtension: "html") {
            let request = URLRequest(url: url)
            load(request)
        } else {
            print("url not found")
        }
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        becomeFirstResponder()
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //TODO: Any message handling from scripts to be done here
    }
    
}