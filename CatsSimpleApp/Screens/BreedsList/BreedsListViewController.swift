//
//  BreedsListViewController.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna
//

import UIKit
import Combine
import DropDown

extension BreedsListViewController {
    struct Props {
        
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }
        
        let items: [BreedTableViewCell.Props]
        
        let onRefresh: Command
        let onNextPage: Command
        let onPhotosList: Command
        
        static let initial: Props = .init(
            state: .initial,
            items: [],
            onRefresh: .nop,
            onNextPage: .nop,
            onPhotosList: .nop
        )
    }
}

final class BreedsListViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    var viewModel: BreedsListViewModelType!
    var props: Props = .initial
        
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var randomCatsBtn: UIButton!
        
    @IBOutlet private var tableView: UITableView!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var refreshControl = UIRefreshControl()
    private var propsSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        propsSubscriber = viewModel.stateSubscriber
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newProps in
                self?.render(newProps)
            })
        
        randomCatsBtn
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.props.onPhotosList.perform()
            }
            .store(in: &cancellables)
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
            tableView.reloadData()
        case .failed(let error):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showAlert(title: "Error", message: error)
        }
    }
    
    private func setupUI() {
        activityIndicator.hidesWhenStopped = true
        setupTableView()
        randomCatsBtn.setCornersRadius(3)
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
