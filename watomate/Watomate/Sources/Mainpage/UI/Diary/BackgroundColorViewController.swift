//
//  BackgroundColorViewController.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/19.
//  Copyright © 2024 tuist.io. All rights reserved.
//
/*
import UIKit

class BackgroundColorViewController: SheetCustomViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var onEmojiSelected: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("이모지")
        sheetView.addSubview(emojiCollectionView)
        emojiCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
        emojiCollectionView.dataSource = self
        
        okButtonAction(target: self, action: #selector(okButtonTapped))
    }
    
    @objc private func okButtonTapped() {
        guard let selectedIndexPath = emojiCollectionView.indexPathsForSelectedItems?.first,
              let selectedCell = emojiCollectionView.cellForItem(at: selectedIndexPath) as? EmojiCollectionViewCell else {
            return
        }

        let selectedEmoji = selectedCell.selectedEmoji
        onDismiss?(selectedEmoji)
        dismiss(animated: true, completion: nil)
    }
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let dummyEmojis = ["😊", "😠", "🥺", "😂",  "📚", "📝", "🌟", "🏝️", "🎸", "❤️"]
}

extension EmojiViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCollectionViewCell
        let emoji = dummyEmojis[indexPath.item]
        cell.configure(with: emoji)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / CGFloat(dummyEmojis.count)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        onEmojiSelected?(selectedCell?.selectedEmoji ?? "")
    }
}

*/
