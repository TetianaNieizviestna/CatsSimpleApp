//
//  PhotoDetailsHeaderView.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import UIKit

extension PhotoDetailsHeaderView {
    func setupUI() {
        collectionView?.backgroundColor = .clear
        pageControl?.currentPageIndicatorTintColor = .darkGray
        pageControl?.pageIndicatorTintColor = .lightGray
    }
}

final class PhotoDetailsHeaderView: UIView {
    struct Props {
        let items: [FullPhotoCollectionViewCell.Props]

        static let initial = Props(items: [])
    }
    
    private var props: Props = .initial
    
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var pageControl: UIPageControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
        self.setupUI()
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
        self.setupUI()
        self.configure()
    }
    
    private func configure() {
        collectionView?.registerCells([FullPhotoCollectionViewCell.identifier])
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }

    func render(_ props: Props) {
        self.props = props
        pageControl?.numberOfPages = props.items.count
        collectionView?.reloadData()
    }
}

extension PhotoDetailsHeaderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else {
            pageControl?.currentPage = 0
            return
        }
        pageControl?.currentPage = Int(collectionView.contentOffset.x / collectionView.bounds.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        props.items[indexPath.item].didSelect.perform()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionViewfOlo(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PhotoDetailsHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.props.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FullPhotoCollectionViewCell = collectionView.dequeCell(for: indexPath) else {
            return UICollectionViewCell()
        }
        let props = self.props.items[indexPath.item]
        cell.render(props)
        return cell
    }
}
