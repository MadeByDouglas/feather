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
    
    var editorName: String {
        switch self {
        case .froala: return "froala"
        case .quill: return "quill"
        }
    }
    
    var viewerName: String {
        switch self {
        case .froala: return "fr-view"
        case .quill: return "quill"
        }
    }
    
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
    
    var getHTML: String {
        switch self {
        case .froala: return "editor.html.get();"
        case .quill: return "editor.getText(0);"
        }
    }
    
    var cleanEmptyTags: String {
        switch self {
        case .froala: return "editor.html.cleanEmptyTags();"
        case .quill: return ""
        }
    }
    
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
    
    func cleanHTML(text: String) -> String {
        
        let escapedText = TextEditor.escapeText(text: text)
        
        switch self {
        case .froala: return "editor.clean.html('\(escapedText)')"
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
}
