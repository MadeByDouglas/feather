//
//  AccessoryView.swift
//  SwiftStarWars
//
//  Created by Douglas Hewitt on 11/1/19.
//  Copyright © 2019 Douglas Hewitt. All rights reserved.
//

import UIKit


class TextFormatView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = .lightGray
        self.alpha = 0.6
        
        boldButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(boldButton)
        NSLayoutConstraint.activate([
        boldButton.trailingAnchor.constraint(equalTo:
        trailingAnchor, constant: -20),
        boldButton.centerYAnchor.constraint(equalTo:
        centerYAnchor)
        ])

    }
    
    let boldButton: UIButton! = {
        let sendButton = UIButton(type: .custom)
        sendButton.setTitleColor(.darkText, for: .normal)
        sendButton.setTitle("Bold", for: .normal)
        sendButton.setTitleColor(.white, for: .disabled)
        sendButton.addTarget(self, action: #selector(didTapBold), for: .touchUpInside)
        sendButton.showsTouchWhenHighlighted = true
        sendButton.isEnabled = true
        return sendButton
    }()
    
    @objc func didTapBold() {
        print("bold")
        
    }
}
