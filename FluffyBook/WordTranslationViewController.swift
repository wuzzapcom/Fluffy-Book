//
//  WordTranslationViewController.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 11/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class WordTranslationViewController: UIViewController {
    
    var wordTranslationModel : WordTranslationModel?


    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var transcriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordLabel?.text = wordTranslationModel?.getWord()
        
        translationLabel?.text = wordTranslationModel?.getTranslation()
        
        transcriptionLabel?.text = wordTranslationModel?.getTranscription()
        
    }

}
