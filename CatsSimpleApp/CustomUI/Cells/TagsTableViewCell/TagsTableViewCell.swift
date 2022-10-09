//
//  TagsTableViewCell.swift
//  CatsSimpleApp
//
//  Created by Тетяна Нєізвєстна on 09.10.2022.
//

import UIKit
import Combine

extension TagsTableViewCell.Props: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(country)
    }
    
    public static func == (lhs: TagsTableViewCell.Props, rhs: TagsTableViewCell.Props) -> Bool {
        return lhs.country == rhs.country &&
        lhs.isHypoallergenic == rhs.isHypoallergenic
    }
}
class TagsTableViewCell: UITableViewCell {
    struct Props {
        let country: String
        let isHypoallergenic: Bool
        
        let onSelect: Command
        
        static let initial: Props = .init(
            country: "",
            isHypoallergenic: false,
            onSelect: .nop
        )
    }
        
    @IBOutlet private var originBgView: UIView!
    @IBOutlet private var originLabel: UILabel!
    
    @IBOutlet private var hypoallergenicBgView: UIView!
    @IBOutlet private var hypoallergenicLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func setupUI() {
        originBgView.setCornersRadius(6)
        hypoallergenicBgView.setCornersRadius(6)
    }
    
    func render(_ props: Props) {
        originLabel.text = props.country
        hypoallergenicBgView.isHidden = !props.isHypoallergenic
    }
}
