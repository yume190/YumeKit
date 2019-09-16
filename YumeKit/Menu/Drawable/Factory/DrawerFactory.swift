//
//  DrawerFactory.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

#if canImport(MMDrawerController)
import MMDrawerController
#endif
#if canImport(KWDrawerController)
import KWDrawerController
#endif
#if canImport(SideMenuSwift)
import SideMenuSwift
#endif
#if canImport(SideMenuSwift) || canImport(SideMenu)
import SideMenu
#endif

public enum DrawerFactory: DrawerFactoryable {
    #if canImport(MMDrawerController)
    case mm
    #endif
    #if canImport(KWDrawerController)
    case kw
    #endif
    #if canImport(SideMenuSwift) || canImport(SideMenu)
    case sideMenu
    #endif
    
    public var instance: Drawer.Instance {
        switch self {
            #if canImport(MMDrawerController)
        case .mm: return MMDrawerController.default
            #endif
            #if canImport(KWDrawerController)
        case .kw: return DrawerController.default
            #endif
            #if canImport(SideMenuSwift) || canImport(SideMenu)
        case .sideMenu: return SideMenuController.default
            #endif
        }
    }
}
