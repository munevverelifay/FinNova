//
//  QuoteView.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import UIKit

class QuoteView: UIView {
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.layer.insertSublayer(getGradientLayer(bounds: CGRect(x: 0, y: 0, width: 50, height: 50)), at: 0)
        return view
    }()
    
    private static func getGradientLayer(bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor(red: 99/255, green: 119/255, blue: 130/255, alpha: 1).cgColor,
                           UIColor(red: 129/255, green: 178/255, blue: 202/255, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "dollarBagIcon")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "Create a Saving goal"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.text = "Lorem ipsum dolor sit amet cdgvsıjnkmocjoefje efkmkfecmkefmvepl pdcllwölölwöfr kpmcfkplmöwdlöcw"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 8
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            
            iconContainerView.widthAnchor.constraint(equalToConstant: 60),
            iconContainerView.heightAnchor.constraint(equalToConstant: 60),
            iconContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            iconContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: -15),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        
        ])
    }
}

