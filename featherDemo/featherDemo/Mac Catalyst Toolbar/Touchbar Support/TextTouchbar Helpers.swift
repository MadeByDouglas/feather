//
//  TextTouchbar Helpers.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/13/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)

extension TextFormat {
    
    var idTouch: String {
        
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .bold: return .bold
        case .italic: return .italic
        case .underline: return .underline
        case .strikethrough: return .strikethrough

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        
        
        
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }
    
}

extension TextAlign {
    
    var idTouch: String {
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .left: return .alignLeft
        case .center: return .alignCenter
        case .right: return .alignRight

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }
    
}

extension TextList {
    
    var idTouch: String {
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .bullet: return .alignLeft
        case .number: return .alignCenter

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }
}

extension TextSize {
    
    var idTouch: String {
        return "\(ToolBarItem.touchBarBase)TouchBarItem.\(imageName)"
    }
    
    var typeTouch: NSTouchBarItem.Identifier {
        switch self {
        case .fontSize: return .textSize
        case .textSub: return .textSub
        case .textSuper: return .textSuper

        }
    }
    
    func makeTouchbarButton() -> NSTouchBarItem {
        let touchBarItem = NSButtonTouchBarItem(identifier: typeTouch, image: image, target: TextToolbarManager.shared, action: .touchBarButton)
        touchBarItem.customizationLabel = self.imageName
        
        return touchBarItem

    }

}

extension NSTouchBarItem.Identifier {
    
    static let format = NSTouchBarItem.Identifier(ToolBarItem.format.idTouch)
    static let align = NSTouchBarItem.Identifier(ToolBarItem.align.idTouch)
    static let list = NSTouchBarItem.Identifier(ToolBarItem.list.idTouch)
    static let size = NSTouchBarItem.Identifier(ToolBarItem.size.idTouch)

    
    static let bold = NSTouchBarItem.Identifier(TextFormat.bold.idTouch)
    static let italic = NSTouchBarItem.Identifier(TextFormat.italic.idTouch)
    static let underline = NSTouchBarItem.Identifier(TextFormat.underline.idTouch)
    static let strikethrough = NSTouchBarItem.Identifier(TextFormat.strikethrough.idTouch)

    static let alignLeft = NSTouchBarItem.Identifier(TextAlign.left.idTouch)
    static let alignCenter = NSTouchBarItem.Identifier(TextAlign.center.idTouch)
    static let alignRight = NSTouchBarItem.Identifier(TextAlign.right.idTouch)

    static let listBullet = NSTouchBarItem.Identifier(TextList.bullet.idTouch)
    static let listNumber = NSTouchBarItem.Identifier(TextList.number.idTouch)

    static let textSize = NSTouchBarItem.Identifier(TextSize.fontSize.idTouch)
    static let textSub = NSTouchBarItem.Identifier(TextSize.textSub.idTouch)
    static let textSuper = NSTouchBarItem.Identifier(TextSize.textSuper.idTouch)
}

#endif
