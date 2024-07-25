//
//  RegisterViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 24.07.2024.
//
import UIKit

final class RegisterViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Kayıt Ol"
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
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Colors.totalBackgroundColor
        button.setTitle("Kayıt Ol", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Hesabınız var mı? Giriş Yapın"
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
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(loginLabel)
        
        setupConstraints()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped)))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func registerButtonTapped() {
        let signUpManager = FirebaseAuthManager()
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            displayErrorMessage("Please fill in all fields.")
            return
        }
        
        signUpManager.createUserWithEmailAndPassword(email: email, password: password) { [weak self] (success, error) in
            guard let self = self else { return }
            if success {
                let verifyEmailVC = VerifyEmailViewController()
                self.navigationController?.pushViewController(verifyEmailVC, animated: true)
            } else {
                self.displayErrorMessage(error ?? "There was an error.")
            }
        }
    }
    
    @objc private func loginLabelTapped() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func displayErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate {
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

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}
