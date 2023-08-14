import UIKit


class StatsViewController: UIViewController{
    
    var dataPoints: [String] = []
    var expensesRate: [Double] = []
    var expensesForTable: [ExpenseModel] = []
    var expenses = [ExpenseModel]()
    
    let someLabel = UILabel()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.allowsSelection = true
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableView
    }()
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Income", "Expenses"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentTintColor =  UIColor(hex: "#334453", alpha: 1.0)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#334453", alpha: 1.0)!], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return segmentControl
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Analytics"
        view.backgroundColor = .secondarySystemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: NSNotification.Name("DataUpdated"), object: nil)
        expenses = DataSource.shared.expenses
        setupValues()
        setupInitialUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        expenses.removeAll()
        expenses = DataSource.shared.expenses
        updateBarChart()
        tableView.reloadData()
    }

    @objc func updateTableView() {
        expenses = DataSource.shared.expenses
        updateBarChart()
        tableView.reloadData()
    }
    
    @objc func segmentControlValueChanged() {
        let selectedSegmentIndex = segmentControl.selectedSegmentIndex
        if selectedSegmentIndex == 0 {
            someLabel.text = "Incomes in last 7 day"
        }
        else{
            someLabel.text = "Expenses in last 7 day"
        }
        updateBarChart()
        tableView.reloadData()
    }
    
    func setupInitialUI() {
        setupTableView()
        setupSegmentControl()
        createBarChartWithData()
        someLabel.text = "Incomes in last 7 day"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
    }
    
    func setupValues(){
        let selectedSegmentIndex = segmentControl.selectedSegmentIndex
        expensesForTable.removeAll()
        if selectedSegmentIndex == 0 {
            expensesForTable = printExpensesForLast7Days(allExpenses: expenses).filter{ !$0.isExpense }
            let last7incomeSum = getSumOfIncomesByDay(lastDays: 7, allExpenses: DataSource.shared.expenses)
            let sortedIncomes = last7incomeSum.sorted(by: { $0.key > $1.key})
            let sortedIncomesDict = Dictionary(uniqueKeysWithValues: sortedIncomes)
            printLast7DaysWithValues(sortedIncomesDict)
        }
        else{
            expensesForTable = printExpensesForLast7Days(allExpenses: expenses).filter{ $0.isExpense }
            let last7ExpenseSum = getSumOfExpensesByDay(lastDays: 7, allExpenses: DataSource.shared.expenses)
            let sortedExpenses = last7ExpenseSum.sorted(by: { $0.key > $1.key})
            let sortedExpensesDict = Dictionary(uniqueKeysWithValues: sortedExpenses)
            printLast7DaysWithValues(sortedExpensesDict)
        }
    }
    
    func setupSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            segmentControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createBarChartWithData(){
        let barChartView = createBarChartView()
        barChartView.tag = 123
        view.addSubview(barChartView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            barChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            barChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            barChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -430),
            barChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            barChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: barChartView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func createBarChartView() -> UIView {
        let barChartView = UIView()
        barChartView.backgroundColor = .white
        barChartView.layer.cornerRadius = 20
        barChartView.layer.masksToBounds = true
        let barWidth: CGFloat = 40
        let space: CGFloat = 10
        let maxValue = expensesRate.max() ?? 100
        
        let totalWidth = CGFloat(dataPoints.count) * (barWidth + space) - space
        let availableWidth = min(totalWidth, view.bounds.width - 40)
        let spaceToDistribute = availableWidth - totalWidth
        
        let spaceOnEachSide = spaceToDistribute / 2
        
        for (index, value) in expensesRate.enumerated() {
            let xPosition = spaceOnEachSide + (barWidth + space) * CGFloat(index)
            let height = CGFloat(value) / CGFloat(maxValue) * 150
            let barView = UIView(frame: CGRect(x: xPosition, y: 200, width: barWidth, height: 0))
            barView.backgroundColor = UIColor(hex:"#5765eb", alpha: 1.0)
            barChartView.addSubview(barView)
            
            UIView.animate(withDuration: 1.0, delay: 0.2 * Double(index), options: .curveEaseOut, animations: {
                barView.frame = CGRect(x: xPosition, y: 200 - height, width: barWidth, height: height)
            }, completion: nil)
            
            let label = UILabel(frame: CGRect(x: xPosition, y: 210, width: barWidth, height: 20))
            label.text = dataPoints[index]
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            barChartView.addSubview(label)
            let dataPoint = UILabel(frame: CGRect(x: Int(xPosition), y: 185, width: Int(barWidth), height: 10))
            dataPoint.textColor = .black
            if expensesRate[index]>9999{
                dataPoint.text = "\(expensesRate[index]/1000)K"
            }
            else{
                dataPoint.text = String(Int(expensesRate[index]))
            }
            dataPoint.textAlignment = .center
            dataPoint.font = UIFont.systemFont(ofSize: 12)
            barChartView.addSubview(dataPoint)
            
        }
        
        barChartView.frame = CGRect(x: 0, y: 0, width: availableWidth, height: 200)
        someLabel.textColor = .black
        someLabel.font = UIFont.boldSystemFont(ofSize: 18)
        barChartView.addSubview(someLabel)
        someLabel.translatesAutoresizingMaskIntoConstraints = false
        someLabel.topAnchor.constraint(equalTo: barChartView.topAnchor, constant: 10).isActive = true
        someLabel.centerXAnchor.constraint(equalTo: barChartView.centerXAnchor).isActive = true
        return barChartView
    }
    
    func updateBarChart() {
        if let existingBarChartView = view.viewWithTag(123) {
            existingBarChartView.removeFromSuperview()
        }
        setupValues()
        createBarChartWithData()
    }
    
    func printExpensesForLast7Days(allExpenses: [ExpenseModel]) -> [ExpenseModel] {
        let currentDate = Date()
        let calendar = Calendar.current
        var expensesOnDay = [ExpenseModel]()
        var expenses = [ExpenseModel]()
        for i in 0..<7 {
            if let previousDate = calendar.date(byAdding: .day, value: -i, to: currentDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d"
                _ = dateFormatter.string(from: previousDate)
                
                expensesOnDay = allExpenses
                    .filter { calendar.isDate($0.date, inSameDayAs: previousDate) }
                    .sorted(by: { $0.date > $1.date })
                
                expenses.append(contentsOf: expensesOnDay)
                
            }
        }
        return expenses
    }
    
    func getSumOfIncomesByDay(lastDays: Int, allExpenses: [ExpenseModel]) -> [String: Double] {
        let currentDate = Date()
        let daysAgo = Calendar.current.date(byAdding: .day, value: -lastDays, to: currentDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "en_US")
        var incomesByDay: [String: Double] = [:]
        
        for income in allExpenses {
            if income.date >= daysAgo && income.date <= currentDate {
                let dateString = dateFormatter.string(from: income.date)
                var moneys = [Double]()
                if !income.isExpense{
                    moneys.append(income.money)
                }
                let amount = moneys.reduce(0, +)
                incomesByDay[dateString, default: 0] += amount
            }
        }
        return incomesByDay
    }
    
    func getSumOfExpensesByDay(lastDays: Int, allExpenses: [ExpenseModel]) -> [String: Double] {
        let currentDate = Date()
        let daysAgo = Calendar.current.date(byAdding: .day, value: -lastDays, to: currentDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "en_US")
        var expensesByDay: [String: Double] = [:]
        
        for expense in allExpenses {
            if expense.date >= daysAgo && expense.date <= currentDate {
                let dateString = dateFormatter.string(from: expense.date)
                var moneys = [Double]()
                if expense.isExpense{
                    moneys.append(expense.money)
                }
                let amount = moneys.reduce(0, +)
                expensesByDay[dateString, default: 0] += amount
            }
        }
        return expensesByDay
    }
    
    func printLast7DaysWithValues(_ valuesDict: [String: Double]){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "en_US")
        expensesRate.removeAll()
        dataPoints.removeAll()
        let currentDate = Date()
        let calendar = Calendar.current
        for i in 0..<7 {
            if let previousDate = calendar.date(byAdding: .day, value: -i, to: currentDate) {
                let dayKey = dateFormatter.string(from: previousDate)
                if let value = valuesDict[dayKey] {
                    expensesRate.append(value)
                    dataPoints.append(dayKey)
                    
                } else {
                    let zero = 0.0
                    expensesRate.append(zero)
                    dataPoints.append(dayKey)
                }
            }
        }
        expensesRate.reverse()
        dataPoints.reverse()
    }
    
}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expensesForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {fatalError("The tableview could not dequeue a CustomCell")}
        
        let expense = expensesForTable[indexPath.section]
        cell.configure(expense: expense, index: indexPath.section)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

