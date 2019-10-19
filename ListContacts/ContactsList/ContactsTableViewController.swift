//
//  ContactsTableViewController.swift
//  ListContacts
//
//  Created by Sergey on 12.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import RealmSwift

class ContactsTableViewController: UITableViewController {

    var viewModel: ContactsTableViewViewModelType?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private let refreshController = UIRefreshControl()
    private var activityIndicator = UIActivityIndicatorView()
    private var isFirstStart = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel = ViewModel()
        setupUISearchController()
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        setupActivityIndicator()
        fetchData()
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        
        viewModel?.loadContactsFromDB { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    print(error)
                    UIApplication.shared.showErrorLabel(withText: "Нет подключения к сети")
                case .success( _):
                    self?.tableView.reloadData()
                    
                    if let isFirstStart = self?.isFirstStart, isFirstStart {
                        self?.isFirstStart = false
                        
                        Timer.scheduledTimer(timeInterval: 60, target: self!, selector: #selector(self?.actionTimer), userInfo: nil, repeats: false)
                    }
                }
                
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc private func actionTimer() {
        print("action start")
        activityIndicator.startAnimating()
        refreshData(0)
    }
    
    @objc private func refreshData(_ sender: Any) {
        viewModel?.fetchContacts(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .error(let error):
                    print(error)
                    UIApplication.shared.showErrorLabel(withText: "Нет подключения к сети")
                case .success( _):
                    self?.tableView.reloadData()
                }
                
                if (self?.activityIndicator.isAnimating)! {
                    self?.activityIndicator.stopAnimating()
                }
                
                self?.refreshController.endRefreshing()
            }
        })
    }
    
    private func setupUISearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по имени и телефону"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        let screenSize = UIScreen.main.bounds
        activityIndicator.center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContactId", for: indexPath) as? ContactsTableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(indexPath: indexPath)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailTableViewController else { return }
        detailVC.viewModel = viewModel.viewModelForSelectedRow()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension ContactsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard self.isFiltering else {
            fetchData()
            return
        }
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@ OR phone CONTAINS[c] %@", searchText,  searchText)
        
        viewModel?.searchContacts(predicate: predicate)
        tableView.reloadData()
    }
}

