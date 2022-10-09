//
//  PhotoDetailsHeaderView.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit

extension PhotoDetailsHeaderView {
    func setupUI() {
        photoImageView?.backgroundColor = .clear
        photoImageView?.setCornersRadius(7)
    }
}

final class PhotoDetailsHeaderView: UIView {
    struct Props {
        let url: URL?
        let didSelect: Command
        
        static let initial: Props = .init(url: nil, didSelect: .nop)
    }
    
    private var props: Props = .initial
    
    @IBOutlet private var photoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibSetup()
        self.setupUI()
    }


    func render(_ props: Props) {
        self.props = props
        photoImageView?.setImage(with: props.url)
    }
}
