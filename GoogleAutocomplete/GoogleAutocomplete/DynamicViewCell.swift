//
//  DynamicViewCell.swift
//  GoogleAutocomplete
//
//  Created by   on 06/05/18.
//  Copyright © 2018  . All rights reserved.
//

import UIKit

class DynamicViewCell: UITableViewCell {

    @IBOutlet weak var lblDynamic: UILabel!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
