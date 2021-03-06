//
//  MarkerTextLayer.swift
//  InteractiveClusteringMap
//
//  Created by A on 2020/12/03.
//

import Foundation
import UIKit

class MarkerTextLayer: CATextLayer {
    
    init(radius: CGFloat, text: String) {
        super.init()
        self.configure(radius: radius, text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(radius: CGFloat, text: String) {
        bounds = CGRect(x: 0, y: 0, width: radius * 2, height: 20)
        
        fontSize = 15
        font = UIFont.systemFont(ofSize: 15, weight: .medium)
        alignmentMode = .center
        string = text
        isWrapped = true
        truncationMode = .end
        backgroundColor = UIColor.clear.cgColor
        foregroundColor = UIColor.white.cgColor
        contentsScale = UIScreen.main.scale
    }
    
}
