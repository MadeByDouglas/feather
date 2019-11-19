//
//  TextEditor.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/1/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation
import WebKit

class EditWebView: WKWebView {
    var accessory: TextFormatView!

    override var inputAccessoryView: UIView? {
        setupAccessory()
        return accessory
    }
    
    func setupAccessory() {
        accessory = TextFormatView(frame: .zero)
        accessory.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 45)
        accessory.translatesAutoresizingMaskIntoConstraints = false
    }
}

class TextEditor: UIView {
    var editorView: EditWebView!
    
    func getHTML() -> String {
        //TODO: show source
        
        return ""
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
        
        if let url = Bundle.main.url(forResource: "editor", withExtension: "html") {
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
