//
//  TextToolbarManager.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/13/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)

// MARK: Singleton Manager coordinates toolbar and touchbar

class TextToolbarManager: UIResponder, NSToolbarDelegate {
    static var shared = TextToolbarManager()
    
    let defaultItems: [NSToolbarItem.Identifier] = [.format, .align, .list]
    let defaultTouchbarItems: [NSTouchBarItem.Identifier] = [.format, .list]

    
    lazy var toolbar: NSToolbar = {
        let toolbar = NSToolbar(identifier: ToolBarItem.toolBarID)
        toolbar.delegate = self
        
        return toolbar
    }()
    
    func setupTitleBar(_ windowScene: UIWindowScene) {
        if let titlebar = windowScene.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = toolbar
        }
        
        setupNotifications()
    }
    
    func hideToolbar() {
        toolbar.isVisible = false
//        guard toolbar.items.count > 0 else {return}
//        guard let visItems = toolbar.visibleItems else {return}
//        for (i, item) in visItems.enumerated() {
//            toolbar.removeItem(at: i)
//            item.isEnabled = false
//        }
    }
    
    func showToolbar() {
        
        toolbar.isVisible = true
//        guard toolbar.items.count == 0 else {return}
//
//        toolbar.insertItem(withItemIdentifier: .format, at: 0)
//        toolbar.insertItem(withItemIdentifier: .align, at: 1)
//        toolbar.insertItem(withItemIdentifier: .list, at: 2)
    }
    
    // MARK: button action handlers

    @objc func didTapBarButton(sender: UIBarButtonItem) {
        
        sendTextFormatCommand(name: sender.accessibilityLabel!)
    }
    
    @objc func didTapGroupButton(sender: NSToolbarItemGroup) {
        let index = sender.selectedIndex
        
        //MARK: this is necessary because it auto selects and we need to undo the selection and re apply it later to coordinate with touchbar events.
        let state = sender.isSelected(at: index)
        sender.setSelected(!state, at: index)
        
        sendTextFormatCommand(name: sender.subitems[index].accessibilityLabel!)
    }
    
    @objc func didTapTouchBarButton(sender: NSButtonTouchBarItem) {
        
        sendTextFormatCommand(name: sender.customizationLabel)
    }
    
    func sendTextFormatCommand(name: String) {
    
        let notify = Notification(name: Notification.Name(rawValue: name))
        NotificationCenter.default.post(notify)
    }
    
    // MARK: Toolbar Delegate functions
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        let type = ToolBarItem(type: itemIdentifier)
        return type.makeGroupButton()
        
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return defaultItems
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        let allowedItems: [NSToolbarItem.Identifier] = defaultItems + [.space, .flexibleSpace, .print]
        return allowedItems
    }
    
    
    // MARK: Setup notification listeners to update button state
    
    func setupNotifications() {
        
        NotificationCenter.default.addObserver(forName: .bold, object: nil, queue: nil) { (notify) in
            self.updateButton(index: 0)
        }
        
        NotificationCenter.default.addObserver(forName: .italic, object: nil, queue: nil) { (notify) in
            self.updateButton(index: 1)
        }
        
        NotificationCenter.default.addObserver(forName: .underline, object: nil, queue: nil) { (notify) in
            self.updateButton(index: 2)
        }
        
        NotificationCenter.default.addObserver(forName: .strikethrough, object: nil, queue: nil) { (notify) in
            self.updateButton(index: 3)
        }
    }
    
    
    //TODO: doesnt seem to work, needs to be implmenented in VC by overriding 'var keyCommands'
    func setupKeyboardListeners() -> [UIKeyCommand] {
        
        let bold = UIKeyCommand(input: "b", modifierFlags: .command, action: .didTapKey)
        let italic = UIKeyCommand(input: "i", modifierFlags: .command, action: .didTapKey)
        let underline = UIKeyCommand(input: "u", modifierFlags: .command, action: .didTapKey)
        
        return [bold, italic, underline]

    }
    
    @objc func didTapKey(sender: UIKeyCommand) {
        if sender.input == "b" {
            updateButton(index: 0)
        } else if sender.input == "i" {
            updateButton(index: 1)
        } else if sender.input == "u" {
            updateButton(index: 2)
        }
    }
    
    func updateButton(index: Int) {
        guard toolbar.items.count > 0 else {return}

        if let item = toolbar.items.first {
            let group = item as! NSToolbarItemGroup
            let currentState = group.isSelected(at: index)
            group.setSelected(!currentState, at: index)
        }
    }
    
}

#endif
