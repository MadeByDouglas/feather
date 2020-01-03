//
//  ViewController.swift
//  featherDemoMac
//
//  Created by Douglas Hewitt on 12/23/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var editView: TextEditor!
    var stack: NSStackView!

    
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
        
        editView = TextEditor(frame: .zero)
        editView.translatesAutoresizingMaskIntoConstraints = false
        editView.hideToolBar()
        let button = NSButton(title: "Get HTML", target: self, action: #selector(didTap))
        
        stack = NSStackView(views: [editView, button])
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
    
    @objc func didTap() {
        editView.getHTML { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}


