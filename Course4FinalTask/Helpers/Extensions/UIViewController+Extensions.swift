//
//  UIViewController+Extensions.swift
//  Course4FinalTask
//
//  Created by User on 17.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
}
