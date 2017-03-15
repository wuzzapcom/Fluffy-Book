//
//  DictionaryTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class DictionaryTableViewController: UITableViewController {
    
    var bookReaderModel : BookReaderModel?
    var dictionaryTableViewModel : DictionaryTableViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        dictionaryTableViewModel = bookReaderModel?.getDictionaryTableViewModel()
        
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return dictionaryTableViewModel!.getNumberOfSections()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dictionaryTableViewModel!.getNumberOfRows(section: section)
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordIdentifier", for: indexPath)
            as? DictionaryTableViewCell

        cell?.wordLabel?.text = dictionaryTableViewModel?.getWord(indexPath : indexPath)
        cell?.translationLabel?.text = dictionaryTableViewModel?.getTranslation(indexPath : indexPath)
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dictionaryTableViewModel?.setSelectedCell(indexPath: indexPath)
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let seg = segue.destination as? WordTranslationViewController {
            
            seg.wordTranslationModel = bookReaderModel?.getWordTranslationModel()
            
        }
        
    }
 

}
