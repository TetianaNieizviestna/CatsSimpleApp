//
//  RateTableViewCell.swift
//  CatsSimpleApp
//
//  Created by Тетяна Нєізвєстна on 09.10.2022.
//

import UIKit
extension RateTableViewCell {
    func setupUI() {

    }
}

final class RateTableViewCell: UITableViewCell {
    struct Constraints {
        struct Image {
            static let star = UIImage(systemName: "star")
            static let starFilled = UIImage(systemName: "star.fill")
        }
    }
    struct Props {
        let text: String
        let starCount: Int
        
        let didSelect: Command
        
        static let initial: Props = .init(
            text: "",
            starCount: 0,
            didSelect: .nop
        )
    }
    
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet var starsImageViews: [UIImageView]!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func render(_ props: Props) {
        descriptionLabel.text = props.text
        starsImageViews.enumerated().forEach { element in
            let isFilled = element.offset < props.starCount - 1
            element.element.image = isFilled ? Constraints.Image.starFilled : Constraints.Image.star
        }
    }
}
