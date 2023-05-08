//
//  OnboardingViewController.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 28/04/2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "See what's happening in the world right now."
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Create acccount", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let promtLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Have an account already?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
  
        button.setTitleColor(UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1), for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
   
        return button
    }()
    
    
    private let promtStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.spacing = 5
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        createAccountButton.addTarget(self, action: #selector(onRegisterButtonClicked), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(onLoginButtonClicked), for: .touchUpInside)
        
        view.addSubview(welcomeLabel)
        view.addSubview(createAccountButton)
        view.addSubview(promtStack)
       
        promtStack.addArrangedSubview(promtLabel)
        promtStack.addArrangedSubview(loginButton)
        
        configureConstraints()
    }
    
    @objc private func onRegisterButtonClicked(){
        let vc = RegisterViewController()
        navigationController?.show(vc, sender: self)
    }
    
    @objc private func onLoginButtonClicked(){
        let vc = LoginViewController()
        navigationController?.show(vc, sender: self)
    }
    
    private func configureConstraints(){
        let welcomeLabelConstraints = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstraints)
        
        let createAccountButtonConstraints = [
            createAccountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(createAccountButtonConstraints)
        
        let promptStackConstraints = [
            promtStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promtStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ]
        
        NSLayoutConstraint.activate(promptStackConstraints)
    }
}
