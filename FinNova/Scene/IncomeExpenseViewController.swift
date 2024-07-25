//
//  IncomeExpenseViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import UIKit
import Charts
import DGCharts

class IncomeExpenseChartViewController: UIViewController {
    
    var barChartView: BarChartView!
    private let budgetItems: [(title: String, date: String, amount: String)] = [
        ("Shopping", "10 Jan 2022", "$544"),
        ("Restaurant", "11 Jan 2022", "$54,417.80")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gelir-Gider Grafiği"
        view.backgroundColor = .white
        
        barChartView = BarChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barChartView)
        
        NSLayoutConstraint.activate([
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            barChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            barChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        setChartData()
    }
    
    func setChartData() {
        var incomeEntries: [BarChartDataEntry] = []
        var expenseEntries: [BarChartDataEntry] = []
        var dates: [String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        var dateToIndex: [String: Double] = [:]
        var currentIndex: Double = 0
        
        for item in budgetItems {
            if dateToIndex[item.date] == nil {
                dateToIndex[item.date] = currentIndex
                dates.append(item.date)
                currentIndex += 1
            }
            
            if let amount = Double(item.amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) {
                if item.title.lowercased().contains("income") {
                    incomeEntries.append(BarChartDataEntry(x: dateToIndex[item.date]!, y: amount))
                } else {
                    expenseEntries.append(BarChartDataEntry(x: dateToIndex[item.date]!, y: amount))
                }
            }
        }
        
        let incomeDataSet = BarChartDataSet(entries: incomeEntries, label: "Gelir")
        incomeDataSet.colors = [UIColor.systemGreen]
        
        let expenseDataSet = BarChartDataSet(entries: expenseEntries, label: "Gider")
        expenseDataSet.colors = [UIColor.systemRed]
        
        let data = BarChartData(dataSets: [incomeDataSet, expenseDataSet])
        barChartView.data = data
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        barChartView.xAxis.granularity = 1
        
        barChartView.animate(yAxisDuration: 1.5)
    }
}
