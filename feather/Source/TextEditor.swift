//
//  TextEditor.swift
//  MacTest
//
//  Created by Douglas Hewitt on 12/19/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import Foundation
import WebKit

public class TextEditor: TextViewer {
    override var fileName: String { get { return js.editorName } }
    
    // MARK: - HTML methods
    
    /// Gets HTML from all the content inside the editor
    /// - Parameter completion: String completion which gives resulting HTML upon success and error upon failure
    public override func getHTML(completion: @escaping StringCompletion) {
        runJS(js.cleanEmptyTags) { (result) in
            switch result {
            case .success(_):
                self.runJS(self.js.getHTML) { (result) in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Inserts HTML in the editor at the current selection point
    /// - Parameter text: The new HTML to be inserted
    public func insertHTML(text: String) {
        runJS(js.insertHTML(text: text)) { (result) in
            switch result {
            case .success(let html): print(html)
            case .failure(let error): print(error)
            }
        }
    }

    /// Replaces all HTML in the editor
    /// - Parameter text: The new HTML to be set
    public override func setHTML(text: String) {
        runJS(js.setHTML(text: text)) { (result) in
            switch result {
            case .success(let html): print(html)
            case .failure(let error): print(error)
            }
        }
    }
    
    // MARK: - Selection methods
    
    /// Gets the line of HTML from selection of the editor
    /// - Parameter completion: String completion which gives resulting HTML upon success and error upon failure
    public func getSelectedHTML(completion: @escaping StringCompletion) {
        self.runJS(js.getSelectedHTML) { (result) in
            completion(result)
        }
    }
    
    /// Gets plain text from highlighted selection of the editor
    /// - Parameter completion: String completion which gives resulting HTML upon success and error upon failure
    public func getSelectedText(completion: @escaping StringCompletion) {
        self.runJS(js.getSelectedText) { (result) in
            completion(result)
        }
    }
    
    // MARK: - Formatting methods
    
    public func toggleBold() {
        runJS(js.bold)
    }
    
    public func toggleItalic() {
        runJS(js.italic)
    }
    
    public func toggleUnderline() {
        runJS(js.underline)
    }
    
    public func increaseQuote() {
        runJS(js.quoteIncrease)
    }
    
    public func decreaseQuote() {
        runJS(js.quoteDecrease)
    }
    
    public func increaseIndent() {
        runJS(js.indent)
    }
    
    public func reduceIndent() {
        runJS(js.outdent)
    }
    
    // MARK: - Cursor methods
    
    public func cursorEnter() {
        runJS(js.cursorEnter)
    }
    
    // MARK: - Image and File methods
    
    public func getImage(completion: @escaping DataCompletion) {
        runJSData(js.getImage) { (result) in
            completion(result)
        }
    }
    
}
