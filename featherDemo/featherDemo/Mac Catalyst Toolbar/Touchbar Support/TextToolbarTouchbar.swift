//
//  TextToolbarTouchbar.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/13/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)

// MARK: Touchbar support

extension ToolBarItem {
    
    static let touchBarBase = "com.SwiftStarWars."
    static let touchBarID = "\(ToolBarItem.touchBarBase)touchBar"
    
    var idTouch: String {
        
        
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(rawValue)"
    }
    
    init(type: NSTouchBarItem.Identifier) {
        switch type {
        case .format: self = .format
        case .align: self = .align
        case .list: self = .list
        case .size: self = .size
            
        default: print("You passed an unknown format value, defaulting to format"); self = .format
        }
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .format: return .format
        case .align: return .align
        case .list: return .list
        case .size: return .size

        }
    }
    
    func makeGroupTouchbarButton() -> NSTouchBarItem {
        
        switch self {
        case .format:
            
            let buttons = [TextFormat.bold.makeTouchbarButton(), TextFormat.italic.makeTouchbarButton(), TextFormat.underline.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)

        case .align:
            
            let buttons = [TextAlign.left.makeTouchbarButton(), TextAlign.center.makeTouchbarButton(), TextAlign.right.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)
            
        case .list:
            
            let buttons = [TextList.bullet.makeTouchbarButton(), TextList.number.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)

            
        case .size:

            let buttons = [TextSize.fontSize.makeTouchbarButton()]
            
            return NSGroupTouchBarItem(identifier: typeTouch, items: buttons)

        }

    }
}

#endif
