//
//  ViewController.swift
//  featherDemoMac
//
//  Created by Douglas Hewitt on 12/23/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Cocoa
import FeatherAppKit

class ViewController: NSViewController {

    var editView: TextEditor!
    var textView: TextViewer!
    var stack: NSStackView!

    var savedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    func setup() {
        
        editView = TextEditor(type: .froala, frame: .zero)
        editView.translatesAutoresizingMaskIntoConstraints = false
        
        textView = TextViewer(type: .froala, frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false

        
        // MARK: Editort example commands
        
        let getButton = NSButton(title: "Editor: Get HTML", target: self, action: #selector(didTapGet))
        let setButton = NSButton(title: "Editor: Set HTML", target: self, action: #selector(didTapSet))
        let insertButton = NSButton(title: "Editor: Insert HTML", target: self, action: #selector(didTapInsert))
        
        // MARK: Viewer example commands
        
        let getButtonViewer = NSButton(title: "Viewer: Get HTML", target: self, action: #selector(didTapGetViewer))
        let setButtonViewer = NSButton(title: "Viewer: Set HTML", target: self, action: #selector(didTapSetViewer))
        
        let getButtonViewerText = NSButton(title: "Viewer: Get Text", target: self, action: #selector(didTapGetViewerText))
        let setButtonViewerText = NSButton(title: "Viewer: Set Text", target: self, action: #selector(didTapSetViewerText))


        
        let vStack = NSStackView(views: [getButton, setButton, insertButton, getButtonViewer, setButtonViewer, getButtonViewerText, setButtonViewerText])
        vStack.orientation = .vertical

        
        stack = NSStackView(views: [editView, textView, vStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually

        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    // MARK: Editor tap responses
    
    @objc func didTapGet() {
        editView.getHTML { (result) in
            switch result {
            case .success(let data):
                self.savedText = data
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func didTapSet() {
        editView.setHTML(text: savedText)
    }
    
    @objc func didTapInsert() {
        editView.insertHTML(text: savedText)
    }
    
    // MARK: Viewer tap responses
    
    @objc func didTapGetViewer() {
        textView.getHTML { (result) in
            switch result {
            case .success(let data):
                self.savedText = data
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func didTapSetViewer() {
        textView.setHTML(text: savedText)
    }
    
    @objc func didTapGetViewerText() {
        textView.getText { (result) in
            switch result {
            case .success(let data):
                self.savedText = data
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func didTapSetViewerText() {
        textView.setText(text: savedText)
    }
}


