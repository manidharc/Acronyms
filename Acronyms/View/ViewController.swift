//
//  ViewController.swift
//  Acronyms
//
//  Created by Manidhar Gupta Chittanuri on 1/6/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = AcronymsViewModel()
    var lfs: [LfsObject] = []
    let titleVal = "Acronyms"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleVal
        let barButton = UIBarButtonItem(title: "Reset",
                                        style: .plain,
                                        target: self,
                                        action: #selector(resetSearch))
        self.navigationItem.setRightBarButtonItems([barButton], animated: false)
    
    }
    @objc func resetSearch() {
        self.navigationItem.title = titleVal
        searchBar.text = ""
        lfs.removeAll()
        self.tableView.reloadData()
    }
}
//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSearchOperation()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func performSearchOperation() {
        
        if let searchText = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces), searchText.count > 0 {
            
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            tableView.isHidden = true
            
            viewModel.getFullForms(searchKey: searchText) { [weak self] result in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    switch result {
                    case .success(let feed) :
                        self?.handleSuccess(with: feed,
                                            searchText: searchText)
                    case .failure(let error) :
                        self?.navigationItem.title = self?.titleVal
                        AlertVC.sharedInstance.presentAlert(on: self,
                                                            with: self?.titleVal ?? "",
                                                            message: error.localizedDescription,
                                                            buttonTitle: "OK")
                    }
                }
            }
        } else {
            self.navigationItem.title = self.titleVal
            tableView.isHidden = true
            AlertVC.sharedInstance.presentAlert(on: self,
                                                with: titleVal,
                                                message: "Please provide acronym to get the full forms",
                                                buttonTitle: "OK")
        }
    }
    
    func handleSuccess(with feed: [AcronymsSFFeed], searchText: String) {
        if let feedObjct = feed.first {
            self.navigationItem.title = "\(self.titleVal) - \(feedObjct.sf)"
            self.lfs = feedObjct.lfs
            if self.lfs.count == 0 {
                self.navigationItem.title = self.titleVal
                AlertVC.sharedInstance.presentAlert(on: self,
                                                    with: self.titleVal,
                                                    message: "No full forms found with \(searchText). Please provide different one.",
                                                    buttonTitle: "OK")
            } else {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        } else {
            self.navigationItem.title = self.titleVal
            AlertVC.sharedInstance.presentAlert(on: self,
                                                with: self.titleVal,
                                                message: "No full forms found with \(searchText). Please provide different one.",
                                                buttonTitle: "OK")
        }
    }
    
}

//MARK: - UITableViewDataSource and Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lfs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFSCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.lfs[indexPath.row].lf
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
