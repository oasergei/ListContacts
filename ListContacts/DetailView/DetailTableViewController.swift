//
//  DetailTableViewController.swift
//  ListContacts
//
//  Created by Sergey on 21.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationPeriodLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    @IBOutlet weak var telephoneButton: UIButton!
    @IBOutlet weak var biographyTextView: UITextView!
    
    var viewModel: DetailViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let vModel = viewModel else { return }
        nameLabel.text = vModel.name
        educationPeriodLabel.text = vModel.educationPeriod
        temperamentLabel.text = vModel.temperament
        telephoneButton.setTitle(vModel.telephone, for: .normal)
        biographyTextView.text = vModel.biography
    }
    
    @IBAction func telephonePressed(_ sender: UIButton) {
        guard let phone = sender.titleLabel?.text else { return }
        call(phone: phone)
    }

    private func call(phone: String){
        guard let url = URL(string: "tel://\(phone.normalizePhoneNumber())") else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
