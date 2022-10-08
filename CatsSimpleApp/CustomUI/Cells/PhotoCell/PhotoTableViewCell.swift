//
//  PhotoTableViewCell.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import UIKit
import Combine

extension PhotoTableViewCell.Props: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(photo.id)
    }
    
    public static func == (lhs: PhotoTableViewCell.Props, rhs: PhotoTableViewCell.Props) -> Bool {
        return lhs.photo.id == rhs.photo.id
    }
}

final class PhotoTableViewCell: UITableViewCell {
    struct Props {
        let photo: Photo
        
        let onSelect: Command
        
        static let initial: Props = .init(
            photo: .initial,
            onSelect: .nop
        )
    }

    @IBOutlet private var bgView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var loadedImageView: UIImageView!
    @IBOutlet private var imageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private var successBgView: UIView!
    @IBOutlet private var successLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadedImageView.image = nil
        descriptionLabel.text = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setupUI() {
        loadedImageView.setCornersRadius(6)
        bgView.setCornersRadius(6)
        successBgView.setCornersRadius(6)
    }
    
    func render(_ props: Props) {
        titleLabel.text = ""//props.photo.breeds.name
        descriptionLabel.text = ""//props.photo.photoDescription
        dateLabel.text = ""//props.photo.updatedAt

        loadedImageView.setImage(with: props.photo.url)
    }
}
