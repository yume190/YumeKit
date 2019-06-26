//
//  CollectionBox+SingleSection.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension CollectionViewBox {
    final public class SingleSection<Cell: UICollectionViewCell & Presentable>: NSObject, SingleSectionCollectionViewPresentable, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//        public lazy var dataSource: UICollectionViewDataSource = DataSource(presentable: self)
//
//        public lazy var delegate: UICollectionViewDelegate = Delegate(presentable: self)

        public var collectionView: UICollectionView?

        public var layout: UICollectionViewFlowLayout

        public var cellType: CollectionViewCellType

        public var items: [Cell.InnerData] = []

        public var select: SelectFunction?

        public init(collectionView: UICollectionView?, layout: UICollectionViewFlowLayout, cellType: CollectionViewCellType) {
            self.collectionView = collectionView
            self.cellType = cellType
            self.layout = layout

            super.init()

            self.collectionView?.delegate = self
            self.collectionView?.dataSource = self
            self.collectionView?.collectionViewLayout = layout
        }

        // MARK: UICollectionViewDataSource
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }

        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.items.count
        }

        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: Cell.identifier,
                for: indexPath
            )
        }

        // MARK: UICollectionViewDelegate
        public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard let cell: Cell = cell as? Cell else { return }
            let data: Cell.InnerData = self[indexPath]
            cell.present(data: data, indexPath: indexPath)
        }

        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            let data: Cell.InnerData = self[indexPath]
            self.select?(collectionView, indexPath, data)
        }

        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch self.cellType {
            case .static(let size):
                return size
            case let .dynamic(count, height):
                let width: CGFloat = collectionView.bounds.size.width
                let contentWidth: Int = Int(width - self.layout.sectionInset.left - self.layout.sectionInset.right)
                let fakeContentWidth: Int = contentWidth + Int(self.layout.minimumLineSpacing)
                let fakeCellWidth: Int = fakeContentWidth / count
                let cellWidth: Int = fakeCellWidth - Int(self.layout.minimumLineSpacing)
                return CGSize(width: CGFloat(cellWidth), height: height)
            }
        }
    }
}

//extension CollectionViewBox.SingleSection {
//    private final class DataSource<Presentable: SingleSectionCollectionViewPresentable>: NSObject, UICollectionViewDataSource {
//
//        var presentable: Presentable
//        init(presentable: Presentable) {
//            self.presentable = presentable
//        }
//
//        func numberOfSections(in collectionView: UICollectionView) -> Int {
//            return 1
//        }
//
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//             return self.presentable.items.count
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            return collectionView.dequeueReusableCell(
//                withReuseIdentifier: Presentable.Cell.identifier,
//                for: indexPath
//            )
//        }
//    }
//}
//
//extension CollectionViewBox.SingleSection {
//    private final class Delegate<Presentable: SingleSectionCollectionViewPresentable>: NSObject, UICollectionViewDelegate {
//
//        var presentable: Presentable
//        init(presentable: Presentable) {
//            self.presentable = presentable
//        }
//
//        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            guard let cell = cell as? Presentable.Cell else { return }
//            let data = self.presentable[indexPath]
//            cell.present(data: data)
//        }
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            collectionView.deselectItem(at: indexPath, animated: true)
//            let data = self.presentable[indexPath]
////            self.presentable.select?(collectionView, indexPath, data)
//        }
//    }
//}
