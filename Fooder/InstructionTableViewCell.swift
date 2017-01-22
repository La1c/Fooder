//
//  InstructionTableViewCell.swift
//  Fooder
//
//  Created by Vladimir on 22.01.17.
//  Copyright © 2017 Vladimir Ageev. All rights reserved.
//

import UIKit

class InstructionTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var numberImageView: UIImageView!
    func configure(with instruction: String, at number: Int){
        label.text = instruction
        numberImageView.image = UIImage(named: String(number + 1))
    }
}
