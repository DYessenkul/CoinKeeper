import UIKit
import Foundation


class AddExpenseViewController: UIViewController {
    
    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = UIColor(hex: "#334453", alpha: 1.0)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Expense"
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#334453", alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private let moneyTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write the amount"
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 22)
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.textColor = UIColor(hex: "#334453", alpha: 1.0)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let expenseNoteTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Note"
        textField.textAlignment = .left
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.textColor = UIColor(hex: "#334453", alpha: 1.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    
    private let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.locale = Locale(identifier: "en_US")
        date.datePickerMode = .dateAndTime
        date.preferredDatePickerStyle = .compact
        return date
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Income", "Expense"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentTintColor =  UIColor(hex: "#334453", alpha: 1.0)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#334453", alpha: 1.0)!], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        return segmentControl
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(hex: "#334453", alpha: 1.0)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Expenses"
        view.backgroundColor = UIColor(hex: "#e3e7fa", alpha: 1.0)
        subviews()
        setUp()
        returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        
    }
    
    @objc func segmentControlValueChanged() {
        let selectedSegmentIndex = segmentControl.selectedSegmentIndex
        print("Selected Segment: \(selectedSegmentIndex)")
    }
    
    @objc func returnButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc func addButtonTapped(){
        guard let expense = expenseNoteTF.text,
              let money = Double(moneyTF.text ?? "0") else {
            return
        }
        let date = datePicker.date
        if segmentControl.selectedSegmentIndex == 1{
            let newExpense = ExpenseModel(expense: expense, date: date, money: money, isExpense: true)
            DataSource.shared.addDataObject(newExpense)
            DataSource.shared.expenses.sort { $0.date > $1.date}
        }
        else {
            let newExpense = ExpenseModel(expense: expense, date: date, money: money, isExpense: false)
            DataSource.shared.addDataObject(newExpense)
            DataSource.shared.expenses.sort { $0.date > $1.date}
        }
        
        
        dismiss(animated: true)
        
    }
    
    func subviews(){
        view.addSubview(returnButton)
        view.addSubview(titleLabel)
        view.addSubview(moneyTF)
        view.addSubview(expenseNoteTF)
        view.addSubview(datePicker)
        view.addSubview(segmentControl)
        view.addSubview(addButton)
        
        
    }
    
    func setUp(){
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        returnButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        returnButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        returnButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        moneyTF.translatesAutoresizingMaskIntoConstraints = false
        moneyTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        moneyTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moneyTF.widthAnchor.constraint(equalToConstant: 250).isActive = true
        moneyTF.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        expenseNoteTF.translatesAutoresizingMaskIntoConstraints = false
        expenseNoteTF.topAnchor.constraint(equalTo: moneyTF.bottomAnchor, constant: 20).isActive = true
        expenseNoteTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        expenseNoteTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        expenseNoteTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: expenseNoteTF.bottomAnchor, constant: 10).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
}
