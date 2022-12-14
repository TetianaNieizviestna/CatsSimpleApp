//
//  EditPhotoViewController.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit
import Combine

extension PhotoDetailsViewController {
    struct Props {
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }

        let title: String
        let header: PhotoDetailsHeaderView.Props
        let details: String
        
        let items: [Item]

        enum Item {
            case imageText(ImageTextCell.Props)
            case text(TextDescriptionCell.Props)
            case breed(BreedTableViewCell.Props)
        }
        
        let onBack: Command
        let onRefresh: Command

        static let initial: Props = .init(
            state: .initial,
            title: "",
            header: .initial,
            details: "",
            items: [],
            onBack: .nop,
            onRefresh: .nop
        )
    }
}

final class PhotoDetailsViewController: UIViewController {
    private let headerHeight: CGFloat = 196
    private var propsSubscriber: AnyCancellable?

    var viewModel: PhotoDetailsViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private var refreshControl = UIRefreshControl()
    
    private let headerView = PhotoDetailsHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        propsSubscriber = viewModel.stateSubscriber
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newProps in
                self?.render(newProps)
            })
    }
    
    private func render(_ props: Props) {
        self.props = props
        
        updateHeaderFrame()
        
        titleLabel.text = props.title
        tableView.reloadData()
        headerView.render(props.header)

        switch props.state {
        case .initial:
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        case .loaded:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
        case .failed(let error):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showAlert(title: "Error", message: error)
        }
    }
    
    private func setupUI() {
        activityIndicator.hidesWhenStopped = true
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.setDataSource(self, delegate: self)
        tableView.register([
            ImageTextCell.identifier,
            TextDescriptionCell.identifier,
            BreedTableViewCell.identifier
        ])
        tableView.tableFooterView = UIView(frame: .zero)

        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        updateHeaderFrame()
        tableView?.tableHeaderView = headerView

    }
    
    private func updateHeaderFrame() {
        let size = tableView?.frame.size.width ?? 0
        headerView.frame = .init(x: .zero, y: .zero, width: size, height: size)
    }
    
    @objc
    private func refresh(_ sender: AnyObject) {
        props.onRefresh.perform()
    }
    
    @IBAction private func backBtnAction(_ sender: UIButton) {
        props.onBack.perform()
    }
    
    deinit {
        propsSubscriber?.cancel()
    }
}

extension PhotoDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension PhotoDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch props.items[indexPath.row] {
        case .imageText(let cellProps):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTextCell.identifier) as? ImageTextCell else { return UITableViewCell() }
            cell.render(cellProps)
            return cell
        case .text(let cellProps):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextDescriptionCell.identifier) as? TextDescriptionCell else { return UITableViewCell() }
            cell.render(cellProps)
            return cell
        case .breed(let cellProps):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.identifier) as? BreedTableViewCell else { return UITableViewCell() }
            cell.render(cellProps)
            return cell

        }
    }
}
