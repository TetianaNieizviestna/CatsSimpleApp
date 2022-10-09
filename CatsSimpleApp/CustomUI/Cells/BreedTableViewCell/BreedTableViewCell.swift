//
//  BreedTableViewCell.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit
import Combine

extension BreedTableViewCell.Props: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(breed.id)
    }
    
    public static func == (lhs: BreedTableViewCell.Props, rhs: BreedTableViewCell.Props) -> Bool {
        return lhs.breed.id == rhs.breed.id
    }
}

final class BreedTableViewCell: UITableViewCell {
    struct Props {
        let breed: Breed
        
        let onSelect: Command
        
        static let initial: Props = .init(
            breed: .initial,
            onSelect: .nop
        )
    }

    @IBOutlet private var bgView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var altNamesLabel: UILabel!
    @IBOutlet private var loadedImageView: UIImageView!
    @IBOutlet private var imageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private var successBgView: UIView!
    @IBOutlet private var originLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadedImageView.image = nil
        descriptionLabel.text = nil
        titleLabel.text = nil
        altNamesLabel.text = nil
    }
    
    private func setupUI() {
        loadedImageView.setCornersRadius(6)
        bgView.setCornersRadius(6)
        successBgView.setCornersRadius(6)
    }
    
    func render(_ props: Props) {
        titleLabel.text = props.breed.name
        descriptionLabel.text = props.breed.breedDescription
        altNamesLabel.text = props.breed.altNames
        originLabel.text = "\(props.breed.getCountryFlagSymbol()) \(props.breed.origin)"
        loadedImageView.setImage(with: props.breed.image?.url)
    }
}
