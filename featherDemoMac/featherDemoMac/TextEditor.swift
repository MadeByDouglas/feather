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


class EditWebView: WKWebView {

    public func runJS(_ js: String, completion: StringCompletion? = nil) {
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
                print("UNABLE TO PARSE DATA")
            }

        }
    }
    
}

class TextEditor: NSView {
    var editorView: EditWebView!
    let js = JSCommands.froala
    
    func getHTML(completion: @escaping StringCompletion) {
        editorView.runJS(js.getHTML) { (result) in
            completion(result)
        }
    }
    
    func toggleBold() {
        editorView.runJS(js.bold)
    }
    
    func toggleItalic() {
        editorView.runJS(js.italic)
    }
    
    func toggleUnderline() {
        editorView.runJS(js.underline)
    }
    
    func increaseIndent() {
        editorView.runJS(js.indent)
    }
    
    func reduceIndent() {
        editorView.runJS(js.outdent)
    }
    
    func hideToolBar() {
        editorView.runJS(js.showToolbar)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadTextEditor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TextEditor: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    //MARK: Load Rich Text
    fileprivate func loadTextEditor() {
        
//        let configuration = WKWebViewConfiguration()
//        configuration.userContentController.addUserScript(
//            WKUserScript(source: scriptContent,
//                injectionTime: .atDocumentEnd,
//                forMainFrameOnly: true
//            )
//        )
        
        editorView = EditWebView(frame: .zero)
        addSubview(editorView)
        editorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            editorView.topAnchor.constraint(equalTo: topAnchor),
            editorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            editorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        editorView.navigationDelegate = self
        editorView.uiDelegate = self
        
        if let url = Bundle.main.url(forResource: "froala", withExtension: "html") {
            let request = URLRequest(url: url)
            editorView.load(request)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.editorView.becomeFirstResponder()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //TODO: Any message handling from scripts to be done here
    }
    
}
