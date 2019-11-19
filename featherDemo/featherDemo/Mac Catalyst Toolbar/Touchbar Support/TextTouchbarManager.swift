//
//  TextTouchbarManager.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/13/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)

//MARK: has to be extension of App Delegate to work correctly

extension AppDelegate: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = ToolBarItem.touchBarID
        touchBar.defaultItemIdentifiers = TextToolbarManager.shared.defaultTouchbarItems + [NSTouchBarItem.Identifier.otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = TextToolbarManager.shared.defaultTouchbarItems
        
        return touchBar

    }
    
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        let item = ToolBarItem(type: identifier)
        return item.makeGroupTouchbarButton()
        
    }

}

#endif
