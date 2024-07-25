//
//  BudgetDetailViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import UIKit

final class BudgetDetailViewController: UITableViewController {

    var data: BudgetItem?
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
        loadBudgetItems()
        initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchBudgets()
    }
    
    private func initBindings() {
        viewModel?.succesCompletion = { [weak self] success in
            self?.data = success
            print(success)
        }
        viewModel?.failCompleetion = { [weak self] in
            DispatchQueue.main.async {
                     // ErrorHandleViewBuilder.showError(from: self)
                 }
            //ErrorHandleViewBuilder.showError(from: self)
        }
    }

    private func loadBudgetItems() {
        let jsonString = """
        [
            {"title": "Shopping", "date": "10 Jan 2022", "amount": "$544"},
            {"title": "Restaurant", "date": "11 Jan 2022", "amount": "$54,417.80"},
            {"title": "dfwdf", "date": "fe Jan 2022", "amount": "$dflsöf.80"}
        ]
        """
        
        let jsonData = Data(jsonString.utf8)
        do {
            budgetItems = try JSONDecoder().decode([BudgetItem].self, from: jsonData)
            groupBudgetItemsByDate()
            tableView.reloadData()
        } catch {
            print("Failed to decode JSON")
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
            cell.configure(title: item.type, date: item.date, amount: item.amount)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
