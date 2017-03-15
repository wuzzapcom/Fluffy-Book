//
//  DictionaryTableViewCell.swift
//  FluffyBook
//
//  Created by Владимир Лапатин on 15/03/2017.
//  Copyright © 2017 wuzzapcom. All rights reserved.
//

import UIKit

class DictionaryTableViewCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}
