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

    
    public init(type: EditorType, frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";

        
        configuration.userContentController.addUserScript(
            WKUserScript(source: source,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
        )
        
        super.init(frame: frame, configuration: configuration)
        switch type {
        case .froala: js = JSCommands.froala
        case .quill: js = JSCommands.quill
        }
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func runJS(_ js: String, completion: StringCompletion? = nil) {
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
    
    /// Gets HTML from all the content inside the div in the viewer
    /// - Parameter completion: String completion which gives resulting HTML upon success and error upon failure
    public func getHTML(completion: @escaping StringCompletion) {
        let js = """
            document.getElementById("text").innerHTML
            """
        runJS(js) { (result) in
            completion(result)
        }
        
    }
    
    /// Replaces all HTML in the viewer div
    /// - Parameter text: The new HTML to be set
    public func setHTML(text: String) {
        let html = """
                    <div class="fr-view", id="text">
                    \(text)
                    </div>
                    <link href="froala_style.min.css" rel="stylesheet" type="text/css" />
                    <style>
                        .fr-view {
                            font-family:    Helvetica, sans-serif;
                        }
                    </style>
                    """
        
        let frameworkBundle = Bundle(for: TextViewer.self)

        loadHTMLString(html, baseURL: frameworkBundle.resourceURL)
        
    }
}

extension TextViewer: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    //MARK: Load Rich Text
    private func setup() {
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
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //TODO: Any message handling from scripts to be done here
    }
    
}


// MARK: - static functions
extension TextViewer {
    
    static func escapeText(text: String) -> String {
        var escapedText = ""
        for scalar in text.unicodeScalars {
            escapedText.append(scalar.escaped(asASCII: true))
        }
        return escapedText
    }
}
