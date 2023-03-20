//
//  TweetTableViewCell.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 19/03/2023.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    static let identifier = "TweetTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .gray
        imageView.tintColor = .white
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Toan"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@sstonn"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tweetContentLabel: UILabel = {
        let label = UILabel()
        label.text = """
In this video we will add a custom cell to display Tweets inside the feed table view.
The custom cells are going to be made with AutoLayout in mind so cells height can be adjusted dynamically according to the tweet content being wrapped
"""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(avatarImageView)
        addSubview(displayNameLabel)
        addSubview(usernameLabel)
        addSubview(tweetContentLabel)
        applyConstraints()
    }
    
    private func applyConstraints(){
        let avatarImageViewConstraints = [
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(avatarImageViewConstraints)
        
        let displayNameLabelConstraints = [
            displayNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            displayNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.trailingAnchor, constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(usernameLabelConstraints)
        
        let tweetContentLabelConstraints = [
            tweetContentLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            tweetContentLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 10),
            tweetContentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            tweetContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(tweetContentLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
