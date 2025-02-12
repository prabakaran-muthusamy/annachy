//
//  HomeViewController.swift
//  Annachy
//
//  Created by Prabakaran Muthusamy on 12/02/25.
//

import Foundation
import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isGridView: Bool = true
    
    private var viewModel = ProductViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        bindViewModel()
        setupPullToRefresh()
        viewModel.fetchProducts()
    }
    
    // MARK: - User Interactions
    
    @objc
    private func optionButtonAction(sender: UIBarButtonItem) {
        isGridView.toggle()
        sender.image = UIImage(systemName: isGridView ? "square.grid.2x2" : "list.bullet")
        collectionView.reloadData()
    }
    
    @objc
    private func refreshProducts() {
        viewModel.fetchProducts()
    }

    // MARK: - API Implementations
    
    private func bindViewModel() {
        viewModel.$searchText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Setup
    
    private func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshProducts), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Annachy"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchController
        
        let optionButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain,
                                           target: self, action: #selector(optionButtonAction(sender:)))
                
        optionButton.tintColor = UIColor.appThemeColor
        
        navigationItem.rightBarButtonItems = [optionButton]
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Products"
        definesPresentationContext = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView Delegate & DataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell",
                                                      for: indexPath) as! HomeCollectionViewCell
        let product = viewModel.filteredProducts[indexPath.item]
        cell.configure(with: product, isGridView: isGridView)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        
        if isGridView {
            return CGSize(width: (width - 45) / 2, height: 270)
        } else {
            return CGSize(width: width - 30, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return isGridView ? UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
                          : UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

// MARK: - Search Result 

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}
