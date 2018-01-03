//
//  Created by
//
//  Kshitij Suthar - 300971838
//  Harsh Mehta - 300951815
//

import UIKit
import CoreData

class TodoList: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var input: UITextField!
    
    var names: [NSManagedObject] = []

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
        
        var navbar = hexStringToUIColor(hex: "FC6D45")
        
        navigationController?.navigationBar.barTintColor = navbar
        
        self.input.delegate = self;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ToDo")
        
        do {
            names = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ToDo = names[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = ToDo.value(forKeyPath: "name") as? String
        
        return cell
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let save = input.text
        
        self.save(name: save!)
        self.tableView.reloadData()
        input.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        input.resignFirstResponder()
        
        return true
    }
    
    func save(name: String) {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "ToDo",
                                       in: managedContext)!
        
        let todo = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        todo.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            names.append(todo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //let todoName = segue.destination as! TodoDetails
        
        //todoName.name = sender as! String
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "todoDetails", sender: nil)
    }

}
