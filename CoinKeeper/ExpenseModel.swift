import Foundation

class DataSource{
    static let shared = DataSource()
    
    var expenses: [ExpenseModel] = []
    
    private init() {
        createInitialObjects()
    }
    
    private func createInitialObjects() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let allExpenses: [ExpenseModel] = [
            ExpenseModel(expense: "Credit", date: Date(), money: 100, isExpense: true),
            ExpenseModel(expense: "Shopping", date: dateFormatter.date(from: "2023-08-10 12:30")!, money: 100, isExpense: true),
            ExpenseModel(expense: "Shopping", date: dateFormatter.date(from: "2023-08-09 12:00")!, money: 100, isExpense: true),
            ExpenseModel(expense: "Coffee", date: dateFormatter.date(from: "2023-08-07 12:30")!, money: 15, isExpense: true),
            ExpenseModel(expense: "Products", date: dateFormatter.date(from: "2023-08-06 12:30")!, money: 50, isExpense: true),
            ExpenseModel(expense: "Shopping", date: dateFormatter.date(from: "2023-08-05 12:30")!, money: 10, isExpense: true),
            ExpenseModel(expense: "Coffee", date: dateFormatter.date(from: "2023-08-03 12:30")!, money: 15, isExpense: true),
            ExpenseModel(expense: "Products", date: dateFormatter.date(from: "2023-08-03 12:30")!, money: 50, isExpense: true),
            ExpenseModel(expense: "Coffee", date: dateFormatter.date(from: "2023-08-04 12:30")!, money: 15, isExpense: true),
            ExpenseModel(expense: "Salary", date: dateFormatter.date(from: "2023-08-10 12:30")!, money: 1400, isExpense: false),
            ExpenseModel(expense: "Business", date: dateFormatter.date(from: "2023-08-09 12:30")!, money: 500, isExpense: false),
            ExpenseModel(expense: "Salary", date: Date(), money: 1300, isExpense: false),
            ExpenseModel(expense: "Business", date: dateFormatter.date(from: "2023-08-07 12:30")!, money: 1500, isExpense: false),
            ExpenseModel(expense: "Salary", date: dateFormatter.date(from: "2023-08-06 12:30")!, money: 1200, isExpense: false),
            ExpenseModel(expense: "Salary", date: dateFormatter.date(from: "2023-08-05 12:30")!, money: 1100, isExpense: false),
            ExpenseModel(expense: "Salary", date: dateFormatter.date(from: "2023-08-04 12:30")!, money: 1000, isExpense: false),
            ExpenseModel(expense: "Salary", date: dateFormatter.date(from: "2023-08-01 12:30")!, money: 1200, isExpense: false),
            ExpenseModel(expense: "Salary", date: dateFormatter.date(from: "2023-08-02 12:30")!, money: 1100, isExpense: false),
            ExpenseModel(expense: "Salary", date: dateFormatter.date(from: "2023-08-03 12:30")!, money: 1000, isExpense: false),
            ExpenseModel(expense: "Coffee", date: dateFormatter.date(from: "2023-08-02 12:30")!, money: 15, isExpense: true),
            ExpenseModel(expense: "Products", date: dateFormatter.date(from: "2023-08-01 12:30")!, money: 50, isExpense: true),
            ExpenseModel(expense: "Coffee", date: dateFormatter.date(from: "2023-08-03 12:30")!, money: 15, isExpense: true),
            
        ]
        
        expenses.append(contentsOf: allExpenses)
    }
    
    func addDataObject(_ object: ExpenseModel) {
        expenses.append(object)
        NotificationCenter.default.post(name: NSNotification.Name("DataUpdated"), object: nil)
    }
}

struct ExpenseModel{
    var expense: String
    var date: Date
    var money: Double
    var isExpense: Bool
}



