//
//  TestCollectionViewController.swift
//  featherDemo
//
//  Created by Douglas Hewitt on 2/25/20.
//  Copyright © 2020 Douglas Hewitt. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, TestCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = setupLayout(height: 200)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
//        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TestCollectionViewCell
        cell.config()
        cell.delegate = self
        return cell
    }
    
    var cellHeights: [IndexPath:CGFloat] = [:]
        
    func didUpdateHeight(cell: TestCollectionViewCell, height: CGFloat) {
        
        let index = collectionView.indexPath(for: cell)!
        cellHeights[index] = height
    }
    
    func shouldToggleCellHeight(cell: TestCollectionViewCell) {
        let index = collectionView.indexPath(for: cell)!
        let height = cellHeights[index]! + 180
        
        collectionView.collectionViewLayout = setupLayout(height: height)

        collectionView.invalidateIntrinsicContentSize()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        
    }
    
    // MARK: Flow Delegate
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let size = CGSize(width: collectionView.frame.width, height: 800)
//
//
//        return size
//
//    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension TestCollectionViewController {
    
    func setupLayout(height: CGFloat) -> UICollectionViewCompositionalLayout {
        
//        var items: [NSCollectionLayoutItem] = []
//        for index in 1...collectionView.numberOfItems(inSection: 0) {
            
            let cellSize = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(height)
            )
            let item = NSCollectionLayoutItem(layoutSize: cellSize)
//            items.append(item)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: cellSize, subitem: item, count: 1)

//        }
        
        
//        let se = NSCollectionLayoutGroup.vertical(layoutSize: <#T##NSCollectionLayoutSize#>, subitems: <#T##[NSCollectionLayoutItem]#>)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            section.interGroupSpacing = 12


    // NOTE: just leaving this for reference in case we need a header later

    //        let headerFooterSize = NSCollectionLayoutSize(
    //            widthDimension: .fractionalWidth(1.0),
    //            heightDimension: .absolute(40)
    //        )
    //        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
    //            layoutSize: headerFooterSize,
    //            elementKind: "SectionHeaderElementKind",
    //            alignment: .top
    //        )
    //        section.boundarySupplementaryItems = [sectionHeader]
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        }
    
}
