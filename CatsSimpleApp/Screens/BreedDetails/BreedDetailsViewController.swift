//
//  BreedDetailsViewController.swift
//  CatsSimpleApp
//
//  Created by Тетяна Нєізвєстна on 09.10.2022.
//

import UIKit
import Combine

extension BreedDetailsViewController {
    struct Props {
        let title: String
        let header: PhotoDetailsHeaderView.Props

        let items: [Item]; enum Item {
            case text(TextDescriptionCell.Props)
//            case tags(TagsTableViewCell.Props)
//            case rate(RateTableViewCell.Props)
//            case link(LinkTableViewCell.Props)
        }
        
        let onBack: Command
        let onPhoto: CommandWith<Photo>
        let onUrl: CommandWith<String>

        static let initial: Props = .init(
            title: "",
            header: .initial,
            items: [],
            onBack: .nop,
            onPhoto: .nop,
            onUrl: .nop
        )
    }
}

final class BreedDetailsViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    private let headerHeight: CGFloat = 196
//    private var propsSubscriber: AnyCancellable?

    var viewModel: BreedDetailsViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
        
    private let headerView = PhotoDetailsHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
//        propsSubscriber = viewModel.stateSubscriber
//            .receive(on: DispatchQueue.main)
//            .sink(receiveValue: { [weak self] newProps in
//                self?.render(newProps)
//            })
        render(viewModel.getProps())
    }
    
    private func render(_ props: Props) {
        self.props = props
        
        updateHeaderFrame()
        
        titleLabel.text = props.title
        tableView.reloadData()
        headerView.render(props.header)
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.setDataSource(self, delegate: self)
        tableView.register([
            TextDescriptionCell.identifier,
//            TagsTableViewCell.identifier,
//            RateTableViewCell.identifier,
        ])
        tableView.tableFooterView = UIView(frame: .zero)
        
        updateHeaderFrame()
        tableView?.tableHeaderView = headerView
    }
    
    private func updateHeaderFrame() {
        let size = tableView?.frame.size.width ?? 0
        headerView.frame = .init(x: .zero, y: .zero, width: size, height: size)
    }
    
    @IBAction private func backBtnAction(_ sender: UIButton) {
        props.onBack.perform()
    }
    
    deinit {
//        propsSubscriber?.cancel()
    }
}

extension BreedDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch props.items[indexPath.row] {
        case .text:
            break
//        case .tags:
//            break
//        case .rate:
//            break
//        case .link(let cellProps):
//            props.onUrl.perform(with: cellProps)
        }
    }
}

extension BreedDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch props.items[indexPath.row] {
        case .text(let cellProps):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextDescriptionCell.identifier) as? TextDescriptionCell else { return UITableViewCell() }
            cell.render(cellProps)
            return cell
//        case .tags(let cellProps):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: TagsTableViewCell.identifier) as? TagsTableViewCell else { return UITableViewCell() }
//            cell.render(cellProps)
//            return cell
//        case .rate(let cellProps):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: RateTableViewCell.identifier) as? RateTableViewCell else { return UITableViewCell() }
//            cell.render(cellProps)
//            return cell
        }
    }
}
