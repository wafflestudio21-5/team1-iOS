//
//  ChildTableView.swift
//  Watomate
//
//  Created by 이지현 on 1/25/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class ChildTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
