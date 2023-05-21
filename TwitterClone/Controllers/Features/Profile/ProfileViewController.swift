//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 21/03/2023.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden: Bool = true
    
    private let viewModel: ProfileViewModel = ProfileViewModel()
    
    private var subscriptions: [AnyCancellable] = []
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var headerProfileView: ProfileTableViewHeader? = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        navigationItem.title = "Profile"
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        headerProfileView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
        
        profileTableView.tableHeaderView = headerProfileView
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        
        configureConstraints()
        
        bindViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveUser()
    }
    
    private func bindViews(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else {return}
            self?.headerProfileView?.configure(with: user)
        }.store(in: &subscriptions)
    }
    
    private func configureConstraints(){
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: statusBarHeight())
        ]
        
        NSLayoutConstraint.activate(statusBarConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileTableView.frame = view.bounds
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear){[weak self] in
                self?.statusBar.layer.opacity = 1
            }
        }else if yPosition <= 150 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear){[weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
}

extension ProfileViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        
    }
    
    func tweetTableViewCellDidTapRetweet() {
        
    }
    
    func tweetTableViewCellDidTapLike() {
        
    }
    
    func tweetTableViewCellDidTapShare() {
        
    }
    
    
}
