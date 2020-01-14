//
//  TextViewer.swift
//  Feather
//
//  Created by Douglas Hewitt on 1/8/20.
//  Copyright © 2020 Douglas Hewitt. All rights reserved.
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

public class TextViewer: WKWebView {
    var js: JSCommands!
    var fileName: String { get { return js.viewerName } }
    
    var commandsToRunWhenReady: [String] = []
    
    public init(type: EditorType, frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        
        TextViewer.setupWebConfig(configuration)
        super.init(frame: frame, configuration: configuration)
        setupWebView(type)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    public func storyboardInit(_ type: EditorType) {
        TextViewer.setupWebConfig(configuration)
        setupWebView(type)
    }
    
    func runJS(_ js: String, completion: StringCompletion? = nil) {
        
        guard !isLoading else {
            commandsToRunWhenReady.append(js)
            return
        }
        
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
    
    // MARK: HTML methods
    
    /// Gets HTML from all the content inside the div in the viewer
    /// - Parameter completion: String completion which gives resulting HTML upon success and error upon failure
    public func getHTML(completion: @escaping StringCompletion) {
        runJS(js.viewerGetHTML) { (result) in
            completion(result)
        }
    }
    
    /// Replaces all HTML in the viewer div
    /// - Parameter text: The new HTML to be set
    public func setHTML(text: String) {
        runJS(js.viewerSetHTML(text: text)) { (result) in
            switch result {
            case .success(let html): print(html)
            case .failure(let error): print(error)
            }
        }
    }
    
    // MARK: Text methods

    /// Gets plain text from all the content inside the div in the viewer
    /// - Parameter completion: String completion which gives resulting text upon success and error upon failure
    public func getText(completion: @escaping StringCompletion) {
        runJS(js.viewerGetText) { (result) in
            completion(result)
        }
    }
    
    /// Replaces all HTML in the viewer div
    /// - Parameter text: The new raw text to be set, will ignore and display HTML tags
    public func setText(text: String) {
        runJS(js.viewerSetText(text: text)) { (result) in
            switch result {
            case .success(let html): print(html)
            case .failure(let error): print(error)
            }
        }
    }
}

extension TextViewer: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    //MARK: Load Web View
    private func setupWebView(_ type: EditorType) {
        
        switch type {
        case .froala: js = JSCommands.froala
        case .quill: js = JSCommands.quill
        }
        
        navigationDelegate = self
        uiDelegate = self
                
        let frameworkBundle = Bundle(for: TextViewer.self)
        loadRequest(frameworkBundle)
    }
    
    private func loadRequest(_ bundle: Bundle) {
        
        if let url = bundle.url(forResource: fileName, withExtension: "html") {
            let request = URLRequest(url: url)
            load(request)
        } else {
            print("source html file not found in bundle")
        }
        
    }
    
    //MARK: delegate methods
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        becomeFirstResponder()
        for js in commandsToRunWhenReady {
            runJS(js)
        }
        commandsToRunWhenReady = []
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //TODO: Any message handling from scripts to be done here
    }
    
}


// MARK: - static functions
extension TextViewer {
    
    private static func setupWebConfig(_ config: WKWebViewConfiguration) {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";

        
        config.userContentController.addUserScript(
            WKUserScript(source: source,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
        )
    }
    
    static func escapeText(text: String) -> String {
        var escapedText = ""
        for scalar in text.unicodeScalars {
            escapedText.append(scalar.escaped(asASCII: true))
        }
        return escapedText
    }
}
