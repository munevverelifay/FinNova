//
//  IncomeExpenseViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//

import UIKit
import DGCharts

final class IncomeExpenseChartViewController: UIViewController {
    
    var data: Currency?
    
    var viewModel: IncomeExpenseViewModel?
    
    private let budgetItems: [(title: String, date: String, amount: String)] = [
        ("Shopping", "10 Jan 2022", "$544"),
        ("Restaurant", "11 Jan 2022", "$54,417.80"),
        ("Salary", "13 Feb 2022", "$67,124.80")
    ]
    
    private let exchangeRates: [String: Double] = [
        "TRY": 1.0,
        "USD": 8.45,
        "EUR": 10.13
    ]
    
    var selectedCurrency: String = "TRY"
    
    var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        return barChartView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var totalAmountView: TotalAmountView = {
        let totalAmountView = TotalAmountView()
        totalAmountView.translatesAutoresizingMaskIntoConstraints = false
        return totalAmountView
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["TRY", "USD", "EUR"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    init(viewModel: IncomeExpenseViewModel? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gelir-Gider Grafiği"
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        updateViews()
        initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel?.fetchCurrency()
    }
    
    private func initBindings() {
        viewModel?.succesCompletion = { [weak self] success in
            self?.data = success
        }
        viewModel?.failCompleetion = { [weak self]  in
            //ErrorHandleViewBuilder.showError(from: self)
        }
    }
    
    private func setupViews() {
        view.addSubview(segmentControl)
        view.addSubview(barChartView)
        view.addSubview(stackView)
        view.addSubview(totalAmountView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            barChartView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            barChartView.heightAnchor.constraint(equalToConstant: 300),
            
            stackView.topAnchor.constraint(equalTo: barChartView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            
            totalAmountView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            totalAmountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalAmountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            totalAmountView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func segmentChanged() {
        selectedCurrency = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex) ?? "TRY"
        updateViews()
    }
    
    private func updateViews() {
        setChartData()
        updateFinanceItemViews()
        updateTotalAmountView()
    }
    
    private func setChartData() {
        var entries: [BarChartDataEntry] = []
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
            
            if var amount = Double(item.amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) {
                amount = amount / (exchangeRates[selectedCurrency] ?? 1.0)
                entries.append(BarChartDataEntry(x: dateToIndex[item.date]!, y: amount))
            }
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "Gelir-Gider")
        dataSet.colors = entries.map { $0.y >= 0 ? UIColor.systemGreen : UIColor.systemRed }
        dataSet.valueColors = [.black]
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.3
        barChartView.data = data
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelRotationAngle = -45
        
        barChartView.leftAxis.axisMinimum = entries.map { $0.y }.min()! * 1.1
        barChartView.leftAxis.axisMaximum = entries.map { $0.y }.max()! * 1.1
        
        barChartView.rightAxis.enabled = false
        
        barChartView.animate(yAxisDuration: 1.5)
        barChartView.legend.enabled = false
        barChartView.setVisibleXRangeMaximum(4)
        barChartView.moveViewToX(currentIndex / 2)
    }
    
    private func updateFinanceItemViews() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let totalIncome = budgetItems.filter { $0.amount.contains("$") }.map {
            Double($0.amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0
        }.reduce(0, +) / (exchangeRates[selectedCurrency] ?? 1.0)
        
        let totalExpense = budgetItems.filter { $0.amount.contains("-$") }.map {
            Double($0.amount.replacingOccurrences(of: "-$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0
        }.reduce(0, +) / (exchangeRates[selectedCurrency] ?? 1.0)
        
        let incomeView = createFinanceItemView(icon: UIImage(named: "incomeIcon"), backgroundColor: Colors.incomeBackgroundColor, iconBackgroundColor: Colors.incomeIconBackgroundColor, amount: totalIncome, title: "Income")
        let expenseView = createFinanceItemView(icon: UIImage(named: "expenseIcon"), backgroundColor: Colors.expenseBackgroundColor, iconBackgroundColor: Colors.expenseIconBackgroundColor, amount: totalExpense, title: "Expense")
        
        stackView.addArrangedSubview(incomeView)
        stackView.addArrangedSubview(expenseView)
    }
    
    private func updateTotalAmountView() {
        let totalAmount = budgetItems.map {
            Double($0.amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0
        }.reduce(0, +) / (exchangeRates[selectedCurrency] ?? 1.0)
        
        totalAmountView.configure(amount: totalAmount)
    }
    
    private func createFinanceItemView(icon: UIImage?, backgroundColor: UIColor, iconBackgroundColor: UIColor, amount: Double, title: String) -> FinanceItemView {
        let financeItemView = FinanceItemView()
        financeItemView.configure(icon: icon, backgroundColor: backgroundColor, iconBackgroundColor: iconBackgroundColor, amount: amount, title: title)
        return financeItemView
    }
}
