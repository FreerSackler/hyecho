//
//  CollectionViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 7/21/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController {
    
    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    fileprivate var statusBarHidden = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for cell in collectionView.visibleCells {
            if let imageCell = cell as? ImageCell {
                imageCell.imageView.removeFromSuperview()
                imageCell.imageView = nil
            }
        }
    }
    
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    
    // MARK:- Selected Cell IndexPath
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        
        var indexPath:IndexPath?
        
        if collectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = collectionView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
}

// MARK:- Add Cell


// MARK:- UICollectionView DataSource

extension CollectionViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! ImageCell
        
        var chapter = DataController.sharedData.plist[indexPath.row]["Object Info"] as! [String:Any]
        let image = UIImage(named: (chapter["ImagePath"] as? String)! + "_thumbnail")
        
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        var chapter = DataController.sharedData.plist[indexPath.row]["Object Info"] as! [String:Any]
        let bundlePath = Bundle.main.path(forResource: chapter["ImagePath"] as? String, ofType: "png")
        let image = UIImage(contentsOfFile: bundlePath!)
        
        let popup = UINib(nibName: "DetailImageView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first! as! DetailImagePopupView
        popup.imageView.backgroundColor = UIColor.black//UIColor(hexString: hexColor)
        popup.imageView.image = image
        popup.scrollView.maximumZoomScale = 12
        popup.scrollView.delegate = popup
        popup.scrollView.pinchGestureRecognizer!.isEnabled = true
        let wasNavigationBarHidden = self.navigationController!.isNavigationBarHidden
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
        navigationController?.barHideOnSwipeGestureRecognizer.isEnabled = false
        navigationController?.setToolbarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        statusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
        present(
            popup: popup,
            insets: UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            ),
            cornerRadius: 0,
            duration: 0.5,
            completion: {
                //Stuff after the popup is cancelled
                self.navigationController?.setNavigationBarHidden(wasNavigationBarHidden, animated: true)
                self.navigationController?.barHideOnTapGestureRecognizer.isEnabled = true
                self.navigationController?.barHideOnSwipeGestureRecognizer.isEnabled = true
                self.statusBarHidden = false
                self.setNeedsStatusBarAppearanceUpdate()
                popup.imageView.removeFromSuperview()
                popup.imageView = nil
        }
        )
    }
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
     let headerView: FruitsHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! FruitsHeaderView
     
     headerView.sectionLabel.text = "Stuff"
     
     return headerView
     }*/
}





extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let length = (UIScreen.main.bounds.width-15)/2
        return CGSize(width: length,height: length);
    }
}


class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
