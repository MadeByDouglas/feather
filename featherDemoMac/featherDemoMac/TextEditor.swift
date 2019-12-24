//
//  TextEditor.swift
//  MacTest
//
//  Created by Douglas Hewitt on 12/19/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation
import WebKit

class EditWebView: WKWebView {

}

class TextEditor: NSView {
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
        
        let label = NSTextField()
        label.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        label.stringValue = "My awesome label"
        label.backgroundColor = .white
        label.isBezeled = false
        label.isEditable = false
        label.sizeToFit()

        addSubview(label)
        
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
