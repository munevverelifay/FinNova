//
//  IncomeExpenseViewController.swift
//  FinNova
//
//  Created by Münevver Elif Ay on 25.07.2024.
//


import UIKit

final class IncomeExpenseChartViewController: UIViewController {
    
    var data: Currency?
    
    var viewModel: IncomeExpenseViewModel?
    
    private var exchangeRates: [String: Double] = [:]
    
    var totalMock: Double = 124.24
    var incomeMock: Double = 250.24
    var expenseMock: Double = 126.00
    var selectedCurrency: String = "TRY"
    var tryValue: Double?
    var usdValue: Double?
    var eurValue: Double?

    
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
        let segmentControl = UISegmentedControl(items: ["USD" ,"TRY", "EUR"])
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
        initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel?.fetchCurrency()
    }
    
    private func initBindings() {
        viewModel?.succesCompletion = { [weak self] success in
            self?.data = success
            
            guard let dataValues = self?.data?.data?.values else {
                return
            }
            
            for datum in dataValues {
                if let code = datum.code, let value = datum.value {
                    switch code {
                    case "TRY":
                        self?.tryValue = value
                    case "USD":
                        self?.usdValue = value
                    case "EUR":
                        self?.eurValue = value
                    default:
                        break
                    }
                }
            }
            
            if let tryValue = self?.tryValue, let usdValue = self?.usdValue, let eurValue = self?.eurValue {
                DispatchQueue.main.async {
                    self?.setupExchangeRates(tryValue: tryValue, usdValue: usdValue, eurValue: eurValue)
                }
            } else {
                print("Missing exchange rate values")
            }
        }
        
        viewModel?.failCompleetion = { [weak self] in
            DispatchQueue.main.async {
                     // ErrorHandleViewBuilder.showError(from: self)
                 }
            //ErrorHandleViewBuilder.showError(from: self)
        }
    }
    
    private func setupExchangeRates(tryValue: Double, usdValue: Double, eurValue: Double) {
        self.tryValue = tryValue
        self.usdValue = usdValue
        self.eurValue = eurValue
    }
    
    private func updateViews() {
        var selectedTotalValue: Double = 0.0
        var selectedIncomeValue: Double = 0.0
        var selectedExpenseValue: Double = 0.0
        
        switch selectedCurrency {
        case "TRY":
            selectedTotalValue = totalMock * (tryValue ?? 0.0)
            selectedIncomeValue = incomeMock * (tryValue ?? 0.0)
            selectedExpenseValue = expenseMock * (tryValue ?? 0.0)
        case "USD":
            selectedTotalValue = totalMock * (usdValue ?? 0.0)
            selectedIncomeValue = incomeMock * (usdValue ?? 0.0)
            selectedExpenseValue = expenseMock * (usdValue ?? 0.0)
        case "EUR":
            selectedTotalValue = totalMock * (eurValue ?? 0.0)
            selectedIncomeValue = incomeMock * (eurValue ?? 0.0)
            selectedExpenseValue = expenseMock * (eurValue ?? 0.0)
        default:
            break
        }
        
        print("Selected Currency: \(selectedCurrency), Value: \(selectedTotalValue)")
        
        // stackView içindeki view'leri kaldır
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Yeni incomeView ve expenseView oluştur
        let incomeView = createFinanceItemView(icon: UIImage(named: "incomeIcon"), backgroundColor: Colors.incomeBackgroundColor, iconBackgroundColor: Colors.incomeIconBackgroundColor, amount: selectedIncomeValue, title: "Gelir")
        
        let expenseView = createFinanceItemView(icon: UIImage(named: "expenseIcon"), backgroundColor: Colors.expenseBackgroundColor, iconBackgroundColor: Colors.expenseIconBackgroundColor, amount: -selectedExpenseValue, title: "Gider")
        
        stackView.addArrangedSubview(incomeView)
        stackView.addArrangedSubview(expenseView)
        totalAmountView.configure(amount: selectedTotalValue)
    }
    
    private func setupViews() {
        let incomeView = createFinanceItemView(icon: UIImage(named: "incomeIcon"), backgroundColor: Colors.incomeBackgroundColor, iconBackgroundColor: Colors.incomeIconBackgroundColor, amount: incomeMock, title: "Gelir")
        
        let expenseView = createFinanceItemView(icon: UIImage(named: "expenseIcon"), backgroundColor: Colors.expenseBackgroundColor, iconBackgroundColor: Colors.expenseIconBackgroundColor, amount: -expenseMock, title: "Gider")
        
        stackView.addArrangedSubview(incomeView)
        stackView.addArrangedSubview(expenseView)
        totalAmountView.configure(amount: totalMock)
        
        view.addSubview(segmentControl)
        view.addSubview(stackView)
        view.addSubview(totalAmountView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
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
        selectedCurrency = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex) ?? "USD"
        updateViews()
    }
    
    private func createFinanceItemView(icon: UIImage?, backgroundColor: UIColor, iconBackgroundColor: UIColor, amount: Double, title: String) -> FinanceItemView {
        let financeItemView = FinanceItemView()
        financeItemView.configure(icon: icon, backgroundColor: backgroundColor, iconBackgroundColor: iconBackgroundColor, amount: amount, title: title)
        return financeItemView
    }
}
