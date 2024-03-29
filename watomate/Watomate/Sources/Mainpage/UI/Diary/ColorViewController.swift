//
//  BackgroundColorViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/19.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

class ColorViewController: SheetCustomViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var useGoalColors = false
    var onBackgroundSelected: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("배경 색상")
        sheetView.addSubview(backgroundCollectionView)
        backgroundCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
        backgroundCollectionView.dataSource = self
        
        okButtonAction(target: self, action: #selector(okButtonTapped))
    }
    
    @objc private func okButtonTapped() {
        guard let selectedIndexPath = backgroundCollectionView.indexPathsForSelectedItems?.first,
              let selectedCell = backgroundCollectionView.cellForItem(at: selectedIndexPath) as? ColorCollectionViewCell else {
            return
        }

        let selectedColor = selectedCell.selectedColor
        onDismiss?(selectedColor)
        dismiss(animated: true, completion: nil)
    }
    
    private lazy var backgroundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let backgroundColors = ["system", "beige", "blue", "coffee", "lightblue", "lime", "orange", "red", "pink", "purple", "green", "yellow"]
    
    let goalColors = ["beige", "blue", "brown", "coffee", "lightblue", "lime", "orange", "red", "pink", "purple", "green", "yellow"]
}

extension ColorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCollectionViewCell
        let color = useGoalColors ? goalColors[indexPath.item] : backgroundColors[indexPath.item]
        cell.configure(with: color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 10
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell
        onBackgroundSelected?(selectedCell?.selectedColor ?? "")
    }
}


