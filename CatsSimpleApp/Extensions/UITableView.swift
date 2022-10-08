//
//  UITableView.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import UIKit

extension UITableViewCell: NibLoadableView {}

extension UITableViewCell {
    static var identifier: String { return nibName }
}

extension UITableView {
    func register(_ cells: [String]) {
        cells.forEach {
            register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0)
        }
    }
    
    func registerNib<T: UITableViewCell>(cellType: T.Type) {
        self.register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T else {
            return nil
        }
        
        return cell
    }
    
    func setDataSource(_ dataSource: UITableViewDataSource, delegate: UITableViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
}
