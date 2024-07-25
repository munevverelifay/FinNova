//
//  LoginViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Giriş Yap"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = Colors.primaryColor
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mail Adresiniz"
        textField.backgroundColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şifreniz"
        textField.backgroundColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let rememberMeSwitch: UISwitch = {
        let rememberMeSwitch = UISwitch()
        return rememberMeSwitch
    }()
    
    private let rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = "Beni Unutma"
        label.textColor = .black
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.primaryColor
        button.setTitle("Giriş Yap", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesabınız yok mu? Kayıt Olun"
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupUI()
        loadRememberedEmail()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        let rememberMeStack = UIStackView(arrangedSubviews: [rememberMeLabel, rememberMeSwitch])
        rememberMeStack.axis = .horizontal
        rememberMeStack.spacing = 10
        rememberMeStack.alignment = .center
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(rememberMeStack)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(registerLabel)
        
        setupConstraints()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(registerLabelTapped)))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.037),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.037),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: view.frame.height * 0.055),
            passwordTextField.heightAnchor.constraint(equalToConstant:view.frame.height * 0.055),
            loginButton.heightAnchor.constraint(equalToConstant: view.frame.height * 0.055)
        ])
    }
    
    private func loadRememberedEmail() {
        if let rememberedEmail = UserDefaults.standard.string(forKey: "rememberedEmail") {
            emailTextField.text = rememberedEmail
            rememberMeSwitch.isOn = true
        }
    }
    
    @objc private func loginButtonTapped() {
        let authManager = FirebaseAuthManager()
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            displayErrorMessage("Please fill in all fields.")
            return
        }
        
        authManager.loginUserWithEmailAndPassword(email: email, password: password) { [weak self] (success, error) in
            guard let self = self else { return }
            if success {
                print("User logged in successfully")
                if self.rememberMeSwitch.isOn {
                    UserDefaults.standard.set(email, forKey: "rememberedEmail")
                } else {
                    UserDefaults.standard.removeObject(forKey: "rememberedEmail")
                }
                let homeVC = HomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            } else {
                self.displayErrorMessage(error ?? "There was an error.")
            }
        }
    }
    
    @objc private func registerLabelTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func displayErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if isValidEmail(email: textField.text ?? "") {
                print("Valid email address")
            } else {
                print("Invalid email address")
                displayErrorMessage("Invalid email format")
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
