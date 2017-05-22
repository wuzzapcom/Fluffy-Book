//
//  ContentsTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 20.05.17.
//  Copyright © 2017 FluffyBook. All rights reserved.
//

import UIKit

class ContentsTableViewController: UITableViewController {
    
    public var currentBookModel : BookModel? //set in segue
    fileprivate var contentsTableViewModel : ContentsTableViewModel?
    public var delegate:TransferDataProtocol?
    fileprivate var settedValue : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard currentBookModel != nil else {
            print("No book model")
            return
        }
        
        var pair = currentBookModel!.getTitles()
        
        contentsTableViewModel = ContentsTableViewModel(withContent: pair.0)

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return contentsTableViewModel!.getNumberOfElements()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CONTENT_CELL_IDENTIFIER, for: indexPath) 

        cell.textLabel?.text = contentsTableViewModel!.getChapterTitle(withIndexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settedValue = indexPath.row
        
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        delegate?.setSelectedRow(number: settedValue)
        
    }
    

}
