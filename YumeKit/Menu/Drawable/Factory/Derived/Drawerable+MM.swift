//
//  Drawerable+MM.swift
//  MaxwinBus
//
//  Created by Yume on 2019/2/20.
//  Copyright © 2019 Yume. All rights reserved.
//

#if canImport(MMDrawerController)
import Foundation
import MMDrawerController

extension MMDrawerController: Drawerable {
    var isOpen: Bool {
        #warning("[TODO]")
        return true
    }
    
    var menu: YumeMenu? {
        return self.left as? MenuViewController
    }
    
    var center: UIViewController? {
        get {
            return self.centerViewController
        }
        set {
            self.setCenterView(newValue, withCloseAnimation: true, completion: nil)
        }
    }
    
    var left: UIViewController? {
        get {
            return self.leftDrawerViewController
        }
        set {
        }
    }
    
    var right: UIViewController? {
        get {
            return self.rightDrawerViewController
        }
        set {
        }
    }
    
    func enable(way: DrawerWay) {
        #warning("[Todo]")
    }
    
    func disable(way: DrawerWay) {
        #warning("[Todo]")
    }
    
    func open(way: DrawerWay) {
        switch way {
        case .left:
            self.openLeft()
        case .right:
            self.openRight()
        }
    }
    
    func close(way: DrawerWay) {
        switch way {
        case .left:
            self.closeLeft()
        case .right:
            self.closeRight()
        }
    }
    
    func openLeft() {
        self.open(.left, animated: true, completion: nil)
    }
    
    func closeLeft() {
        self.closeDrawer(animated: true, completion: nil)
    }
    
    func openRight() {
        self.open(.right, animated: true, completion: nil)
    }
    
    func closeRight() {
        self.closeDrawer(animated: true, completion: nil)
    }
}

extension MMDrawerController {
    static var `default`: MMDrawerController {
        let menu = MenuViewController()
        let center = MenuViewController.mainVC
        let drawer: MMDrawerController = MMDrawerController(center: center, leftDrawerViewController: menu)
        
        drawer.showsStatusBarBackgroundView = true
        
        //        drawer.statusBarViewBackgroundColor = theme.other.STATUS_BAR
        menu.drawer = drawer
        
        drawer.showsShadow = true
        drawer.maximumLeftDrawerWidth = UIScreen.main.bounds.width * 3 / 4
        drawer.openDrawerGestureModeMask = [.bezelPanningCenterView, .panningCenterView]
        drawer.closeDrawerGestureModeMask = [.bezelPanningCenterView, .panningCenterView, .panningDrawerView, .tapNavigationBar, .tapCenterView]
        
        return drawer
    }
}
#endif
