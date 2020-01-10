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
    
    public override func insertHTML(text: String) {
        runJS(js.insertHTML(text: text)) { (result) in
            switch result {
            case .success(let html): print(html)
            case .failure(let error): print(error)
            }
        }
        
    }
    
    public func toggleBold() {
        runJS(js.bold)
    }
    
    public func toggleItalic() {
        runJS(js.italic)
    }
    
    public func toggleUnderline() {
        runJS(js.underline)
    }
    
    public func increaseIndent() {
        runJS(js.indent)
    }
    
    public func reduceIndent() {
        runJS(js.outdent)
    }
    
    public func hideToolBar() {
        runJS(js.showToolbar)
    }
}
