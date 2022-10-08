//
//  ImageTextCell.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import UIKit

extension ImageTextCell {
    func setupUI() {
        photoImageView?.roundedView()
    }
}

final class ImageTextCell: UITableViewCell {
    struct Props {
        let imageUrl: String
        let text: String
        let didSelect: Command
        
        static let initial: Props = .init(imageUrl: "", text: "", didSelect: .nop)
    }
    
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var descriptionLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView?.image = nil
        descriptionLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func render(_ props: Props) {
        photoImageView?.setImage(with: props.imageUrl)
        descriptionLabel.text = props.text
    }
}
