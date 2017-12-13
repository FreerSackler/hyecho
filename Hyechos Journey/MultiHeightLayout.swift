//
//  MultiHeightLayout.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 3/22/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

protocol MutliHeightLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForItemAt indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
    func numberOfColumns(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> Int
    
    func cellPadding(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat
}

class MultiHeightLayout: UICollectionViewLayout {
    var delegate: MutliHeightLayoutDelegate?
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        return collectionView!.bounds.width - collectionView!.contentInset.left - collectionView!.contentInset.right
    }
    
    override func prepare() {
        if cache.isEmpty, let del = delegate {
            let numberOfColumns = del.numberOfColumns(collectionView!, layout: self)
            let cellPadding = del.cellPadding(collectionView!, layout: self)
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffsets:[CGFloat] = []
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            var currentColumn = 0
            //Offsets in the y direction for each column. e.g. yOffsets[0] is how far down the current cell is in column 0 from the top of the collectionview
            var yOffsets:[CGFloat] = [CGFloat](repeating: 0, count: numberOfColumns)
            for cellNum in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(row: cellNum, section: 0)
                
                //Padding on both sides removed from column width to get cell width
                let cellWidth = columnWidth - cellPadding * 2
                let cellHeight = del.collectionView(collectionView!, layout: self, heightForItemAt: indexPath, withWidth: cellWidth)
                let totalHeight = cellHeight + 2 * cellPadding
                
                //Frame of the cell container
                let frame = CGRect(
                    x: xOffsets[currentColumn],
                    y: yOffsets[currentColumn],
                    width: columnWidth,
                    height: totalHeight
                )
                
                //Frame of the cell
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[currentColumn] += totalHeight
                
                currentColumn += 1
                currentColumn %= numberOfColumns
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes:[UICollectionViewLayoutAttributes] = []
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                attributes.append(attribute)
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        for attribute in cache {
            if attribute.indexPath == indexPath {
                return attribute
            }
        }
        return nil
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        cache = []
        return true
    }
}
