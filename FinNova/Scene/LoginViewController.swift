//
//  LoginViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

//import UIKit
//
//class LoginViewController: UIViewController {
//    
//    internal let emailTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter your email"
//        textField.backgroundColor = .white
//        textField.autocapitalizationType = .none
//        textField.autocorrectionType = .no
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
//    
//    private let passwordTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter your password"
//        textField.backgroundColor = .white
//        textField.autocapitalizationType = .none
//        textField.autocorrectionType = .no
//        textField.borderStyle = .roundedRect
//        textField.isSecureTextEntry = true
//        return textField
//    }()
//    
//    private let loginButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = .systemBlue
//        button.setTitle("Login", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 15
//        button.addTarget(LoginViewController.self, action: #selector(loginButtonTapped), for: .touchUpInside)
//        return button
//    }()
//    
//    private let registerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Don't have an account? Register"
//        label.textColor = .link
//        label.textAlignment = .center
//        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(UITapGestureRecognizer(target: LoginViewController.self, action: #selector(registerLabelTapped)))
//        return label
//    }()
//    
//    private let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 30
//        return stackView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//    
//    private func setupUI() {
//        self.view.backgroundColor = .white
//        
//        view.addSubview(stackView)
//        
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        
//        stackView.addArrangedSubview(emailTextField)
//        stackView.addArrangedSubview(passwordTextField)
//        stackView.addArrangedSubview(loginButton)
//        stackView.addArrangedSubview(registerLabel)
//        
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//        
//        NSLayoutConstraint.activate([
//            emailTextField.heightAnchor.constraint(equalToConstant: 44),
//            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
//            loginButton.heightAnchor.constraint(equalToConstant: 44)
//        ])
//    }
//    
//    @objc private func loginButtonTapped() {
//        let loginManager = FirebaseAuthManager()
//        
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty else {
//            displayErrorMessage("Please fill in all fields.")
//            return
//        }
//        
//        loginManager.loginUserWithEmailAndPassword(email: email, password: password) { [weak self] (success, error) in
//            guard let self = self else { return }
//            if success {
//                print("User logged in successfully")
//                // Proceed to the next screen or show success message
//            } else {
//                self.displayErrorMessage(error ?? "There was an error.")
//            }
//        }
//    }
//    
//    @objc private func registerLabelTapped() {
//        let registerVC = RegisterViewController()
//        navigationController?.pushViewController(registerVC, animated: true)
//    }
//    
//    internal func displayErrorMessage(_ message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//}
//
//extension LoginViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == emailTextField {
//            if isValidEmail(email: textField.text ?? "") {
//                print("Valid email address")
//            } else {
//                print("Invalid email address")
//                displayErrorMessage("Invalid email format")
//            }
//        }
//    }
//    
//    func isValidEmail(email: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: email)
//    }
//}
//
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Giriş Yap"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = Colors.totalBackgroundColor
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.totalBackgroundColor
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
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
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
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
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
