//
//  UITableViewCellExtension.swift
//  BusApp
//
//  Created by Yume on 2016/12/28.
//  Copyright © 2016年 Yume. All rights reserved.
//

import UIKit

public protocol ReusableExtension:class {}
extension UITableViewCell:ReusableExtension {}
//extension UICollectionViewCell:ReusableExtension {}
extension UICollectionReusableView:ReusableExtension {}
extension UITableViewHeaderFooterView:ReusableExtension {}

extension ReusableExtension where Self:UITableViewCell {
    
    // MARK: 基本屬性
    public static var identifier:String { get { return String(describing: self) }}
    public static var bundle:Bundle { get { return Bundle(for: Self.classForCoder()) }}
    public static var nib:UINib { get { return UINib(nibName: identifier, bundle: bundle) }}
    
    // MARK: 註冊
    public static func registerNibTo(tableView:UITableView?) {
        tableView?.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public static func registerClassTo(tableView:UITableView?) {
        tableView?.register(self, forCellReuseIdentifier: identifier)
    }
}

extension ReusableExtension where Self:UICollectionViewCell {
    // MARK: 基本屬性
    public static var identifier:String { get { return String(describing: self) }}
    public static var bundle:Bundle { get { return Bundle(for: Self.classForCoder()) }}
    public static var nib:UINib { get { return UINib(nibName: identifier, bundle: bundle) }}
    
    // MARK: 註冊
    public static func registerNibTo(collectionView:UICollectionView?) {
        collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public static func registerClassTo(collectionView:UICollectionView?) {
        collectionView?.register(self, forCellWithReuseIdentifier: identifier)
    }
}

public enum UICollectionReusableViewType {
    case header // = UICollectionElementKindSectionHeader
    case footer // = UICollectionElementKindSectionFooter
    public var kind:String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
        case .footer:
            return UICollectionElementKindSectionFooter
        }
    }
}
extension ReusableExtension where Self:UICollectionReusableView {
    // MARK: 基本屬性
    public static var identifier:String { get { return String(describing: self) }}
    public static var bundle:Bundle { get { return Bundle(for: Self.classForCoder()) }}
    public static var nib:UINib { get { return UINib(nibName: identifier, bundle: bundle) }}
    
    // MARK: 註冊
    public static func registerNibTo(collectionView:UICollectionView?,type:UICollectionReusableViewType) {
        collectionView?.register(nib, forSupplementaryViewOfKind: type.kind , withReuseIdentifier: identifier)
    }
    public static func registerHeaderNibTo(collectionView:UICollectionView?) {
        registerNibTo(collectionView: collectionView, type: .header)
    }
    public static func registerFooterNibTo(collectionView:UICollectionView?) {
        registerNibTo(collectionView: collectionView, type: .footer)
    }
    
    public static func registerClassTo(collectionView:UICollectionView?,type:UICollectionReusableViewType) {
        collectionView?.register(self, forSupplementaryViewOfKind: type.kind, withReuseIdentifier: identifier)
    }
    public static func registerHeaderClassTo(collectionView:UICollectionView?) {
        registerClassTo(collectionView: collectionView,type: .header)
    }
    public static func registerFooterClassTo(collectionView:UICollectionView?) {
        registerClassTo(collectionView: collectionView,type: .footer)
    }
}

extension ReusableExtension where Self:UITableViewHeaderFooterView {
    
    // MARK: 基本屬性
    public static var identifier:String { get { return String(describing: self) }}
    public static var bundle:Bundle { get { return Bundle(for: Self.classForCoder()) }}
    public static var nib:UINib { get { return UINib(nibName: identifier, bundle: bundle) }}
    
    // MARK: 註冊
    public static func registerNibTo(tableView:UITableView?) {
        tableView?.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public static func registerClassTo(tableView:UITableView?) {
        tableView?.register(self, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
