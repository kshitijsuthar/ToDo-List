//
//  Created by
//
//  Kshitij Suthar - 300971838
//  Harsh Mehta - 300951815
//

import UIKit
import CoreData

class TodoDetails: UIViewController {
    
    
    @IBOutlet weak var listName: UILabel!
    
    
    @IBOutlet weak var details: UITextView!
    
    var agenda = ""
    
    //This function is used to change the navigation bar color
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
        
        //Above declared function is called here to input the color hex
        let navbar = hexStringToUIColor(hex: "FC6D45")
        
        navigationController?.navigationBar.barTintColor = navbar
        
        listName.text = agenda

    }
    
//    func deleteAllData(entity: String)
//    {
//        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do
//        {
//            let results = try managedContext.fetch(fetchRequest)
//            for managedObject in results
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                managedContext.delete(managedObjectData)
//            }
//        } catch let error as NSError {
//            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
//        }
//    }
    
    func deleteAllData(entity: String)
    {
        let managedContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
    @IBAction func Save(_ sender: UIButton) {
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        
        //with this code user will be redirected to the previous view controller when they tap cancel
        navigationController?.popViewController(animated: true)
        
    }
    

}
