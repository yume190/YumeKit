//
//  CollectionViewPresentable.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol CollectionViewPresentable: class {
    associatedtype Cell: UICollectionViewCell & Presentable
    var collectionView: UICollectionView? { get set }
    var layout: UICollectionViewFlowLayout { get }
    var cellType: CollectionViewCellType { get }

    static func registerNibTo(collectionView: UICollectionView?)
    static func registerClassTo(collectionView: UICollectionView?)

    func registerNibTo(collectionView: UICollectionView?)
    func registerClassTo(collectionView: UICollectionView?)

    typealias SelectFunction = (UICollectionView, IndexPath, Cell.InnerData) -> Void
    var select: SelectFunction? { get set }

    init(collectionView: UICollectionView?, layout: UICollectionViewFlowLayout, cellType: CollectionViewCellType)
}

extension CollectionViewPresentable {
    public static func registerNibTo(collectionView: UICollectionView?) {
        Cell.registerNibTo(collectionView: collectionView)
    }

    public static func registerClassTo(collectionView: UICollectionView?) {
        Cell.registerClassTo(collectionView: collectionView)
    }

    public func registerNibTo(collectionView: UICollectionView?) {
        Self.registerNibTo(collectionView: collectionView)
    }

    public func registerClassTo(collectionView: UICollectionView?) {
        Self.registerClassTo(collectionView: collectionView)
    }
}
