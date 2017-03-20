//
//  BooksTableTableViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class BooksTableTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var bookReaderModel : BookReaderModel?
    var booksTableViewModel : BooksTableViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Just one instanse of BookReaderModel, initialization in AppDelegate
        bookReaderModel = (UIApplication.shared.delegate as! AppDelegate).bookReaderModel
        booksTableViewModel = bookReaderModel?.getBooksTableViewModel()
        
        registerViewForPreview()
        
        
    }
    
    func registerViewForPreview(){
        
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: self.view)
        }
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return booksTableViewModel!.getNumberOfSections()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksTableViewModel!.getNumberOfRows(section: section)
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCellIdentifier", for: indexPath) as? (BooksTableViewCell)
        
        cell?.bookNameLabel!.text = booksTableViewModel?.getBookName(indexPath : indexPath)
        cell?.bookAuthorLabel!.text = booksTableViewModel?.getAuthor(indexPath : indexPath)
        cell?.tagsLabel!.text = booksTableViewModel?.getTags(indexPath : indexPath)
        cell?.bookPictureImageView?.image = UIImage(imageLiteralResourceName: (booksTableViewModel?.getImageName(indexPath : indexPath))!)

        return cell!
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        booksTableViewModel?.setSelectedCell(indexPath: indexPath)
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = self.tableView?.indexPathForRow(at: location)
        
        let cell = self.tableView?.cellForRow(at: indexPath!)
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "BookReaderViewController") as? BookReaderViewController
        
        setModelToDestinationViewController(vc: detailViewController!)
        
        detailViewController?.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        previewingContext.sourceRect = (cell?.frame)!
        
        return detailViewController
        
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
        
        showDetailViewController(viewControllerToCommit, sender: self)
        
    }
    
    func setModelToDestinationViewController(vc : BookReaderViewController){
        
        vc.bookModel = bookReaderModel?.getBookModelObject()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
 
        self.navigationItem.backBarButtonItem = backButton
        
        if let seg = segue.destination as? BookReaderViewController {
            
            setModelToDestinationViewController(vc: seg)
            
        }

    }


}
