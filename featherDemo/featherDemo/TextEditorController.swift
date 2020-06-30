//
//  TextEditorController.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/1/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit
import Feather

final class TextEditorController: UIViewController, UITextViewDelegate, TextViewerDelegate {

    var editView: TextEditor!
    var viewOnlyView: TextViewer!
    var button: UIButton!
    var button2: UIButton!
        
    var stack: UIStackView!
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    func setup() {
        
        #if targetEnvironment(macCatalyst)

        TextToolbarManager.shared.showToolbar()
        
        #endif
        
        editView = TextEditor(type: .froala)
        editView.translatesAutoresizingMaskIntoConstraints = false
        
        viewOnlyView = TextViewer(type: .froala, isScrollingEnabled: true)
        viewOnlyView.translatesAutoresizingMaskIntoConstraints = false
        viewOnlyView.textDelegate = self
        viewOnlyView.backgroundColor = .systemBlue

                
        button = UIButton(type: .contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        button2 = UIButton(type: .roundedRect)
        button2.setTitle("Transfer", for: .normal)
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.addTarget(self, action: #selector(didTapButton2), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [button, button2])
        buttonStack.axis = .horizontal

        stack = UIStackView(arrangedSubviews: [editView, viewOnlyView, buttonStack])
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
    
    @objc func didTapButton2() {
        editView.getHTML { (result) in
            switch result {
            case .success(let html):
                self.viewOnlyView.setHTML(text: html)
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func textViewDidChange(_ textView: UITextView) {
//        let html = editView.getHTML()
//        sourceView.editorView.loadHTMLString(html, baseURL: nil)
    }
    
    func heightDidChange(newHeight: CGFloat) {
        viewOnlyView.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
    }
    
    func didTapLink(_ url: URL) {
        //TODO: respond to links
    }
    
    func didFinishLoading() {
        //TODO: do something
    }
    
}
