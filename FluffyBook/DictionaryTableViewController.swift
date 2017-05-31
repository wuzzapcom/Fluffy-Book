//
//  DictionaryTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class DictionaryTableViewController: UITableViewController, UISearchBarDelegate {
    
    fileprivate var bookReaderModel : BookReaderModel?
    fileprivate var dictionaryTableViewModel : DictionaryTableViewModel?
    fileprivate var searchController : UISearchController = UISearchController(searchResultsController: nil)
    fileprivate var webDictionaryModel : WebDictionaryModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dictionaryTableViewModel = DictionaryTableViewModel()
        webDictionaryModel = WebDictionaryModel()
        
        refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(notification:)),
                                               name: Notification.Name(Constants.NOTIFICATION_FOR_DICTIONARY_TABLE_VIEW),
                                               object: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        addEditButton()
        
        addSearchController()
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl){
    
        updateTable()
        refreshControl.endRefreshing()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else{
        
            return
        
        }
        
        guard dictionaryTableViewModel != nil else {
            return
        }
        
        if dictionaryTableViewModel!.searchWords(forWord: text){
        
            sendQueryToServer(word: text)
        
        }else{
            
            updateTable()
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.endEditing(true)
        searchController.isActive = false
        
        updateTable()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        updateTable()
        
    }
    

    func addEditButton() {
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTableAndChangeButton))
        
        self.navigationItem.rightBarButtonItem = editButton
        
    }
    
    func editTableAndChangeButton(){
        
        setEditing(true, animated: true)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditingAndChangeButton))
        
        self.navigationItem.rightBarButtonItem = cancelButton
        
    }
    
    func cancelEditingAndChangeButton() {
        
        setEditing(false, animated: true)
        
        addEditButton()
        
    }
    
    func sendQueryToServer(word : String) {
        
        do{
            
            try webDictionaryModel?.asyncQuery(forWord: word)
            
        } catch let exc as WebDictionaryException {
            
            print(exc.localizedDescription)
            
        } catch {
            
            print("non catched error")
            
        }
        
    }
    
    func addSearchController(){
        
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.definesPresentationContext = true
        
        searchController.searchBar.barTintColor = UIColor.white
        
        self.tableView!.tableHeaderView = searchController.searchBar
        
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.bounds.height)
        
        searchController.searchBar.delegate = self
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return dictionaryTableViewModel!.getNumberOfSections()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return dictionaryTableViewModel!.getNumberOfSearchedWords()
            
        }
        
        return dictionaryTableViewModel!.getNumberOfRows(section: section)
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordIdentifier", for: indexPath)
            as? DictionaryTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            let word = dictionaryTableViewModel!.getSearchedWord(indexPath: indexPath)
            
            cell?.wordLabel?.text = word.word
            
            cell?.translationLabel?.text = word.translation
            
            return cell!
            
        }

        cell?.wordLabel?.text = dictionaryTableViewModel?.getWord(indexPath : indexPath)
        
        cell?.translationLabel?.text = dictionaryTableViewModel?.getTranslation(indexPath : indexPath)
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            dictionaryTableViewModel?.deleteElement(atRow: indexPath)
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func handleNotification(notification : Notification){
        
        print("table notification")
        
        if searchController.isActive {
            
            searchBarSearchButtonClicked(searchController.searchBar)
            
        }
        
        updateTable()
        
    }
    
    func updateTable(){
        
        print("update table")
        
        dictionaryTableViewModel?.loadWords()
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(Constants.NOTIFICATION_FOR_DICTIONARY_TABLE_VIEW),
                                                  object: nil)
        
    }
    
}
