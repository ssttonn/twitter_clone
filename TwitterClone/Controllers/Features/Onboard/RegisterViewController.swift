//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 30/04/2023.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {
    
    private let viewModel = RegisterViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            
        ])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            
        ])
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create account", for: .normal)
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
        view.addSubview(registerLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        
        configureConstraints()
        bindViews()
    }
    
    private func bindViews(){
        emailTextField.addTarget(self, action: #selector(onEmailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onPasswordChanged), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        viewModel.$isRegistrationFormValid.sink { [weak self] isFormValid in
            self?.registerButton.isEnabled = isFormValid
            self?.registerButton.alpha = isFormValid ? 1 : 0.5
        }.store(in: &subscriptions)
    }
    
    @objc private func onEmailChanged(){
        viewModel.email = emailTextField.text
        viewModel.validateRegistrationForm()
    }
    
    @objc private func onPasswordChanged(){
        viewModel.password = passwordTextField.text
        viewModel.validateRegistrationForm()
    }
    
    @objc private func didTapRegister(){
        viewModel.registerUser()
    }
    
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
    
    private func configureConstraints(){
        let registerLabelConstraints = [
            registerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(registerLabelConstraints)
        
        let emailTextFieldConstraints = [
            emailTextField.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 20),
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
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
}
