//
//  HomeViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 24.07.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalAmountView: TotalAmountView = {
        let totalAmountView = TotalAmountView()
        totalAmountView.translatesAutoresizingMaskIntoConstraints = false
        return totalAmountView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BudgetItemCell.self, forCellReuseIdentifier: "BudgetItemCell")
        return tableView
    }()
    
    private let budgetItems: [(title: String, date: String, amount: String, paymentMethod: String)] = [
        ("Shopping", "10 Jan 2022", "$544", "In Cash"),
        ("Restaurant", "11 Jan 2022", "$54,417.80", "Card")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ana Sayfa"
        setupView()
        setupFinanceItemViews()
        setupTotalAmountView()
        setupTableView()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(totalAmountView)
        view.addSubview(tableView)
    }
    
    private func setupFinanceItemViews() {
        let incomeView = createFinanceItemView(icon: .incomeIcon, backgroundColor: Colors.incomeBackgroundColor, iconBackgroundColor: Colors.incomeIconBackgroundColor, amount: 1800.0, title: "Income")
        let expenseView = createFinanceItemView(icon: .expenseIcon, backgroundColor: Colors.expenseBackgroundColor, iconBackgroundColor: Colors.expenseIconBackgroundColor, amount: 1800.0, title: "Expense")
        
        stackView.addArrangedSubview(incomeView)
        stackView.addArrangedSubview(expenseView)
        stackView.spacing = view.frame.width * 0.050
    }
    
    private func setupTotalAmountView() {
        totalAmountView.configure(amount: 2478.00)
    }
    
    private func createFinanceItemView(icon: UIImage?, backgroundColor: UIColor, iconBackgroundColor: UIColor, amount: Double, title: String) -> FinanceItemView {
        let financeItemView = FinanceItemView()
        financeItemView.configure(icon: icon, backgroundColor: backgroundColor, iconBackgroundColor: iconBackgroundColor, amount: amount, title: title)
        return financeItemView
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.01),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * 0.065),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width * 0.065),
            stackView.arrangedSubviews[0].heightAnchor.constraint(equalToConstant: view.frame.height * 0.20),
            stackView.arrangedSubviews[1].heightAnchor.constraint(equalToConstant: view.frame.height * 0.20),
            
            totalAmountView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            totalAmountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalAmountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            totalAmountView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: totalAmountView.bottomAnchor, constant: 20),
                       tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                       tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                       tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                   ])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetItemCell", for: indexPath) as! BudgetItemCell
        let item = budgetItems[indexPath.row]
        cell.configure(title: item.title, date: item.date, amount: item.amount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return "Gelir ve Giderler"
     }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            
            let button = UIButton(type: .system)
            button.setTitle("Tümünü Gör ->", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            footerView.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
                button.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
                button.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8)
            ])
            
            return footerView
        }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         return 30
     }
}
