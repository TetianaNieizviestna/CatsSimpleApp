//
//  ImageListViewController.swift
//  CatsSimpleApp
//
//  Created by Tetiana Nieizviestna 
//

import UIKit
import Combine
import DropDown

extension PhotosListViewController {
    struct Props {
        
        let state: ScreenState; enum ScreenState {
            case initial
            case loading
            case loaded
            case failed(String)
        }
        
        let title: String
        let items: [FullPhotoCollectionViewCell.Props]

        let selectedSorting: SortingType
        
        let onRefresh: Command
        let onNextPage: Command
        
        let onChangeSorting: CommandWith<SortingType>
        let onBack: Command
        
        static let initial: Props = .init(
            state: .initial,
            title: "",
            items: [],
            selectedSorting: .random,
            onRefresh: .nop,
            onNextPage: .nop,
            onChangeSorting: .nop,
            onBack: .nop
        )
    }
}

final class PhotosListViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    var viewModel: PhotosListViewModelType!
    var props: Props = .initial
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var sortBtn: UIButton!
    
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
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
        
        backBtn
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.props.onBack.perform()
            }
            .store(in: &cancellables)

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
        
        titleLabel.text = props.title
        switch props.state {
        case .initial:
            activityIndicator.stopAnimating()
            collectionView.reloadData()
        case .loading:
            activityIndicator.startAnimating()
        case .loaded:
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            sortBtn.setTitle("Sort: \(props.selectedSorting.title)", for: .normal)
            collectionView.reloadData()
        case .failed(let error):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            showAlert(title: "Error", message: error)
        }
    }
    
    private func setupUI() {
        activityIndicator.hidesWhenStopped = true
        setupTableView()
        sortBtn.setCornersRadius(3)
    }

    private func setupTableView() {
        collectionView.setDataSource(self, delegate: self)
        collectionView.registerCells([FullPhotoCollectionViewCell.identifier])

        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
        
    @objc
    private func refresh(_ sender: AnyObject) {
        props.onRefresh.perform()
    }

    deinit {
        propsSubscriber?.cancel()
    }
}

extension PhotosListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        props.items[indexPath.row].didSelect.perform()
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

extension PhotosListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return props.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FullPhotoCollectionViewCell = collectionView.dequeCell(for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.render(props.items[indexPath.item])
        return cell
    }
}

extension PhotosListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing: CGFloat = 10
        let numberOfColumns: CGFloat = 2
        let size = (collectionView.frame.width / numberOfColumns) - spacing
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
