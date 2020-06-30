//
//  TestCollectionViewCell.swift
//  featherDemo
//
//  Created by Douglas Hewitt on 2/25/20.
//  Copyright © 2020 Douglas Hewitt. All rights reserved.
//

import UIKit
import Feather

protocol TestCellDelegate: class {
    func didUpdateHeight(cell: TestCollectionViewCell, height: CGFloat)
    func shouldToggleCellHeight(cell: TestCollectionViewCell)
}

class TestCollectionViewCell: UICollectionViewCell, TextViewerDelegate {
    
    let dummyText = "At a time of environmental precarity and extreme inequality, a handful of the world’s biggest entertainment and technology companies collectively sunk billions of dollars into virtual worlds of increasing vastness and detail, arguably outstripping Rome’s ancient Colosseum in spectacle if not actual bloodlust (despite the digital body count sitting much higher). At the turn of the millennium, early 3D efforts such as Shenmue and Grand Theft Auto III set the blueprint of expansive spaces and nonlinear play, and by the mid-2010s, the games had evolved into near-photorealistic behemoths created by workforces spanning many continents. In 2018, Red Dead Redemption 2 — arguably the biggest, most convincing, and successful recent open-world title — pushed the ballooning approach to its logical extreme."
    
    
    
    func didTapLink(_ url: URL) {
        //do nothing
    }
    
    func heightDidChange(newHeight: CGFloat) {
        delegate.didUpdateHeight(cell: self, height: newHeight)
    }
    
    func didFinishLoading() {
        //do nothing
    }
    
    
    @IBOutlet weak var textView: TextViewer!
    
    
    weak var delegate: TestCellDelegate!
    
    @IBAction func didTapButton(_ sender: Any) {
        delegate.shouldToggleCellHeight(cell: self)
    }
    
    
    func config() {
        textView.storyboardInit(.froala)
        textView.textDelegate = self
        
        textView.setHTML(text: dummyText)
        

        
    }
    
}
