//
//  AppKitExtensions.swift
//  Feather
//
//  Created by Douglas Hewitt on 2/6/20.
//  Copyright © 2020 Douglas Hewitt. All rights reserved.
//

import AppKit

extension TextViewer {
    
    public func setupLoadIndicator() -> NSProgressIndicator {
        let activity = NSProgressIndicator()
        activity.style = .spinning
        self.addSubview(activity)
        activity.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activity.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        return activity
    }
}
