//
//  ArchiveDetailViewController.swift
//  Watomate
//
//  Created by 이지현 on 2/2/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import SnapKit
import Kingfisher
import UIKit

class ArchiveDetailViewController: PlainCustomBarViewController {
    private let viewModel: ImageCellViewModel
    
    init(viewModel: ImageCellViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.kf.setImage(with: URL(string: viewModel.image)!)
        return view
    }()
    
    private lazy var button = {
        let button = UIButton()
        button.setImage(UIImage(named: "logoButton"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonTapped() {
        let vc = DetailInfoViewController(viewModel: viewModel)
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return 200
            })]
        }
        present(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = .black
        
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        setLeftBackButton()
        setTitle(Utils.convertToKorean(date: viewModel.date))
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(64)
        }
    }

}
