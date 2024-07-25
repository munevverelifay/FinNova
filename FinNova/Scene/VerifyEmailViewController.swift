//
//  VerifyEmailViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//


import UIKit
import FirebaseAuth

class VerifyEmailViewController: UIViewController {
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mail Adresiniz"
        textField.backgroundColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemPink
        button.setTitle("Doğrula", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var verifiedButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemOrange
        button.setTitle("Doğrulandı", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(verifiedButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 30
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(verifyButton)
        stackView.addArrangedSubview(verifiedButton)
        
        setupConstraints()
        
        emailTextField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            verifyButton.heightAnchor.constraint(equalToConstant: 44),
            verifiedButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func verifyButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            displayErrorMessage("Please enter your email.")
            return
        }
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "neonappsauth-eeef2.firebaseapp.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error sending verification email: \(error.localizedDescription)")
                self.displayErrorMessage("Error sending verification email: \(error.localizedDescription)")
            } else {
                print("Verification email sent successfully.")
            }
        })
    }
    
    @objc private func verifiedButtonTapped() {
        FirebaseAuthManager().isEmailVerified { [weak self] (isVerified) in
            guard let self = self else { return }
            
            if isVerified {
                let homeVC = HomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            } else {
                self.displayErrorMessage("Email is not verified.")
            }
        }
    }
    
    private func displayErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension VerifyEmailViewController: UITextFieldDelegate {
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
