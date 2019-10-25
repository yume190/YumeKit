//
//  Menu+Type.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/9/16.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension Menu {
    public enum Types {
        case storyboard(storyboard: String, name: String)
        case storyboardNav(storyboard: String, name: String)
        case xib(() -> UIViewController?)
        case vc(UIViewController?)
        case nav(UIViewController?)
        case function((UIViewController?) -> Void)
    }
}


extension Menu.Types {
    public var viewController: UIViewController? {
        switch self {
        case .storyboard(let storyboard, let name):
            return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: name)
        case .storyboardNav(let storyboard, let name):
            let vc = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: name)
            return Menu.Types.embedInNavVC(vc: vc)
        case .xib(let vc):
            return vc()
        case .vc(let vc):
            return vc
        case .nav(let vc):
            guard let vc = vc else { return nil }
            let nav = Menu.Types.embedInNavVC(vc: vc)
            return nav
        default:
            return nil
        }
    }
    
    public var name: String {
        switch self {
        case .storyboard(_, let name):
            return name
        case .storyboardNav(_, let name):
            return name
        case .xib(let vc):
            return "\(String(describing: vc()))"
        case .vc(let vc):
            return "\(String(describing: vc))"
        case .nav(let vc):
            return "\(String(describing: vc))"
        default:
            return "function"
        }
    }
    
    public static var menuButton: UIBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: nil, action: nil)
    private static func embedInNavVC(vc: UIViewController, isAddMenuBtn: Bool = true) -> UINavigationController {
        let nav: UINavigationController = UINavigationController(rootViewController: vc)
        //            nav.navigationBar.theme = theme.other.NAVIGATION_BAR
        
        nav.view.layoutIfNeeded()
        if isAddMenuBtn {
            vc.setup(menuButton: Menu.Types.menuButton)
        }
        nav.navigationBar.isTranslucent = false
        return nav
    }
}
