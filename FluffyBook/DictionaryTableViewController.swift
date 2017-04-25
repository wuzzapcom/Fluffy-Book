//
//  DictionaryTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class DictionaryTableViewController: UITableViewController, UISearchResultsUpdating {
    
    fileprivate var bookReaderModel : BookReaderModel?
    fileprivate var dictionaryTableViewModel : DictionaryTableViewModel?
    fileprivate var searchController : UISearchController = UISearchController(searchResultsController: nil)
    fileprivate var webDictionaryModel : WebDictionaryModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        dictionaryTableViewModel = bookReaderModel?.getDictionaryTableViewModel()
        webDictionaryModel = bookReaderModel?.getWebDictionaryModel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(notification:)),
                                               name: Notification.Name(Constants.NOTIFICATION_IDENTIFIER),
                                               object: nil)
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        addEditButton()
        
//        loadDefaultWordsToDB()
        
        addSearchController()
        
        sendQueryToServer(word: "fa")
        
        
    }
    
    //viewDidLoad methods
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
        
        
//        let word1 = WordPreviewModel()
//        word1.word = "Home"
//        word1.translation = "Дом"
//        dictionaryTableViewModel?.addWordPreviewToDatabase(wordPreview: word1)
//        let word2 = WordPreviewModel()
//        word2.word = "iPhone"
//        word2.translation = "Айфон"
//        dictionaryTableViewModel?.addWordPreviewToDatabase(wordPreview: word2)
//        let word3 = WordPreviewModel()
//        word3.word = "Mother"
//        word3.translation = "Мама"
//        dictionaryTableViewModel?.addWordPreviewToDatabase(wordPreview: word3)
    }
    
    func addSearchController(){
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.definesPresentationContext = true
        
        searchController.searchBar.barTintColor = UIColor.white
        
        self.tableView!.tableHeaderView = searchController.searchBar
        
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.bounds.height)
        
    }
    
    //UISearchResultUpdating method
    func updateSearchResults(for searchController: UISearchController) {
        
        dictionaryTableViewModel?.searchWords(forWord: searchController.searchBar.text!)
        
        self.tableView.reloadData()
        
    }
    
    //tableView methods
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
        
        dictionaryTableViewModel?.loadWords()
        
        self.tableView.reloadData()
        
    }
    
}
