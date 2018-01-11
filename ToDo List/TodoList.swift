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
    
    //names is a mutable array which stores the data inputted by user
    var names: [NSManagedObject] = []

    
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
        
        self.input.delegate = self;
        
    }
    
    //This function is used to display the data stored in the database
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
        
        self.tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This code is used to fill the tableview with user input
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
    
    //This function is for right swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedContext =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            managedContext.delete(names[indexPath.row])
            do {
                try managedContext.save()
                self.tableView.reloadData()
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    //This function is declared to implement left swipe, which will mark the task as completed
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let cell = tableView.cellForRow(at: indexPath)
        let closeAction = UIContextualAction(style: .normal, title:  "Done", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            cell!.textLabel?.isEnabled = false
            
            success(true)
        })
        closeAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    //This function is used to store the user inputted data in the database
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
    
    var valueToPass:String!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Row value will be passed to the next screen form here
        if (segue.identifier == "todoDetails") {
            
            let viewController = segue.destination as! TodoDetails
            viewController.agenda = valueToPass /*agenda is a label declared in the next view controller,
                                                which is ToDoDetails*/
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //user selected row will be detected here
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        valueToPass = currentCell!.textLabel?.text
        performSegue(withIdentifier: "todoDetails", sender: self)    }

}
