//
//  FullPhotoTableViewCell.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit

extension FullPhotoTableViewCell {
    func setupUI() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        photoImageView?.backgroundColor = .clear
        photoImageView?.setCornersRadius(7)
    }
}

class FullPhotoTableViewCell: UITableViewCell {
    struct Props {
        let url: URL?
        let didSelect: Command
        
        static let initial: Props = .init(url: nil, didSelect: .nop)
    }
    
    @IBOutlet private var photoImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func render(_ props: Props) {
        photoImageView?.setImage(with: props.url)
    }
}
