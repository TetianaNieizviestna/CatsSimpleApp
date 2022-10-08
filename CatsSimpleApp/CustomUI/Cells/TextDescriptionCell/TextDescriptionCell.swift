//
//  TextDescriptionCell.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna
//

import UIKit

extension TextDescriptionCell {
    func setupUI() {

    }
}

final class TextDescriptionCell: UITableViewCell {
    struct Props {
        let text: String
        let didSelect: Command
        
        static let initial: Props = .init(text: "", didSelect: .nop)

    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
    }
}
