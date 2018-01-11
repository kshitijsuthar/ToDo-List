//
//  Created by
//
//  Kshitij Suthar - 300971838
//  Harsh Mehta - 300951815
//

import UIKit
import CoreData

class TodoDetails: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var listName: UILabel!
    
    
    @IBOutlet weak var details: UITextView!
    
    var agenda = ""
    
    var notes: [NSManagedObject] = []
    
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
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(TodoDetails.closekeyboard))
        
        view.addGestureRecognizer(tap)
        
        self.details.delegate = self

    }
    
    @objc func closekeyboard(){
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ToDo")
        
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
//        fetchRequest.returnsObjectsAsFaults = false
//        do {
//            //let result = try managedContext.fetch(fetchRequest)
//            for item in notes {
//                details.text = item.value(forKey: "notes") as! String
//
//            }
//
//        }
        catch {
            
            print("Failed")
        }
        
    }
    
    
    @IBAction func Save(_ sender: UIButton) {
        
        let detail = self.notes[0]
        
        detail.setValue(details.text, forKey: "notes")
        
        do{
            try detail.managedObjectContext?.save()
        }
        catch{
            let saveerror = error as NSError
            print(saveerror)
        }
        
        print("%s",details.text)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        
        //with this code user will be redirected to the previous view controller when they tap cancel
        navigationController?.popViewController(animated: true)
        
    }
    

}
