//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 19/03/2023.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewViewModel = HomeViewViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let timelineTableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.allowsSelection = false
        configureNavigationBar()
        bindViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.bounds
    }
    
    private func configureNavigationBar(){
        let size: CGFloat = 32
        
        let logoImageView = UIImageView(image: UIImage(named: "twitterLogo"))
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        middleView.addSubview(logoImageView)
        
        navigationItem.titleView = middleView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(didTapProfile))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), style: .plain, target: self, action: #selector(didTapLogout))
    }
    
    @objc private func didTapProfile(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLogout(){
        try? Auth.auth().signOut()
        if Auth.auth().currentUser == nil{
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            return
        }
        viewModel.retrieveUser()
    }
    
    func bindViews(){
        viewModel.$user.sink{ [weak self] user in
            guard let user = user else {return}
            
            if !user.isUserOnboarded{
                self?.completeUserOnboarding()
            }
        }.store(in: &subscriptions)
    }
    
    func completeUserOnboarding(){
        let vc = ProfileDataFormViewController()
        self.present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
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

extension HomeViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        print("DidReply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("DidRetweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("DidLike")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("DidShare")
    }
    
    
}
