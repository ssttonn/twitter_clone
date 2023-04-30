//
//  ProfileTableViewHeader.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 22/03/2023.
//

import UIKit

enum SectionTabs: String, CaseIterable {
    case tweets = "Tweets"
    case tweetsAndReplies = "Tweets & Replies"
    case media = "Media"
    case likes = "Likes"
    
    var index: Int {
        switch self{
        case .tweets:
            return 0
        case .tweetsAndReplies:
            return 1
        case .media:
            return 2
        case .likes:
            return 3
        }
    }
}

class ProfileTableViewHeader: UIView {
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    private var tabs: [UIButton] = SectionTabs.allCases.map{tab in
        let button = UIButton(type: .system)
        button.setTitle(tab.rawValue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "headerImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "person")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.tintColor = .white
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Toan"
        label.font = .systemFont(ofSize: 22,weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@sstonn"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "IOS Developer"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        
        return label
    }()
    
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar",withConfiguration: UIImage.SymbolConfiguration(pointSize: 18))
        imageView.tintColor = .gray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let joinDateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Joined May 2021"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingsTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "314"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersTextLabel: UILabel = {
       let label = UILabel()
        label.text = "Followers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersCountLabel: UILabel = {
       let label = UILabel()
        
        label.text = "1M"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tabIndicator: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        return view
    }()
    
    private var selectedTab: SectionTabs = SectionTabs.tweets {
        didSet {
            for i in 0..<SectionTabs.allCases.count{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = self?.selectedTab.index == i ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = self?.selectedTab.index == i
                    self?.trailingAnchors[i].isActive = self?.selectedTab.index == i
                    self?.layoutIfNeeded()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
       
        
        addSubview(headerImageView)
        addSubview(avatarImageView)
        addSubview(displayNameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(joinDateImageView)
        addSubview(joinDateLabel)
        addSubview(followersTextLabel)
        addSubview(followersCountLabel)
        addSubview(followingsTextLabel)
        addSubview(followingsCountLabel)
        addSubview(sectionStack)
        addSubview(tabIndicator)
        
        for index in SectionTabs.allCases.indices{
            leadingAnchors.append(tabIndicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[index].leadingAnchor))
            trailingAnchors.append(tabIndicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[index].trailingAnchor))
        }
        
        applyConstraints()
        
        configureStackButton()
    }
    
    private func configureStackButton(){
        for button in sectionStack.arrangedSubviews{
            guard let button = button as? UIButton else {return}
            
            guard let title = button.titleLabel?.text else {
                return
            }
           
            button.addTarget(self, action: #selector(didTapTab), for: .touchUpInside)
            
            button.tintColor = selectedTab.rawValue == title ? .label : .secondaryLabel
        }
    }
    
    @objc private func didTapTab(_ sender: UIButton){
        guard let title = sender.titleLabel?.text, let selectedTab = SectionTabs(rawValue: title) else {
            return
        }
        self.selectedTab = selectedTab
    }
    
    private func applyConstraints(){
    
        
        let headerImageViewConstraints = [
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(headerImageViewConstraints)
        
        let avatarImageViewConstraints = [
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            avatarImageView.centerYAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        NSLayoutConstraint.activate(avatarImageViewConstraints)
        
        let displayNameLabelConstraints = [
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5)
        ]
        
        NSLayoutConstraint.activate(usernameLabelConstraints)
        
        let bioLabelConstraints = [
            bioLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5)
        ]
        
        NSLayoutConstraint.activate(bioLabelConstraints)
        
        let joinDateImageViewConstraints = [
            joinDateImageView.leadingAnchor.constraint(equalTo: bioLabel.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5)
        ]
        
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        
        let joinDateLabelConstraints = [
            joinDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 5),
            joinDateLabel.centerYAnchor.constraint(equalTo: joinDateImageView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(joinDateLabelConstraints)
        
        let followingsCountLabelConstraints = [
            followingsCountLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            followingsCountLabel.topAnchor.constraint(equalTo: joinDateImageView.bottomAnchor, constant: 10),

        ]

        NSLayoutConstraint.activate(followingsCountLabelConstraints)

        let followingsTextLabelConstraints = [
            followingsTextLabel.leadingAnchor.constraint(equalTo: followingsCountLabel.trailingAnchor, constant: 4),
            followingsTextLabel.bottomAnchor.constraint(equalTo: followingsCountLabel.bottomAnchor)
        ]

        NSLayoutConstraint.activate(followingsTextLabelConstraints)

        let followersCountLabelConstraints = [
            followersCountLabel.leadingAnchor.constraint(equalTo: followingsTextLabel.trailingAnchor, constant: 8),
            followersCountLabel.bottomAnchor.constraint(equalTo: followingsCountLabel.bottomAnchor)
        ]

        NSLayoutConstraint.activate(followersCountLabelConstraints)

        let followersTextLabelConstraints = [
            followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor, constant: 4),
            followersTextLabel.bottomAnchor.constraint(equalTo: followingsCountLabel.bottomAnchor)
        ]

        NSLayoutConstraint.activate(followersTextLabelConstraints)
        
        let sectionStackConstraints = [
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingsCountLabel.bottomAnchor, constant: 5),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        NSLayoutConstraint.activate(sectionStackConstraints)
        
        let tabIndicatorConstraints = [
            leadingAnchors[selectedTab.index],
            trailingAnchors[selectedTab.index],
            tabIndicator.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[selectedTab.index].bottomAnchor),
            tabIndicator.heightAnchor.constraint(equalToConstant: 4)
        ]
        
        NSLayoutConstraint.activate(tabIndicatorConstraints)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
