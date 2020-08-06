//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by Дмитрий Константинов on 06.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = String(describing: ToDoTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
