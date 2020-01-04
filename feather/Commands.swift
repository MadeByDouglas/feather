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
    
    var fileName: String {
        switch self {
        case .froala: return "froala"
        case .quill: return "quill"
        }
    }
    
    var bold: String {
        switch self {
        case .froala: return "editor.commands.bold();"
        case .quill: return ""
        }
    }
    
    var italic: String {
        switch self {
        case .froala: return "editor.commands.italic();"
        case .quill: return ""
        }
    }
    
    var underline: String {
        switch self {
        case .froala: return "editor.commands.underline();"
        case .quill: return ""
        }
    }
    
    var indent: String {
        switch self {
        case .froala: return "editor.commands.indent();"
        case .quill: return ""
        }
    }
    
    var outdent: String {
        switch self {
        case .froala: return "editor.commands.outdent();"
        case .quill: return ""
        }
    }
    
    var getHTML: String {
        switch self {
        case .froala: return "editor.html.get();"
        case .quill: return ""
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
        switch self {
        case .froala: return "editor.clean.html('\(text)')"
        case .quill: return ""
        }
    }
    
    func insertHTML(text: String, clean: Bool = true) -> String {
        switch self {
        case .froala: return "editor.html.insert('\(text)', \(clean));"
        case .quill: return ""
        }
    }
}
