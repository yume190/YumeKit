//
//  CollectionBox+SingleSection.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension Box.CollectionView {
    final public class SingleSection<Cell: UICollectionViewCell & Presentable>: NSObject, SingleSectionCollectionViewPresentable, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        public var extra: (() -> Cell.ExtraData)? = nil

        public var collectionView: UICollectionView?

        public var layout: UICollectionViewFlowLayout

        public var cellType: Box.CollectionView.CellType

        public var items: [Cell.InnerData] = []

        public var select: SelectFunction?

        public init(collectionView: UICollectionView?, layout: UICollectionViewFlowLayout, cellType: Box.CollectionView.CellType) {
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
            let extra: Cell.ExtraData? = self.extra?()
            cell.present(data: data, extra: extra, indexPath: indexPath)
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
