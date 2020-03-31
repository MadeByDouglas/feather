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

public typealias DataResult = Swift.Result<Data, Error>
public typealias DataCompletion = (DataResult) -> Void

public typealias StringResult = Swift.Result<String, Error>
public typealias StringCompletion = (StringResult) -> Void

public enum EditorType {
    case froala
    case quill
}

public protocol TextViewerDelegate: class {
    func didTapLink(_ url: URL)
    func heightDidChange(newHeight: CGFloat)
    func didFinishLoading()
}

public class TextViewer: WKWebView {
    var js: JSCommands!
    var fileName: String { get { return js.viewerName } }
    public weak var textDelegate: TextViewerDelegate?
    
    var commandsToRunWhenReady: [String] = []
    
    public init(type: EditorType, key: String = "", toolbar: String? = nil, frame: CGRect = .zero, configuration: WKWebViewConfiguration = WKWebViewConfiguration(), isScrollingEnabled: Bool = false) {
        super.init(frame: frame, configuration: configuration)
        setupWebView(type, key: key, toolbar: toolbar, isScrollingEnabled: isScrollingEnabled)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    public func storyboardInit(_ type: EditorType, key: String = "", toolbar: String? = nil, isScrollingEnabled: Bool = false) {
        setupWebView(type, key: key, toolbar: toolbar, isScrollingEnabled: isScrollingEnabled)
    }
    
    func runJSData(_ js: String, completion: @escaping DataCompletion) {
        
        evaluateJavaScript(js) { (data, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let realData = data as? Data {
                completion(.success(realData))
                return
            }
        }
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
            case .success(let html): print(html); self.getSize()
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
    
    // MARK: Size Methods
    
    func getSize() {
        evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    self.textDelegate?.heightDidChange(newHeight: height as! CGFloat)
                })
            }

            })

    }
}

