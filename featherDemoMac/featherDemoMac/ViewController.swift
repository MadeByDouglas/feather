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
    
    @IBOutlet weak var textViewStoryboard: TextViewer!
    
    var savedText = ""
    
    let customToolbar = """
                    'moreText': {
                        'buttons': ['bold', 'italic', 'underline', 'strikeThrough', '|', 'fontFamily', 'fontSize', '|', 'textColor', 'backgroundColor', '|'],
                        'buttonsVisible': 8
                    },
                    'moreParagraph': {
                        'buttons': ['alignLeft', 'alignCenter', 'alignRight', '|', 'formatOL', 'formatUL', 'quote'],
                        'buttonsVisible': 8
                    },
                """
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //MARK: test initial config
        textViewStoryboard.setHTML(text: "Hello storyboard")
        textView.setHTML(text: """
<html><head><meta http-equiv="Content-Type" content="text/html; charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; line-break: after-white-space;" class=""><span class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">Hi,</span><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><br class=""></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><span class="" style="font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify; background-color: rgb(255, 255, 255);">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ultricies vehicula lacinia. Etiam a tortor pellentesque, venenatis risus ac, mattis ligula. Vivamus sodales molestie feugiat. Nunc vitae velit scelerisque, cursus neque vel, feugiat nulla. Integer tristique rutrum massa, eu accumsan metus euismod eu. Proin sit amet mi libero. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam ac consectetur eros. Mauris viverra ut sem quis mattis. Proin viverra auctor purus sed ornare. Vestibulum dignissim mollis eros, non pretium augue laoreet vitae.</span></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><br class=""></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"></div><img src="blob:null/kkl9J01r-icon2x.png" class="fr-fic fr-dib"><br class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><br class=""></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><span class="" style="font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify; background-color: rgb(255, 255, 255);">In felis erat, suscipit vel elementum eu, venenatis sit amet odio. Fusce vitae tellus non enim ornare consectetur quis id mi. Aliquam erat volutpat. Fusce maximus leo in nunc commodo consectetur et quis ligula. Sed ultrices consectetur neque, eget convallis neque fringilla vel. Aenean a libero faucibus, gravida nunc ac, molestie velit. Ut faucibus venenatis tortor, sit amet fermentum nunc cursus a. Vestibulum elementum mi ligula, at ultricies justo venenatis at.</span></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><span class="" style="font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify; background-color: rgb(255, 255, 255);"><br class=""></span></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><span class="" style="font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify; background-color: rgb(255, 255, 255);">Best,</span></div><div class="" style="caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><span class="" style="font-family: &quot;Open Sans&quot;, Arial, sans-serif; font-size: 14px; text-align: justify; background-color: rgb(255, 255, 255);">Hugo</span></div></body></html>
""")
        
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
        
        editView = TextEditor(type: .froala, key: "LICENSE_KEY", toolbar: customToolbar)
        editView.translatesAutoresizingMaskIntoConstraints = false
        editView.textDelegate = self
        
        textView = TextViewer(type: .froala)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textDelegate = self
        textView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        textViewStoryboard.storyboardInit(.froala)
        
        // MARK: Editor example commands
        
        let getButton = NSButton(title: "Editor: Get HTML", target: self, action: #selector(didTapGet))
        let setButton = NSButton(title: "Editor: Set HTML", target: self, action: #selector(didTapSet))
        let insertButton = NSButton(title: "Editor: Insert HTML", target: self, action: #selector(didTapInsert))
        
        // MARK: email example
        
        let emailButton = NSButton(title: "EMAIL Thread", target: self, action: #selector(didTapEmailThread))
        
        // MARK: toolbar
        
        let toolbarToggle = NSButton(title: "toolbar toggle", target: self, action: #selector(didTapToolbar))
        
        // MARK: Editor Image and File commands
        
        let getImageButton = NSButton(title: "Editor: Get Image", target: self, action: #selector(didTapGetImage))
        
        // MARK: Viewer example commands
        
        let getButtonViewer = NSButton(title: "Viewer: Get HTML", target: self, action: #selector(didTapGetViewer))
        let setButtonViewer = NSButton(title: "Viewer: Set HTML", target: self, action: #selector(didTapSetViewer))
        
        let getButtonViewerText = NSButton(title: "Viewer: Get Text", target: self, action: #selector(didTapGetViewerText))
        let setButtonViewerText = NSButton(title: "Viewer: Set Text", target: self, action: #selector(didTapSetViewerText))


        
        let vStack = NSStackView(views: [getButton, setButton, insertButton, getButtonViewer, setButtonViewer, getButtonViewerText, setButtonViewerText])
        vStack.orientation = .vertical
        
        let vStackAttachments = NSStackView(views: [getImageButton, emailButton, toolbarToggle])
        vStackAttachments.orientation = .vertical

        
        stack = NSStackView(views: [editView, textView, vStack, vStackAttachments])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally

        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    // MARK: Email Test
    
    @objc func didTapEmailThread() {
        let emailText = """
                        Hello jim how are you? <br>
                        I am fine
                        """
        
        let quoteText = "<blockquote>" + emailText + "</blockquote>"
        
        editView.insertHTML(text: quoteText)
    }
    
    // MARK: Toolbar
    
    var isToolbarShowing: Bool = true {
        didSet {
            isToolbarShowing ? editView.showToolbar() : editView.hideToolbar()
        }
    }
    
    @objc func didTapToolbar() {
        isToolbarShowing = !isToolbarShowing
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
    
    // MARK: Editor Image and File Tap responses
    
    @objc func didTapGetImage() {
        editView.getImage { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
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
        textViewStoryboard.setHTML(text: savedText)
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

extension ViewController: TextViewerDelegate {
    func didFinishLoading() {
        //hooray its loaded
    }
    
    func heightDidChange(newHeight: CGFloat) {
        //TODO: do something with this for demo
    }
    
    func didTapLink(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
}
