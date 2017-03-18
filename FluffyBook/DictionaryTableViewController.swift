//
//  DictionaryTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class DictionaryTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var bookReaderModel : BookReaderModel?
    var dictionaryTableViewModel : DictionaryTableViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        dictionaryTableViewModel = bookReaderModel?.getDictionaryTableViewModel()
        
        registerViewForPreview()
        
    }
    
    func registerViewForPreview(){
        
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: self.view)
        }
        
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
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {

        let indexPath = self.tableView?.indexPathForRow(at: location)
        
        let cell = self.tableView?.cellForRow(at: indexPath!)
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "WordTranslationViewController") as? WordTranslationViewController
        
        setModelToDestinationViewController(vc: detailViewController!)
        
        detailViewController?.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = (cell?.frame)!
        
//        self.navigationController?.pushViewController(detailViewController!, animated: false)
        
        return detailViewController
        
        //let navigationController = UINavigationController(rootViewController: detailViewController!)
        
        //return navigationController
        //return detailViewController
        
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
        
        showDetailViewController(viewControllerToCommit, sender: self)
        
    }
    
    func setModelToDestinationViewController( vc : WordTranslationViewController ){
        
        vc.wordTranslationModel = bookReaderModel?.getWordTranslationModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let seg = segue.destination as? WordTranslationViewController {
            
            setModelToDestinationViewController(vc: seg)
            
        }
        
    }
 

}
