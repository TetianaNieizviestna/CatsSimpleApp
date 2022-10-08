//
//  ImageListViewController.swift
//  RocketsSchedule
//
//  Created by Tetiana Nieizviestna 
//

import UIKit
import Combine
import DropDown

class PhotosTableViewDiffableDataSource: UITableViewDiffableDataSource<String?, PhotoTableViewCell.Props> {}

extension PhotosListViewController {
    struct Props {
        
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }
        
        let items: [PhotoTableViewCell.Props]

        let selectedSorting: SortingType
        
        let onRefresh: Command
        let onSearch: CommandWith<String>
        let onChangeSorting: CommandWith<SortingType>
        
        static let initial: Props = .init(
            state: .initial,
            items: [],
            selectedSorting: .random,
            onRefresh: .nop,
            onSearch: .nop,
            onChangeSorting: .nop
        )
    }
}

final class PhotosListViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    var viewModel: PhotosListViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var searchBar: UISearchBar!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var sortBtn: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var refreshControl = UIRefreshControl()
    private var propsSubscriber: AnyCancellable?
    
    private let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        propsSubscriber = viewModel.stateSubscriber
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newProps in
                self?.render(newProps)
            })
        
        sortBtn
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.showSortingDropDown()
            }
            .store(in: &cancellables)
    }
    
    private func showSortingDropDown() {
        let sortingItems = SortingType.all
        self.dropDown.dataSource = sortingItems.map { $0.title }
        self.dropDown.anchorView = self.sortBtn
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.sortBtn.frame.size.height)
        self.dropDown.show()
        self.dropDown.selectionAction = { [weak self] (index: Int, title: String) in
            self?.props.onChangeSorting.perform(with: sortingItems[index])
        }
    }
    
    private func render(_ props: Props) {
        self.props = props
        
        tableView.reloadData()

        switch props.state {
        case .initial:
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        case .loaded:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            sortBtn.setTitle("Sort: \(props.selectedSorting.title)", for: .normal)

        case .failed(let error):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showAlert(title: "Error", message: error)
        }

    }
    
    private func setupUI() {
        activityIndicator.hidesWhenStopped = true
        searchBar.delegate = self
        setupTableView()
        sortBtn.setCornersRadius(3)
    }

    private func setupTableView() {
        tableView.setDataSource(self, delegate: self)
        tableView.register([PhotoTableViewCell.identifier])
        tableView.tableFooterView = UIView(frame: .zero)

        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
        
    @objc
    private func refresh(_ sender: AnyObject) {
        props.onRefresh.perform()
    }

    deinit {
        propsSubscriber?.cancel()
    }
}

extension PhotosListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        props.items[indexPath.row].onSelect.perform()
    }
}

extension PhotosListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier) as? PhotoTableViewCell else { return UITableViewCell() }
        cell.render(props.items[indexPath.row])
        return cell
    }
}

extension PhotosListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        props.onSearch.perform(with: searchText)
    }
}
