//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 02/05/2023.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private var subscriptions: Set<AnyCancellable> = []
    
    private let viewModel = AuthenticationViewModel()
    
    private let loginTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Login with your account"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.layer.masksToBounds = true
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.isEnabled = false
        button.alpha = 0.5
      
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(loginTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        configureConstraints()
        bindViews()
    }
    
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
    
    private func configureConstraints(){
        let loginLabelConstraints = [
            loginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            loginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(loginLabelConstraints)
        
        let emailTextFieldConstraints = [
            emailTextField.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        
        let passwordTextFieldConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        
        let registerButtonConstraints = [
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
    
    private func bindViews(){
        emailTextField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        viewModel.$isRegistrationFormValid.sink{ [weak self] isLoginFormValid in
            self?.loginButton.isEnabled = isLoginFormValid
            self?.loginButton.alpha = isLoginFormValid ? 1 : 0.5
        }.store(in: &subscriptions)
        
        viewModel.$errorString.sink{ [weak self] errorString in
            guard let errorString = errorString else {return}
            self?.showErrorAlert(errorString: errorString)
        }.store(in: &subscriptions)
        
        viewModel.$user.sink{ [weak self] user in
            guard let user = user else {
                return
            }
            
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else{
                return
            }
            
            vc.dismiss(animated: true)
        }.store(in: &subscriptions)
    }
    
    @objc private func emailDidChange(){
        viewModel.email = emailTextField.text
        viewModel.validateRegistrationForm()
    }
    
    @objc private func passwordDidChange(){
        viewModel.password = passwordTextField.text
        viewModel.validateRegistrationForm()
    }
    
    private func showErrorAlert(errorString: String){
        let vc = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        vc.addAction(okAction)
        present(vc, animated: true)
    }
    
    @objc private func didTapLogin(){
        viewModel.login()
    }
}
