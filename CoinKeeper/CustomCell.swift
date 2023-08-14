import UIKit

class CustomCell: UITableViewCell {

    static let identifier = "CustomCell"
    
    let colors: [UIColor] = [
        UIColor.purple,
        UIColor(hex:"#5765eb", alpha: 1.0)!,
        UIColor.blue,
        UIColor.systemBlue,
        UIColor(hex: "#95d6fc", alpha: 1.0)!
    ]
    
    private let circleView: UIView = {
        let circle = UIView()
        circle.backgroundColor =  UIColor(hex:"#5765eb", alpha: 1.0)
        circle.layer.cornerRadius = 25
        circle.layer.masksToBounds = true
        return circle
    }()
    
    private let letterInTheCircle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#334453", alpha: 1.0)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let expenseMoneyLabel: UILabel = {
        let label = UILabel()
//        label.textColor = UIColor(hex: "#334453", alpha: 1.0)
        
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let expenseTime: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label .textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(expense: ExpenseModel, index: Int){
        let firstLetter = expense.expense.prefix(1)
        letterInTheCircle.text = String(firstLetter)
        if index<5{
            circleView.backgroundColor = colors[index]
        }
        else{
            circleView.backgroundColor = colors[index%5]
        }
        expenseLabel.text = expense.expense
        if expense.isExpense {
            expenseMoneyLabel.textColor = .red
            expenseMoneyLabel.text = "-$\(expense.money)"
        }
        else{
            expenseMoneyLabel.textColor = .systemGreen
            expenseMoneyLabel.text = "+$\(expense.money)"
        }
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = dateFormatter.string(from: expense.date)
        expenseTime.text = formattedDate
        
    }
    
    private func setUp(){
        contentView.addSubview(circleView)
        contentView.addSubview(letterInTheCircle)
        contentView.addSubview(expenseLabel)
        contentView.addSubview(expenseMoneyLabel)
        contentView.addSubview(expenseTime)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        letterInTheCircle.translatesAutoresizingMaskIntoConstraints = false
        letterInTheCircle.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
        letterInTheCircle.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
        letterInTheCircle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        letterInTheCircle.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
//        expenseLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        expenseLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        expenseLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 15).isActive = true
        expenseLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        expenseTime.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        expenseMoneyLabel.translatesAutoresizingMaskIntoConstraints = false
        expenseMoneyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        expenseMoneyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        expenseMoneyLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        expenseMoneyLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        expenseTime.translatesAutoresizingMaskIntoConstraints = false
        expenseTime.topAnchor.constraint(equalTo: expenseMoneyLabel.bottomAnchor, constant: 5).isActive = true
        expenseTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        expenseTime.widthAnchor.constraint(equalToConstant: 200).isActive = true
        expenseTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //expenseTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }

}
