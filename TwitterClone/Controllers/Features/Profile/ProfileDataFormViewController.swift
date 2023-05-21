//
//  ProfileDataFormViewController.swift
//  TwitterClone
//
//  Created by Toan Phan Nguyen Song on 08/05/2023.
//

import UIKit
import PhotosUI
import Combine

class ProfileDataFormViewController: UIViewController {
    
    private let viewModel: ProfileDataFormViewModel = ProfileDataFormViewModel()
    private var subscriptions: [AnyCancellable] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Fill in your data"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let avatarPlaceHolderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .gray
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let displayNameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Display name", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
        
        return textField
    }()
    
    private let usernameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.backgroundColor = .secondarySystemFill
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
        return textField
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .secondarySystemFill
        textView.text = "Tell the world about yourself"
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        return textView
    }()
    
    private let submitButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.setTitle("Create account", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.layer.opacity = 0.4
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
       
        scrollView.addSubview(hintLabel)
        scrollView.addSubview(avatarPlaceHolderImageView)
        scrollView.addSubview(displayNameField)
        scrollView.addSubview(usernameField)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(submitButton)
        
        applyConstraints()
        
        isModalInPresentation = true
        
        // Delegations
        bioTextView.delegate = self
        displayNameField.delegate = self
        usernameField.delegate = self
        
        avatarPlaceHolderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvatar)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        
        bindViews()
    }
    
    private func bindViews(){
        displayNameField.addTarget(self, action: #selector(displayNameFieldDidChange), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(usernameFieldDidChange), for: .editingChanged)
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        viewModel.$isFormValidated.sink{[weak self] isButtonValidated in
            self?.submitButton.isEnabled = isButtonValidated
            self?.submitButton.layer.opacity = isButtonValidated ? 1 : 0.4
        }.store(in: &subscriptions)
        
        viewModel.$isUserOnboarded.sink{ [weak self] isUserOnboarded in
            if isUserOnboarded {
                self?.dismiss(animated: true)
            }
        }.store(in: &subscriptions)
    }
    
    @objc private func displayNameFieldDidChange(){
        viewModel.displayName = displayNameField.text
        viewModel.validateForm()
    }
    
    @objc private func usernameFieldDidChange(){
        viewModel.username = usernameField.text
        viewModel.validateForm()
    }
    
    @objc private func didTapSubmit(){
        view.endEditing(true)
        viewModel.submit()
    }
    
    @objc private func didTapAvatar(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let vc = PHPickerViewController(configuration: configuration)
        vc.delegate = self
        
        present(vc, animated: true)
    }
    
    private func applyConstraints(){
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        let hintLabelConstraints = [
            hintLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hintLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30)
        ]
        
        NSLayoutConstraint.activate(hintLabelConstraints)
        
        let avatarPlaceHolderImageViewConstraints = [
            avatarPlaceHolderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarPlaceHolderImageView.heightAnchor.constraint(equalToConstant: 120),
            avatarPlaceHolderImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarPlaceHolderImageView.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 30)
        ]
        
        NSLayoutConstraint.activate(avatarPlaceHolderImageViewConstraints)
        
        let displayNameFieldConstraints = [
            displayNameField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            displayNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayNameField.topAnchor.constraint(equalTo: avatarPlaceHolderImageView.bottomAnchor, constant: 40),
            displayNameField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(displayNameFieldConstraints)
        
        let usernameFieldConstraints = [
            usernameField.leadingAnchor.constraint(equalTo: displayNameField.leadingAnchor),
            usernameField.trailingAnchor.constraint(equalTo: displayNameField.trailingAnchor),
            usernameField.topAnchor.constraint(equalTo: displayNameField.bottomAnchor, constant: 20),
            usernameField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(usernameFieldConstraints)
        
        let bioTextViewConstraints = [
            bioTextView.leadingAnchor.constraint(equalTo: displayNameField.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: displayNameField.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(bioTextViewConstraints)
        
        let submitButtonConstraints = [
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(submitButtonConstraints)
    }
    
    
    @objc private func didTapToDismiss(){
        view.endEditing(true)
    }
}

extension ProfileDataFormViewController: UITextViewDelegate, UITextFieldDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textView.frame.origin.y - 100), animated: true)
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if textView.text.isEmpty {
            textView.text = "Tell the world about yourself"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.bio = textView.text
        viewModel.validateForm()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension ProfileDataFormViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard error == nil, let image = object as? UIImage else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.avatarPlaceHolderImageView.image = image
                    self?.viewModel.avatarImage = image
                    self?.viewModel.validateForm()
                }
            }
        }
       
    }
    
    
}
