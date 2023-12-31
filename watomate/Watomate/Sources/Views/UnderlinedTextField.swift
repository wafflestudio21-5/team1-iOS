//
//  UnderlinedTextField.swift
//  Waffle
//
//  Created by 이지현 on 12/31/23.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorder()
    }
}
