//
//  LinkTableViewCell.swift
//  CatsSimpleApp
//
//  Created by Тетяна Нєізвєстна on 09.10.2022.
//

import UIKit
extension LinkTableViewCell {
    func setupUI() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        photoImageView?.backgroundColor = .clear
        photoImageView?.setCornersRadius(7)
    }
}

class LinkTableViewCell: UITableViewCell {
    struct Props {
        let linkType: LinkType
        let didSelect: Command
        
        static let initial: Props = .init(linkType: .none, didSelect: .nop)
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
        photoImageView.image = props.linkType.image
    }
}

enum LinkType {
    case wikipedia
    case cfa
    case vetstreet
    case vcaHospitals
    case none
    
    var image: UIImage? {
        switch self {
        case .none: return UIImage()
        case .wikipedia: return UIImage(named: "wikipedia_logo")
        case .cfa: return UIImage(named: "cfa_logo")
        case .vetstreet: return UIImage(named: "vetstreet_logo")
        case .vcaHospitals: return UIImage(named: "vcaHospitals_logo")
        }
    }
}
