//
//  toolBarInfo.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 5/23/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation

import UIKit

class ToolBarInfo {
    
    static var shared: ToolBarInfo = ToolBarInfo()
    
    @objc func onClickBarButton(sender: UIButton) {
       
        let buttonNumber = sender.tag
        buttonActions[buttonNumber]?(sender)
    }
    
    var buttonActions: [((UIButton) -> ())?] = [nil,nil,nil,nil]
    
    func getBarButtons() -> [UIBarButtonItem] {
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "BackButton"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 77, height: 25)
        backButton.addTarget(self, action: #selector(onClickBarButton), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: backButton)
        backButton.tag = 0
        
        if #available(iOS 11, *) {
            backButton.widthAnchor.constraint(equalToConstant: 77).isActive = true
            backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
      
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let nextButton = UIButton(type: .custom)
        nextButton.setImage(UIImage(named: "RelatedObject"), for: .normal)
        nextButton.frame = CGRect(x: 0, y: 0, width: 101, height: 25)
        nextButton.addTarget(self, action: #selector(onClickBarButton), for: .touchUpInside)
        let item4 = UIBarButtonItem(customView: nextButton)
        nextButton.tag = 1
        
        if #available(iOS 11, *) {
            nextButton.widthAnchor.constraint(equalToConstant: 101).isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        
        let negativeSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpace.width = 0;
        
        let positiveSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        positiveSpace.width = 0;
        
        let items = [negativeSpace, item1, space, space, space, space, space, item4, positiveSpace]
        
        return items
    }
    
    func getMapBarButtons(chapter: Int) -> [UIBarButtonItem] {
        
        let directionsButton = UIButton(type: .custom)
        directionsButton.setImage(UIImage(named: "DirectionsButton"), for: .normal)
        directionsButton.frame = CGRect(x: 0, y: 0, width: 110, height: 12)
        directionsButton.addTarget(self, action: #selector(onClickBarButton), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: directionsButton)
        directionsButton.tag = 0
        
        if #available(iOS 11, *) {
            directionsButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
            directionsButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
        
        let legendButton = UIButton(type: .custom)
        legendButton.setImage(UIImage(named: "LegendButton"), for: .normal)
        legendButton.frame = CGRect(x: 0, y: 0, width: 55, height: 12)
        legendButton.addTarget(self, action: #selector(onClickBarButton), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: legendButton)
        legendButton.tag = 1
        
        if #available(iOS 11, *) {
            legendButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
            legendButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        var items = [DataController.sharedData.negativeSpace, item1, space, space, space, space, item2]
        
        if (chapter == 0 || !DataController.sharedData.linearJourney) {
            items = [space, space, space, space, item2]
        }
        
        
        
        return items
    }
}
