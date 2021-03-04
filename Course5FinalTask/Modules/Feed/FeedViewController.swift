//
//  FeedViewController.swift
//  Course5FinalTask
//
//  Created by Evgeny Novgorodov on 22.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FeedViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var feedTableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: FeedViewModelProtocol
    
    // MARK: - Initializers
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifeсycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        feedTableView.register(FeedPostCell.nib(), forCellReuseIdentifier: FeedPostCell.identifier)
        setupViewModelBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getFeedPosts(withUpdatingTableView: true)
    }
    
    // MARK: - Private methods
        
    private func setupViewModelBindings() {
        viewModel.tableViewNeedUpdating = { [unowned self] in
            self.feedTableView.reloadData()
        }
        
        viewModel.error.bind { [unowned self] error in
            guard let error = error else { return }
            self.showAlert(error)
        }
    }
}

// MARK: - Table view data source

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostCell.identifier,
                                                 for: indexPath) as! FeedPostCell
        cell.viewModel = viewModel.getFeedPostCellViewModel(at: indexPath)
        cell.viewModel?.delegate = self
        cell.configure()
        return cell
    }
}

// MARK: - FeedPostCellViewModelDelegate

extension FeedViewController: FeedPostCellViewModelDelegate {
    
    /// Переход в профиль автора поста.
    func authorOfPostTapped(user: UserModel) {
        let profileVC = ProfileViewController(nibName: nil,
                                              bundle: nil,
                                              viewModel: ProfileViewModel(user: user))
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    /// Переход на экран лайкнувших пост пользователей.
    func likesCountButtonTapped(postID: String) {
        let userListVM = UserListViewModel(postID: postID, userListType: .likes)
        let likesVC = UserListViewController(viewModel: userListVM)
        navigationController?.pushViewController(likesVC, animated: true)
    }
    
    /// Обновление данных массива постов ленты (вызывается после лайка/анлайка).
    func updateFeedData() {
        viewModel.getFeedPosts(withUpdatingTableView: false)
    }
        
    func showErrorAlert(_ error: Error) {
        showAlert(error)
    }
}

// MARK: - SharingViewControllerDelegate

extension FeedViewController: SharingViewControllerDelegate {
    
    // Прокрутка ленты в верхнее положение
    func updateAfterPosting() {
        feedTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
