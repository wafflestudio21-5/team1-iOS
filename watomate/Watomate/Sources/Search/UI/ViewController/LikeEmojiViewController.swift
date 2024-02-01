//
//  LikeEmojiViewController.swift
//  Watomate
//
//  Created by 이지현 on 1/30/24.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit
import SnapKit

protocol LikeEmojiViewControllerDelegate: AnyObject {
    func diaryLike(diaryId: Int, user: Int, emoji: String)
    func commentLike(commentId: Int, emoji: String)
}

class LikeEmojiViewController: DraggableCustomBarViewController {
    weak var delegate: LikeEmojiViewControllerDelegate?
    var commentId: Int?
    var diaryId: Int?
    var userId: Int?
    
    let emojis = ["😀", "😍", "☺️", "🥲", "😂", "🥳", "🥺", "😭", "🤔", "🥰", "🫠", "👍", "👏", "🖐️", "👀", "🙇", "🔥", "⭐️", "❓", "💯", "✅", "❤️", "🙏", "👌"]
    let columns: CGFloat = 6
    
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 35, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(LikeEmojiCell.self, forCellWithReuseIdentifier: LikeEmojiCell.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension LikeEmojiViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeEmojiCell.identifier, for: indexPath) as? LikeEmojiCell else { fatalError() }
        cell.setEmoji(emojis[indexPath.row])
        return cell
    }
    
    
}

extension LikeEmojiViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let userId else { return }
        if let diaryId {
            delegate?.diaryLike(diaryId: diaryId, user: userId, emoji: emojis[indexPath.row])
            dismiss(animated: true)
        }
        if let commentId {
            delegate?.commentLike(commentId: commentId, emoji: emojis[indexPath.row])
            dismiss(animated: true)
        }
        
    }
}
