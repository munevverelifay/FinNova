//
//  FinanceItemView.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 24.07.2024.
//

import UIKit //renk ve sayılar için struct

class FinanceItemView: UIView {
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.white
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 25
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        self.addSubview(amountLabel)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            iconContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            iconContainerView.widthAnchor.constraint(equalToConstant: 50),
            iconContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17),
            
            amountLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6),
            amountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
        ])
    }
    
    func configure(icon: UIImage?, backgroundColor: UIColor, iconBackgroundColor: UIColor, amount: Double, title: String) {
        iconImageView.image = icon
        iconContainerView.backgroundColor = iconBackgroundColor
        amountLabel.text = "$\(String(format: "%.2f", amount))"
        titleLabel.text = title
        self.backgroundColor = backgroundColor
    }
}

