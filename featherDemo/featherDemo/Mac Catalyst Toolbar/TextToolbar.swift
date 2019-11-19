//
//  TextToolbarObject.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/13/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)

enum ToolBarItem: String {
    case format = "format"
    case align = "align"
    case list = "list"
    case size = "size"
    
    
    static let toolBarID = "primaryToolbar"
    
    var id: String {
        return self.rawValue
    }
    
    init(type: NSToolbarItem.Identifier) {
        switch type {
        case .format: self = .format
        case .align: self = .align
        case .list: self = .list
        case .size: self = .size
            
        default: print("You passed an unknown format value, defaulting to format"); self = .format
        }
    }
        
    var type: NSToolbarItem.Identifier {
        switch self {
        case .format: return .format
        case .align: return .align
        case .list: return .list
        case .size: return .size

        }
    }
    
    
    func makeGroupButton() -> NSToolbarItemGroup {
        switch self {
        case .format:
            let images = [TextFormat.bold.image, TextFormat.italic.image, TextFormat.underline.image]
            let names = [TextFormat.bold.imageName, TextFormat.italic.imageName, TextFormat.underline.imageName]
            return configGroupButton(images: images, labels: names, mode: .selectAny)
            
        case .align:
            let images = [TextAlign.left.image, TextAlign.center.image, TextAlign.right.image]
            let names = [TextAlign.left.imageName, TextAlign.center.imageName, TextAlign.right.imageName]
            
            return configGroupButton(images: images, labels: names, mode: .selectOne)
            
        case .list:
            let images = [TextList.bullet.image, TextList.number.image]
            let names = [TextList.bullet.imageName, TextList.number.imageName]
            
            return configGroupButton(images: images, labels: names, mode: .momentary)
            
        case .size:
            let images = [TextSize.fontSize.image]
            let names = [TextSize.fontSize.imageName]
            
            return configGroupButton(images: images, labels: names, mode: .momentary)
        }
    }
    
    private func configGroupButton(images: [UIImage], labels: [String], mode: NSToolbarItemGroup.SelectionMode) -> NSToolbarItemGroup {
        

        let group = NSToolbarItemGroup(itemIdentifier: type, images: images, selectionMode: mode, labels: labels, target: TextToolbarManager.shared, action: .groupButton)
        
        group.accessibilityLabel = id
        for (index, item) in group.subitems.enumerated() {
            item.accessibilityLabel = labels[index]
        }
        
        return group
    }
}

#endif
