//
//  Created by
//
//  Kshitij Suthar - 300971838
//  Harsh Mehta - 300951815
//

import UIKit

class TodoDetails: UIViewController {
    
    
    @IBOutlet weak var listName: UILabel!
    
    var agenda = ""
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navbar = hexStringToUIColor(hex: "F9AA90")
        
        navigationController?.navigationBar.barTintColor = navbar
        
        listName.text = agenda

    }


}
