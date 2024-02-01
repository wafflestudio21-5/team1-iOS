//
//  ArchiveBoxViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/02/01.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class ArchiveBoxViewController: PlainCustomBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("나의 인증샷")
        setLeftBackButton()
        /*
        contentView.addSubview(archiveImageCollectionView)
        archiveImageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
         */
    }
    /*
    private lazy var archiveImageCollectionView : UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
     */

   

}
