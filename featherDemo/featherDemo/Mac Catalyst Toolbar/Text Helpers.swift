//
//  TextEnums.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/13/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)

// MARK: toolbar object

enum TextFormat: Int {
    case bold
    case italic
    case underline
    case strikethrough
    
    var imageName: String {
        switch self {
        case .bold: return SymbolName.bold
        case .italic: return SymbolName.italic
        case .underline: return SymbolName.underline
        case .strikethrough: return SymbolName.strikethrough
        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
    
    var type: NSToolbarItem.Identifier {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underline: return .underline
        case .strikethrough: return .strikethrough

        }
    }
    
    func makeButton() -> NSToolbarItem {
        
        let image = UIImage(systemName: imageName)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: TextToolbarManager.shared, action: .barButton)
        let barItem = NSToolbarItem(itemIdentifier: type, barButtonItem: barButton)
        barItem.tag = self.rawValue
        barItem.accessibilityLabel = self.imageName
        
        return barItem
    }
    
    // makes a button with UIbarButton which means it has no border
    func makeButton2() -> NSToolbarItem {
        
        let image = UIImage(systemName: imageName)
        let barItem = NSToolbarItem(itemIdentifier: type)
        barItem.image = image
        barItem.target = TextToolbarManager.shared
        barItem.action = .barButton
        barItem.tag = self.rawValue
        barItem.accessibilityLabel = self.imageName
        
        return barItem
    }
}

enum TextAlign {
    case left
    case center
    case right
    
    var imageName: String {
        switch self {
        case .left: return SymbolName.alignLeft
        case .center: return SymbolName.alignCenter
        case .right: return SymbolName.alignRight
        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
}

enum TextList {
    case bullet
    case number
    
    var imageName: String {
        switch self {
            
        case .bullet: return SymbolName.listBullet
        case .number: return SymbolName.listNumber

        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
}

enum TextSize {
    case fontSize
    case textSub
    case textSuper
    
    var imageName: String {
        switch self {
            
        case .fontSize: return SymbolName.textSize
        case .textSub: return SymbolName.textSub
        case .textSuper: return SymbolName.textSuper

        }
    }
    
    var image: UIImage {
        return UIImage(systemName: imageName)!
    }
}

// MARK: system enum extensions

struct SymbolName {
    static let bold = "bold"
    static let italic = "italic"
    static let underline = "underline"
    static let strikethrough = "strikethrough"
    static let alignLeft = "text.alignleft"
    static let alignCenter = "text.aligncenter"
    static let alignRight = "text.alignright"
    static let listBullet = "list.bullet"
    static let listNumber = "list.number"
    static let textSize = "textformat.size"
    static let textSub = "textformat.subscript"
    static let textSuper = "textformat.superscript"
}

extension Selector {
    static let barButton = #selector(TextToolbarManager.didTapBarButton)
    static let groupButton = #selector(TextToolbarManager.didTapGroupButton)
    static let touchBarButton = #selector(TextToolbarManager.didTapTouchBarButton)
    static let didTapKey = #selector(TextToolbarManager.didTapKey)
}

extension NSToolbarItem.Identifier {
    
    static let format = NSToolbarItem.Identifier(rawValue: ToolBarItem.format.rawValue)
    static let align = NSToolbarItem.Identifier(rawValue: ToolBarItem.align.rawValue)
    static let list = NSToolbarItem.Identifier(rawValue: ToolBarItem.list.rawValue)
    static let size = NSToolbarItem.Identifier(rawValue: ToolBarItem.size.rawValue)

    //just in case we need these as single buttons
    static let bold = NSToolbarItem.Identifier(rawValue: SymbolName.bold)
    static let italic = NSToolbarItem.Identifier(rawValue: SymbolName.italic)
    static let underline = NSToolbarItem.Identifier(rawValue: SymbolName.underline)
    static let strikethrough = NSToolbarItem.Identifier(rawValue: SymbolName.strikethrough)
//
//    static let alignLeft = NSToolbarItem.Identifier(rawValue: SymbolName.alignLeft)
//    static let alignCenter = NSToolbarItem.Identifier(rawValue: SymbolName.alignCenter)
//    static let alignRight = NSToolbarItem.Identifier(rawValue: SymbolName.alignRight)
//
//    static let listBullet = NSToolbarItem.Identifier(rawValue: SymbolName.listBullet)
//    static let listNumber = NSToolbarItem.Identifier(rawValue: SymbolName.listNumber)
//
//    static let textSize = NSToolbarItem.Identifier(rawValue: SymbolName.textSize)
//    static let textSub = NSToolbarItem.Identifier(rawValue: SymbolName.textSub)
//    static let textSuper = NSToolbarItem.Identifier(rawValue: SymbolName.textSuper)
}

extension Notification.Name {
    static let bold = Notification.Name(SymbolName.bold)
    static let italic = Notification.Name(SymbolName.italic)
    static let underline = Notification.Name(SymbolName.underline)
    static let strikethrough = Notification.Name(SymbolName.strikethrough)
    
    static let alignLeft = Notification.Name(SymbolName.alignLeft)
    static let alignCenter = Notification.Name(SymbolName.alignCenter)
    static let alignRight = Notification.Name(SymbolName.alignRight)
    
    static let listBullet = Notification.Name(SymbolName.listBullet)
    static let listNumber = Notification.Name(SymbolName.listNumber)

    static let textSize = Notification.Name(SymbolName.textSize)
    static let textSub = Notification.Name(SymbolName.textSub)
    static let textSuper = Notification.Name(SymbolName.textSuper)
}

#endif
