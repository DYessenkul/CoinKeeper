import UIKit

class HomeViewController: UIViewController{
    
    
    var expenses = [ExpenseModel]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.allowsSelection = true
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "Darkhan"
        label.textColor = UIColor(hex: "#334453", alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let calendar: UIImageView = {
        let calendar = UIImageView(image: UIImage(systemName: "person"))
        calendar.tintColor = UIColor(hex: "#334453", alpha: 1.0)
        return calendar
    }()
    
    private let someView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#292d32", alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private let totalBalanceLabel: UILabel = {
        let balance = UILabel()
        balance.text = "Total Balance"
        balance.textColor = .white
        balance.font = UIFont.boldSystemFont(ofSize: 16)
        balance.textAlignment = .center
        return balance
    }()
    
    private let balance: UILabel = {
        let balance = UILabel()
        balance.textColor = .white
        balance.font = UIFont.boldSystemFont(ofSize: 30)
        balance.textAlignment = .center
        return balance
    }()
    
    private let transactionLabel: UILabel = {
        let label = UILabel()
        label.text = "Transactions"
        label.textColor = UIColor(hex: "#334453", alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Income"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let expensesLabel: UILabel = {
        let label = UILabel()
        label.text = "Expenses"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let arrowUp: UIImageView = {
        let arrow = UIImageView(image: UIImage(systemName: "arrow.up.circle.fill"))
        arrow.tintColor = .green
        return arrow
    }()
    
    private let arrowDown: UIImageView = {
        let arrow = UIImageView(image: UIImage(systemName: "arrow.down.circle.fill"))
        arrow.tintColor = .red
        return arrow
    }()
    
    private let incomeMoney: UILabel = {
        let label = UILabel()
        label.text = "2500.00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let outcomeMoney: UILabel = {
        let label = UILabel()
        label.text = "800.00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(hex: "#4753f2", alpha: 1.0)?.cgColor as Any,
            UIColor(hex: "#5765eb",alpha: 1.0)?.cgColor as Any,
            UIColor.systemPurple.cgColor
            
        ]
        gradient.locations = [0, 0.25, 0.75 ,1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    
    var totalExpense: Double = 0
    var totalIncome: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wallet"
        view.backgroundColor = .secondarySystemBackground
        subviews()
        setUp()
        gradient.frame = view.bounds
        someView.layer.addSublayer(gradient)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: NSNotification.Name("DataUpdated"), object: nil)
        expenses = DataSource.shared.expenses.sorted { $0.date > $1.date }
        totalMoney(expenses: expenses)
        
    }

    @objc func updateTableView() {
        expenses = DataSource.shared.expenses.sorted { $0.date > $1.date }
        totalMoney(expenses: expenses)
        tableView.reloadData()
    }
    
    
    
    func totalMoney(expenses: [ExpenseModel]){
        var totalExpense: Double = 0
        var totalIncome: Double = 0
        for expense in expenses {
            if expense.isExpense{
                totalExpense += expense.money
            }
            else{
                totalIncome += expense.money
            }
        }
        outcomeMoney.text = "\(totalExpense)"
        incomeMoney.text = "\(totalIncome)"
        let totalBalance = totalIncome-totalExpense
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        if let formattedString = numberFormatter.string(from: NSNumber(value: totalBalance)) {
            let finalString = "$" + formattedString
            balance.text = "\(finalString)"
        }
    }
    
    
    func subviews(){
        view.addSubview(welcomeLabel)
        view.addSubview(userName)
        view.addSubview(someView)
        view.addSubview(calendar)
        view.addSubview(balance)
        view.addSubview(totalBalanceLabel)
        view.addSubview(transactionLabel)
        view.addSubview(incomeLabel)
        view.addSubview(expensesLabel)
        view.addSubview(arrowUp)
        view.addSubview(arrowDown)
        view.addSubview(incomeMoney)
        view.addSubview(outcomeMoney)
        view.addSubview(tableView)
    }
    
    func setUp(){
        let safeArea = view.safeAreaLayoutGuide
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 5).isActive = true
        userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        someView.translatesAutoresizingMaskIntoConstraints = false
        someView.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10).isActive = true
        someView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        someView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        someView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        balance.translatesAutoresizingMaskIntoConstraints = false
        balance.topAnchor.constraint(equalTo: totalBalanceLabel.bottomAnchor, constant: 10).isActive = true
        balance.centerXAnchor.constraint(equalTo: someView.centerXAnchor).isActive = true
        balance.widthAnchor.constraint(equalToConstant: 200).isActive = true
        balance.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalBalanceLabel.topAnchor.constraint(equalTo: someView.topAnchor, constant: 15).isActive = true
        totalBalanceLabel.centerXAnchor.constraint(equalTo: someView.centerXAnchor).isActive = true
        totalBalanceLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        totalBalanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        transactionLabel.translatesAutoresizingMaskIntoConstraints = false
        transactionLabel.topAnchor.constraint(equalTo: someView.bottomAnchor, constant: 20).isActive = true
        transactionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        transactionLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        transactionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        incomeLabel.topAnchor.constraint(equalTo: balance.bottomAnchor, constant: 20).isActive = true
        incomeLabel.leadingAnchor.constraint(equalTo: someView.leadingAnchor, constant: 50).isActive = true
        incomeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        incomeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        expensesLabel.translatesAutoresizingMaskIntoConstraints = false
        expensesLabel.topAnchor.constraint(equalTo: balance.bottomAnchor, constant: 20).isActive = true
        expensesLabel.leadingAnchor.constraint(equalTo: incomeLabel.trailingAnchor, constant: 100).isActive = true
        expensesLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        expensesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        arrowUp.translatesAutoresizingMaskIntoConstraints = false
        arrowUp.topAnchor.constraint(equalTo: balance.bottomAnchor, constant: 25).isActive = true
        arrowUp.trailingAnchor.constraint(equalTo: incomeLabel.leadingAnchor, constant: -5).isActive = true
        arrowUp.widthAnchor.constraint(equalToConstant: 30).isActive = true
        arrowUp.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        arrowDown.translatesAutoresizingMaskIntoConstraints = false
        arrowDown.topAnchor.constraint(equalTo: balance.bottomAnchor, constant: 25).isActive = true
        arrowDown.trailingAnchor.constraint(equalTo: expensesLabel.leadingAnchor, constant: -5).isActive = true
        arrowDown.widthAnchor.constraint(equalToConstant: 30).isActive = true
        arrowDown.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        incomeMoney.translatesAutoresizingMaskIntoConstraints = false
        incomeMoney.topAnchor.constraint(equalTo: incomeLabel.bottomAnchor, constant: 3).isActive = true
        incomeMoney.leadingAnchor.constraint(equalTo: someView.leadingAnchor, constant: 50).isActive = true
        incomeMoney.widthAnchor.constraint(equalToConstant: 100).isActive = true
        incomeMoney.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        outcomeMoney.translatesAutoresizingMaskIntoConstraints = false
        outcomeMoney.topAnchor.constraint(equalTo: expensesLabel.bottomAnchor, constant: 3).isActive = true
        outcomeMoney.leadingAnchor.constraint(equalTo: incomeLabel.trailingAnchor, constant: 100).isActive = true
        outcomeMoney.widthAnchor.constraint(equalToConstant: 80).isActive = true
        outcomeMoney.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: transactionLabel.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {fatalError("The tableview could not dequeue a CustomCell")}
        let expense = expenses[indexPath.section]
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            expenses.remove(at: indexPath.section)
            DataSource.shared.expenses.removeAll()
            DataSource.shared.expenses.append(contentsOf: expenses)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            totalMoney(expenses: expenses)
            if DataSource.shared.expenses.isEmpty{
                let defaultExpenses = [ExpenseModel(expense: "No expenses", date: Date(), money: 1, isExpense: true),
                     ExpenseModel(expense: "No incomes", date: Date(), money: 1, isExpense: false)]
                DataSource.shared.expenses.append(contentsOf: defaultExpenses)
                tableView.reloadData()
            }
            
        }
        
    }
    
}


