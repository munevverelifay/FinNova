//
//  BudgetDetailViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import UIKit

final class BudgetDetailViewController: UITableViewController {

    var data: [BudgetItem] = []
    var viewModel: BudgetsViewModel?
    var budgetItems: [BudgetItem] = []
    var groupedBudgetItems: [String: [BudgetItem]] = [:]
    var sortedDates: [String] = []
    
    init(viewModel: BudgetsViewModel? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gelir/Giderler"
        tableView.register(BudgetItemCell.self, forCellReuseIdentifier: "BudgetItemCell")
        initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchBudgets()
    }
    
    private func initBindings() {
        viewModel?.succesCompletion = { [weak self] success in
            self?.budgetItems = success
            self?.groupBudgetItemsByDate()
            self?.tableView.reloadData()
        }
        viewModel?.failCompletion = { [weak self] in
            DispatchQueue.main.async {
                // Error handling
            }
        }
    }


    private func groupBudgetItemsByDate() {
        groupedBudgetItems = Dictionary(grouping: budgetItems, by: { $0.date })
        sortedDates = groupedBudgetItems.keys.sorted(by: { date1, date2 -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            if let d1 = dateFormatter.date(from: date1), let d2 = dateFormatter.date(from: date2) {
                return d1 < d2
            }
            return false
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = sortedDates[section]
        return groupedBudgetItems[date]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetItemCell", for: indexPath) as! BudgetItemCell
        let date = sortedDates[indexPath.section]
        if let items = groupedBudgetItems[date] {
            let item = items[indexPath.row]
            var amount = item.amount
            if item.type == "income" {
                amount = "+\(item.amount)"
            } else if item.type == "expense" {
                amount = "-\(item.amount)"
            }
            cell.configure(title: item.source, date: item.date, amount: amount)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
