//
//  UICollectionView.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import UIKit

extension UICollectionViewCell: NibLoadableView {}

extension UICollectionViewCell {
    static var identifier: String { return nibName }
}


extension UICollectionView {
    func registerCells(_ cells: [String]) {
        cells.forEach {
            self.register(UINib(nibName: $0, bundle: nil), forCellWithReuseIdentifier: $0)
        }
    }
    
    func registerNib<T: UICollectionViewCell>(_ cellType: T.Type) {
        self.register(UINib(nibName: cellType.nibName, bundle: nil), forCellWithReuseIdentifier: cellType.identifier)
    }
    
    func dequeCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T else {
            return nil
        }
        
        return cell
    }
}




