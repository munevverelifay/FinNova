//
//  TotalAmountView.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 24.07.2024.
//

import UIKit

final class TotalAmountView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Toplam"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = Colors.totalBackgroundColor
        self.layer.cornerRadius = 20
        
        self.addSubview(titleLabel)
        self.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configure(amount: Double) {
        amountLabel.text = "$\(String(format: "%.2f", amount))"
    }
}
