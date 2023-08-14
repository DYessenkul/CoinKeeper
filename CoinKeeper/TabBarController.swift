import UIKit
import Foundation

class TabBarController: UITabBarController {
    
    let btnMiddle: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btn.setTitle("", for: .normal)
        //btn.backgroundColor = UIColor(hex: "#fe989b", alpha: 1.0)
        btn.backgroundColor = UIColor(hex: "#334453", alpha: 1.0)
        btn.layer.cornerRadius = 25
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeTabItems()
        btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 25, y: 0, width: 50, height: 50)
        btnMiddle.addTarget(self, action: #selector(openThirdViewController), for: .touchUpInside)
    }
    
    @objc func openThirdViewController() {

        let thirdVC = AddExpenseViewController()
        self.present(thirdVC, animated: true, completion: nil)
       }
    
    override func loadView() {
        super.loadView()
        self.tabBar.addSubview(btnMiddle)
        setUpCustomTabBar()
    }
    
    func setUpCustomTabBar(){
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor(hex: "#e3e7fa", alpha: 1.0)?.cgColor
        shape.fillColor = UIColor(hex: "#e3e7fa", alpha: 1.0)?.cgColor
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 180
        //self.tabBar.tintColor = UIColor(hex: "#fe989b", alpha: 1.0)
        self.tabBar.tintColor = UIColor(hex: "#334453", alpha: 1.0)
    }
    
    func addSomeTabItems(){
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: StatsViewController())
        vc1.title = "Wallet"
        vc2.title = "Analytics"
        
        setViewControllers([vc1, vc2], animated: false)
        guard let items = tabBar.items else {return}
        items[0].image = UIImage(systemName: "creditcard")
        items[1].image = UIImage(systemName: "chart.bar.xaxis")
    }
    
    func getPathForTabBar() -> UIBezierPath{
        let frameWidth = self.tabBar.frame.size.width
        let frameHeight = self.tabBar.frame.size.height+33
        let holeWidth = 150
        let holeHeight = 50
        let leftXUntilHole = Int(frameWidth/2) - Int(holeWidth/2)
        
        let path: UIBezierPath = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: leftXUntilHole, y: 0))
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6, y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2))
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth)/3 + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4))
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1:CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2) , controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3+(holeWidth/3)*2/8, y: 0))
        
        path.addLine(to: CGPoint(x: frameWidth, y: 0))
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
        path.addLine(to: CGPoint(x: 0, y: frameHeight))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        return path
    }
    
    
    
}


extension UIColor {
    public convenience init?(hex: String, alpha: Double = 1.0) {
        var pureString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (pureString.hasPrefix("#")) {
            pureString.remove(at: pureString.startIndex)
        }
        if ((pureString.count) != 6) {
            return nil
        }
        let scanner = Scanner(string: pureString)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            self.init(
                red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(hexNumber & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0))
            return
        }
        return nil
    }
}
