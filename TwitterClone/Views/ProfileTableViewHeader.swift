//
//  ProfileTableViewHeader.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 22/03/2023.
//

import UIKit

class ProfileTableViewHeader: UIView {
    
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
        
        label.text = "01/01/1970"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        applyConstraints()
    }
    
    private func applyConstraints(){
        let headerImageViewConstraints = [
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 180)
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
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
