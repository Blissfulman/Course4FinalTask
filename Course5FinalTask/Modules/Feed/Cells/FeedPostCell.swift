//
//  FeedPostCell.swift
//  Course5FinalTask
//
//  Created by Evgeny Novgorodov on 04.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FeedPostCell: UITableViewCell {
    
    // MARK: - Class properties
    
    static let identifier = String(describing: FeedPostCell.self)
    
    // MARK: - Class methods
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var authorUsernameLabel: UILabel!
    @IBOutlet private weak var createdTimeLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var bigLikeImageView: UIImageView!
    @IBOutlet private weak var likesCountButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var viewModel: FeedPostCellViewModelProtocol!
        
    // MARK: - Lifeсycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestureRecognizers()
    }
    
    // MARK: - Public methods
    
    func configure() {
        avatarImageView.image = UIImage(data: viewModel.avatarImageData)
        authorUsernameLabel.text = viewModel.authorUsername
        createdTimeLabel.text = viewModel.createdTime
        postImageView.image = UIImage(data: viewModel.postImageData)
        descriptionLabel.text = viewModel.description
        likesCountButton.setTitle(viewModel.likesCountButtonTitle, for: .normal)
        likeButton.tintColor = viewModel.currentUserLikesThisPost
            ? .systemBlue // FIXME: CONSTANTS
            : .lightGray
        
        setupViewModelBindings()
    }
    
    // MARK: - Actions
    
    @objc private func postAuthorTapped() {
        viewModel.postAuthorTapped()
    }
    
    @objc private func postImageDoubleTapped() {
        viewModel.postImageDoubleTapped()
    }
    
    @IBAction private func likesCountButtonTapped() {
        viewModel.likesCountButtonTapped()
    }
    
    @IBAction private func likeButtonTapped() {
        viewModel.likeUnlikePost()
    }
    
    // MARK: - Private methods
    
    private func setupGestureRecognizers() {
        
        // Жест двойного тапа по картинке поста
        let postImageGR = UITapGestureRecognizer(
            target: self, action: #selector(postImageDoubleTapped)
        )
        postImageGR.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(postImageGR)
        
        // Жест тапа по автору поста (по аватарке)
        let authorAvatarGR = UITapGestureRecognizer(
            target: self, action: #selector(postAuthorTapped)
        )
        avatarImageView.addGestureRecognizer(authorAvatarGR)
        
        // Жест тапа по автору поста (по username)
        let authorUsernameGR = UITapGestureRecognizer(
            target: self, action: #selector(postAuthorTapped)
        )
        authorUsernameLabel.addGestureRecognizer(authorUsernameGR)
    }
    
    private func setupViewModelBindings() {
        
        viewModel.likeDataNeedUpdating = { [weak self] in
            guard let self = self else { return }
            
            self.likesCountButton.setTitle(self.viewModel.likesCountButtonTitle, for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.likeButton.tintColor = self.viewModel.currentUserLikesThisPost
                    ? .systemBlue // FIXME: CONSTANTS
                    : .lightGray
            }
        }

        viewModel.bigLikeNeedAnimating = { [weak self] in
            self?.bigLikeImageView.bigLikeAnimation()
        }
    }
}
