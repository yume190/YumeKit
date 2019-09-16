//
//  Drawerable+SideMenu.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

#if canImport(SideMenuSwift)
import SideMenuSwift
#elseif canImport(SideMenu)
import SideMenu
#endif

#if canImport(SideMenuSwift) || canImport(SideMenu)
extension SideMenuController: Drawerable {
    var menu: YumeMenu? {
        return self.left as? MenuViewController
    }
    
    var center: UIViewController? {
        get {
            return self.contentViewController
        }
        set {
            self.contentViewController = newValue
        }
    }
    
    var left: UIViewController? {
        get {
            return self.menuViewController
        }
        set {
            self.menuViewController = newValue
        }
    }
    
    var right: UIViewController? {
        get {
            return nil
        }
        set {
            return
        }
    }
    
    func enable(way: DrawerWay) {
        SideMenuController.preferences.basic.enablePanGesture = true
    }
    
    func disable(way: DrawerWay) {
        SideMenuController.preferences.basic.enablePanGesture = false
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
        //        self.openSide(.left)
        self.revealMenu(animated: true, completion: nil)
    }
    
    func closeLeft() {
        //        self.closeSide()
        self.hideMenu(animated: true, completion: nil)
    }
    
    func openRight() {
        //        self.openSide(.right)
    }
    
    func closeRight() {
        //        self.closeSide()
    }
    
    var isOpen: Bool {
        return true
    }
}

extension SideMenuController {
    static var `default`: SideMenuController {
        let menu: MenuVC = MenuVC()
        let drawer: SideMenuController = SideMenuController(
            contentViewController: MenuViewController.mainVC,
            menuViewController: menu
        )
        
        menu.drawer = drawer
        
        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.position = .under
        SideMenuController.preferences.basic.direction = .left
        
        menu.view.frame = CGRect(x: 0, y: 0, width: 240, height: UIScreen.main.bounds.size.height)
        menu.view.layoutIfNeeded()
        
        return drawer
    }
}
#endif
