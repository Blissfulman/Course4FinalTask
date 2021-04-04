//
//  UICollectionReusableView+Extension.swift
//  Course5FinalTask
//
//  Created by Evgeny Novgorodov on 12.03.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import UIKit

protocol NibCollectionReusableView {
    static var identifier: String { get }
}

extension UICollectionReusableView: NibCollectionReusableView {
    
    static var identifier: String {
        String(describing: Self.self)
    }
        
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