extension TextViewer: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    //MARK: Load Web View
    private func setupWebView(_ type: EditorType, key: String, toolbar: String?, isScrollingEnabled: Bool) {
        switch type {
        case .froala: js = JSCommands.froala
        case .quill: js = JSCommands.quill
        }
        
        navigationDelegate = self
        uiDelegate = self
        
        #if os(iOS)
        if fileName == js.viewerName {
            setScroll(isScrollingEnabled)
        }
        #endif
        setupWebConfig()
        
        if type == .froala && fileName == js.editorName {
            
            #if targetEnvironment(macCatalyst)
            let style = UITraitCollection.current.userInterfaceStyle
            let theme = style == .dark ? "dark" : ""
            setupFroalaScript(key: key, toolbar: toolbar, theme: theme)
            #elseif os(iOS)
            let style = UITraitCollection.current.userInterfaceStyle
            let theme = style == .dark ? "dark" : ""
            setupFroalaScript(key: key, toolbar: toolbar, theme: theme)
            #else
            let theme = isDarkMode ? "dark" : ""
            setupFroalaScript(key: key, toolbar: toolbar, theme: theme)
            #endif
            
        }
                
        let frameworkBundle = Bundle(for: TextViewer.self)
        loadRequest(frameworkBundle)
    }
    
    #if os(iOS)
    private func setScroll(_ value: Bool) {
        scrollView.isScrollEnabled = value
        scrollView.bounces = value
        scrollView.alwaysBounceVertical = value
        scrollView.alwaysBounceHorizontal = value
        scrollView.panGestureRecognizer.isEnabled = value
        allowsBackForwardNavigationGestures = value
    }
    #endif
    
    private func setupWebConfig() {
//        let source: String = "var meta = document.createElement('meta');" +
//            "meta.name = 'viewport';" +
//            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
//            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
        
        let viewportScriptString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0'); meta.setAttribute('minimum-scale', '1.0'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);"

        let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"

        let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"

        
        let viewportScript = WKUserScript(source: viewportScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let disableSelectionScript = WKUserScript(source: disableSelectionScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let disableCalloutScript = WKUserScript(source: disableCalloutScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)


//        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        configuration.userContentController.addUserScript(script)
        
        configuration.userContentController.addUserScript(viewportScript)
        configuration.userContentController.addUserScript(disableSelectionScript)
        configuration.userContentController.addUserScript(disableCalloutScript)

        
        // for custom base URLs
//        configuration.setURLSchemeHandler(FeatherSchemeHandler(), forURLScheme: "feather-local")
        
        // listener for events
//        configuration.userContentController.add(self, name: js.linkOpen)
    }
    
    private func setupFroalaScript(key: String, toolbar: String?, theme: String = "") {
        
        let defaultToolbar = """
                                'moreText': {
                                  'buttons': ['bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript', 'fontFamily', 'fontSize', 'textColor', 'backgroundColor', 'inlineClass', 'inlineStyle', 'clearFormatting']
                                },
                                'moreParagraph': {
                                  'buttons': ['alignLeft', 'alignCenter', 'formatOLSimple', 'alignRight', 'alignJustify', 'formatOL', 'formatUL', 'paragraphFormat', 'paragraphStyle', 'lineHeight', 'outdent', 'indent', 'quote']
                                },
                                'moreRich': {
                                  'buttons': ['insertLink', 'insertImage', 'insertVideo', 'insertTable', 'emoticons', 'fontAwesome', 'specialCharacters', 'embedly', 'insertFile', 'insertHR']
                                },
                                'moreMisc': {
                                  'buttons': ['undo', 'redo', 'fullscreen', 'print', 'getPDF', 'spellChecker', 'selectAll', 'html', 'help'],
                                  'align': 'right',
                                  'buttonsVisible': 2
                                }
                            """

        let jsString = """
                    var editor = new FroalaEditor('#editor', {
                                                    key: "\(key)",
                                                    theme: '\(theme)',
                                                    attribution: false,
                                                    charCounterCount: false,
                                                    placeholderText: '',
                                                    quickInsertEnabled: false,
                                                    toolbarButtons: {
                                                        \(toolbar ?? defaultToolbar)
                                                    },
                                                  
                                                  events: {
                                                    'commands.after': function (cmd, param1, param2) {
                                                        // console.log(cmd);
                                                        // console.log(param1);
                                                        // console.log(param2);
                                                        
                                                        if(cmd == 'linkOpen') {
                                                            window.webkit.messageHandlers.linkOpen.postMessage(this.selection.element().href);
                                                        }

                                                    },

                                                    'url.linked': function (link) {
                                                      // Do something here.
                                                      // this is the editor instance.
                                                      // console.log(link);
                                                    },

                                                    'image.inserted': function ($img, response) {
                                                      // Do something here.
                                                      // this is the editor instance.
                                                      console.log($img);
                                                      console.log(this);
                                                    }
                                                  }


                                                  },
                                                  function () {
                                                    // editor.toolbar.hide();
                                                  })

                    """

        let jsScript = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(jsScript)
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
            runJS(js) { (result) in
                switch result {
                case .success(_):
                    self.getSize()
                    self.textDelegate?.didFinishLoading()

                case .failure(let error):
                    print(error)
                }
            }
        }
        commandsToRunWhenReady = []
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case js.linkOpen:
            print(message.body)
            let messageBody = message.body as! String
            let url = URL(string: messageBody)!
            print(url)
            textDelegate?.didTapLink(url)
            
        default:
            let messageBody = message.body as? String
            print(messageBody ?? "Unable to parse message body")
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated  {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            textDelegate?.didTapLink(url)
            decisionHandler(.cancel)

        } else {
            decisionHandler(.allow)
        }

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


//class FeatherSchemeHandler: NSObject, WKURLSchemeHandler {
//    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
//
//
//        let bundle = Bundle(for: TextViewer.self)
//        guard let url = bundle.url(forResource: "fr-view", withExtension: "html") else {
//            return
//        }
//
//        let data = try! Data(contentsOf: url)
//
//        let response = URLResponse(
//            url: urlSchemeTask.request.url!,
//            mimeType: "text/html",
//            expectedContentLength: -1,
//            textEncodingName: nil)
//
//        urlSchemeTask.didReceive(response)
//        urlSchemeTask.didReceive(data)
//        urlSchemeTask.didFinish()
//    }
//
//    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
//        // do nothing
//    }
//}


#if os(macOS)
extension NSView {
    var isDarkMode: Bool {
        if #available(OSX 10.14, *) {
            if effectiveAppearance.name == .darkAqua {
                return true
            }
        }
        return false
    }
}
#endif
