//
//  Storyboard.swift
//  Alias
//
//  Created by Sasha on 08/07/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    case main
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue.capitalized, bundle: nil)
    }
    
    var rootViewController: UIViewController {
        switch self {
            case .main: return MainViewController.instantiate(from: self)
        }
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = viewControllerClass.name
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}


extension UIViewController {
    static var name: String {
        return String(describing: self)
    }
    
    class func instantiate(from appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
    
    func performSegueToReturnBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
