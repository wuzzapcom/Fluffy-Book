//
//  TranslationPresentationViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 13.05.17.
//  Copyright © 2017 FluffyBook. All rights reserved.
//

import UIKit

class TranslationPresentationViewController: UIViewController {
    
    public var translation : String?
    fileprivate var indication : UIActivityIndicatorView?
    fileprivate var translationLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(notification:)),
                                               name: Notification.Name(Constants.NOTIFICATION_IDENTIFIER),
                                               object: nil)
        
        indication = UIActivityIndicatorView()
        indication?.color = UIColor.black
        self.view.backgroundColor = UIColor.white
        indication?.startAnimating()
        
        addView(subView: indication!)
        
    }
    
    func addView(subView : UIView){
        
        self.view.addSubview(subView)
        
        let centerX = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: subView
            , attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 22)
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([centerX, centerY, height])
        
    }
    
    func handleNotification(notification: Notification){
        
        print("notification")
        
        indication?.removeFromSuperview()
        
        translationLabel = UILabel()
        translationLabel?.text = notification.object as? String
        
        addView(subView: translationLabel!)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
