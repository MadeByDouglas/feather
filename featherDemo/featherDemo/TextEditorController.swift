//
//  TextEditorController.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/1/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit
import Feather

final class TextEditorController: UIViewController, UITextViewDelegate {
    

    var editView: TextEditor!
    var button: UIButton!
        
    var stack: UIStackView!
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    func setup() {
        
        #if targetEnvironment(macCatalyst)

        TextToolbarManager.shared.showToolbar()
        
        #endif
        
        editView = TextEditor(type: .froala, frame: .zero)
        editView.translatesAutoresizingMaskIntoConstraints = false
                
        button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        stack = UIStackView(arrangedSubviews: [editView, button])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical

        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    @objc func didTapButton() {
        editView.insertHTML(text: "here's some text how about this 'text'")
    }

    
    func textViewDidChange(_ textView: UITextView) {
//        let html = editView.getHTML()
//        sourceView.editorView.loadHTMLString(html, baseURL: nil)
    }
}
