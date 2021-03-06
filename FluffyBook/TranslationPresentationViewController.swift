//
//  TranslationPresentationViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 13.05.17.
//  Copyright © 2017 FluffyBook. All rights reserved.
//

import UIKit

class TranslationPresentationViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    public var translation : String?
    var prevViewBlur : UIVisualEffectView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(notification:)),
                                               name: Notification.Name(Constants.NOTIFICATION_FOR_BOOK_READER_VIEW_CONTROLLER),
                                               object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        label?.alpha = 0.0
        indicator?.color = UIColor.black
        indicator?.startAnimating()
        
    }
    
    func handleTap(sender : UITapGestureRecognizer){
        
        print("exit view")
        
        prevViewBlur?.removeFromSuperview()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func addView(subView : UIView){
        
        self.view.addSubview(subView)
        
        let centerX = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: subView
            , attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([centerX, centerY, height])
        
    }
    
    func handleNotification(notification: Notification){
        
        print("notification")
        
        label?.text = notification.object as? String
        label?.font = UIFont(name: "Arial", size: 27.0)
        
        self.indicator?.alpha = 0.0
        UIView.animate(withDuration: 0.7, animations: {
            self.label?.alpha = 1.0
        })
        
//        indication?.removeFromSuperview()
//        
//        translationLabel = UILabel()
//        translationLabel?.text = notification.object as? String
////        translationLabel?.font = translationLabel?.font.withSize(27)
//        translationLabel?.font = UIFont(name: "Arial", size: 27.0)
//
//        addView(subView: translationLabel!)
    
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(Constants.NOTIFICATION_FOR_BOOK_READER_VIEW_CONTROLLER),
                                                  object: nil)
    }


}
