//
//  Commands.swift
//  FeatherDemoMac
//
//  Created by Douglas Hewitt on 1/2/20.
//  Copyright © 2020 Douglas Hewitt. All rights reserved.
//

import Foundation

enum JSCommands {
    case froala
    case quill
    
    
    // MARK: - Text Viewer
    
    var viewerName: String {
        switch self {
        case .froala: return "fr-view"
        case .quill: return "quill"
        }
    }
    
    // MARK: HTML commands
    
    var viewerGetHTML: String {
        return "document.getElementById('viewer').innerHTML;"
    }
    
    func viewerSetHTML(text: String) -> String {
        let escapedText = TextEditor.escapeText(text: text)
        return "document.getElementById('viewer').innerHTML = '\(escapedText)';"
    }
    
    // MARK: Plain text commands
    
    var viewerGetText: String {
        return "document.getElementById('viewer').textContent;"
    }
    
    func viewerSetText(text: String) -> String {
        let escapedText = TextEditor.escapeText(text: text)
        return "document.getElementById('viewer').textContent = '\(escapedText)';"
    }
    
    // MARK: - Text Editor
    
    var editorName: String {
        switch self {
        case .froala: return "froala"
        case .quill: return "quill"
        }
    }
    
    // MARK: Format commands
    
    var bold: String {
        switch self {
        case .froala: return "editor.commands.bold();"
        case .quill: return "editor.format('bold', true);"
        }
    }
    
    var italic: String {
        switch self {
        case .froala: return "editor.commands.italic();"
        case .quill: return "editor.format('italic', true);"
        }
    }
    
    var underline: String {
        switch self {
        case .froala: return "editor.commands.underline();"
        case .quill: return "editor.format('underline', true);"
        }
    }
    
    var quoteIncrease: String {
        switch self {
        case .froala: return "editor.quote.apply('increase');"
        case .quill: return ""
        }
    }
    
    var quoteDecrease: String {
        switch self {
        case .froala: return "editor.quote.apply('decrease');"
        case .quill: return ""
        }
    }
    
    var indent: String {
        switch self {
        case .froala: return "editor.commands.indent();"
        case .quill: return "editor.format('indent', true);"
        }
    }
    
    var outdent: String {
        switch self {
        case .froala: return "editor.commands.outdent();"
        case .quill: return "editor.format('outdent', true);"
        }
    }
    
    // MARK: Cursor commands
    
    var cursorEnter: String {
        switch self {
        case .froala: return "editor.cursor.enter(false);"
        case .quill: return ""
        }
    }
    
    // MARK: Toolbar commands
    
    var hideToolbar: String {
        switch self {
        case .froala: return "editor.toolbar.hide();"
        case .quill: return ""
        }
    }
    
    var showToolbar: String {
        switch self {
        case .froala: return "editor.toolbar.show();"
        case .quill: return ""
        }
    }
    
    // MARK: Clean commands
    
    var cleanEmptyTags: String {
        switch self {
        case .froala: return "editor.html.cleanEmptyTags();"
        case .quill: return ""
        }
    }
    
    func cleanHTML(text: String) -> String {
        
        let escapedText = TextEditor.escapeText(text: text)
        
        switch self {
        case .froala: return "editor.clean.html('\(escapedText)');"
        case .quill: return ""
        }
    }
    
    // MARK: HTML commands
    
    var getHTML: String {
        switch self {
        case .froala: return "editor.html.get();"
        case .quill: return "editor.getText(0);"
        }
    }
    
    var getSelectedHTML: String {
        switch self {
        case .froala: return "editor.html.getSelected();"
        case .quill: return ""
        }
    }
    
    func insertHTML(text: String, clean: Bool = true) -> String {
        let escapedText = TextEditor.escapeText(text: text)
        
        switch self {
        case .froala: return "editor.html.insert('\(escapedText)', \(clean));"
        case .quill: return "editor.setText('\(escapedText)');"
        }
    }
    
    func setHTML(text: String) -> String {
        let escapedText = TextEditor.escapeText(text: text)
        
        switch self {
        case .froala: return "editor.html.set('\(escapedText)');"
        case .quill: return "editor.setText('\(escapedText)');"
        }
    }
    
    // MARK: Selection Commands
    
    var getSelectedText: String {
        switch self {
        case .froala: return "editor.selection.text();"
        case .quill: return ""
        }
    }
    
    // MARK: Image Commands
    
    var getImage: String {
        switch self {
        case .froala: return "editor.image.get();"
        case .quill: return ""
        }
    }
    
    // MARK: Script Events
    
    var linkOpen: String {
        switch self {
        case .froala: return "linkOpen"
        case .quill: return ""
        }
    }
}
