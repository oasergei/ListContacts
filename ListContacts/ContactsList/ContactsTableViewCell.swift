//
//  ContactsTableViewCell.swift
//  ListContacts
//
//  Created by Sergey on 12.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameContactLabel: UILabel!
    @IBOutlet weak var telContactLabel: UILabel!
    @IBOutlet weak var temperamentContactLabel: UILabel!
    
    weak var viewModel: ContactTableViewCellViewModelType? {
        didSet {
            guard let viewModel = viewModel else { return }
            nameContactLabel.text = viewModel.name
            telContactLabel.text = viewModel.telephone
            temperamentContactLabel.text = viewModel.temperament
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
