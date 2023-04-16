//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 21/03/2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(profileTableView)
        navigationItem.title = "Profile"
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        let headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
        
        profileTableView.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileTableView.frame = view.bounds
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
