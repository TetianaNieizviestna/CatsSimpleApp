//
//  BreedsListViewController.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit
import Combine
import DropDown

//class PhotosTableViewDiffableDataSource: UITableViewDiffableDataSource<String?, PhotoTableViewCell.Props> {}

extension BreedsListViewController {
    struct Props {
        
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }
        
        let items: [BreedTableViewCell.Props]

        let selectedSorting: SortingType
        
        let onRefresh: Command
        let onNextPage: Command
        
        let onSearch: CommandWith<String>
        let onChangeSorting: CommandWith<SortingType>
        
        static let initial: Props = .init(
            state: .initial,
            items: [],
            selectedSorting: .random,
            onRefresh: .nop,
            onNextPage: .nop,
            onSearch: .nop,
            onChangeSorting: .nop
        )
    }
}

final class BreedsListViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    var viewModel: BreedsListViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var searchBar: UISearchBar!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var sortBtn: UIButton!
        
    @IBOutlet private var tableView: UITableView!
    
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
        dropDown.dataSource = sortingItems.map { $0.title }
        dropDown.anchorView = sortBtn
        dropDown.bottomOffset = CGPoint(x: 0, y: sortBtn.frame.size.height)
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, title: String) in
            self?.props.onChangeSorting.perform(with: sortingItems[index])
        }
    }
    
    private func render(_ props: Props) {
        self.props = props
        
        switch props.state {
        case .initial:
            activityIndicator.stopAnimating()
            tableView.reloadData()
        case .loading:
            activityIndicator.startAnimating()
        case .loaded:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            sortBtn.setTitle("Sort: \(props.selectedSorting.title)", for: .normal)
            tableView.reloadData()
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
        tableView.register([BreedTableViewCell.identifier])

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

extension BreedsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        props.items[indexPath.row].onSelect.perform()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == props.items.count - 1 {
            switch props.state {
            case .loading:
                break
            default:
                props.onNextPage.perform()
            }
        }
    }
}

extension BreedsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        props.onSearch.perform(with: searchText)
    }
}

extension BreedsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellProps = props.items[indexPath.row]
        cellProps.onSelect.perform()
    }
}

extension BreedsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellProps = props.items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.identifier) as? BreedTableViewCell else { return UITableViewCell() }
        cell.render(cellProps)
        return cell
    }
}
