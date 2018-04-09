//
//  AdminInitTableViewController.swift
//  
//
//  Created by Infinity0106 on 3/14/18.
//

import UIKit
import FirebaseDatabase

class AdminInitTableViewController: UITableViewController {

    var ref: DatabaseReference! = Database.database().reference().child("usuarios")
    var array = [NSObject]();
    var inActive = [NSObject]();
    var sectionsArr = ["Active","Inactive"];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        getFirebaseData();
    }

    override func viewWillAppear(_ animated: Bool) {
        getFirebaseData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var num = sectionsArr.count
        num = (inActive.count == 0) ? num-1 : num
        num = (array.count == 0) ? num-1 : num
        print("number in section", num, inActive.count,array.count)
        return num
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (array.count == 0 && section == 0){
            return sectionsArr[1]
        }
        return sectionsArr[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            if(array.count == 0){
                return inActive.count
            }
            return array.count
        case 1:
            return inActive.count
        default:
            return array.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            if(array.count == 0){
                cell.textLabel?.text = inActive[indexPath.row].value(forKey: "nombre") as? String;
                cell.detailTextLabel?.text=inActive[indexPath.row].value(forKey: "email") as? String;
                return cell
            }
            cell.textLabel?.text = array[indexPath.row].value(forKey: "nombre") as? String;
            cell.detailTextLabel?.text=array[indexPath.row].value(forKey: "email") as? String;
            return cell
        default:
            cell.textLabel?.text = inActive[indexPath.row].value(forKey: "nombre") as? String;
            cell.detailTextLabel?.text=inActive[indexPath.row].value(forKey: "email") as? String;
            return cell
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ref.child(array[indexPath.row].value(forKey: "uuid") as! String).child("active").setValue(false);
            self.array.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade)
            getFirebaseData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // function to create buttons for edititng
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var ackAction : UITableViewRowAction;
        switch indexPath.section {
        case 0:
            if(array.count==0){
                ackAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Activate", handler: activateUser)
                ackAction.backgroundColor = UIColor(red:0.66, green:0.77, blue:0.46, alpha:1.0)
            }else{
                ackAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Deactivate", handler: incativateUser)
                ackAction.backgroundColor = UIColor(red:0.82, green:0.45, blue:0.45, alpha:1.0)
            }
        default:
            ackAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Activate", handler: activateUser)
            ackAction.backgroundColor = UIColor(red:0.66, green:0.77, blue:0.46, alpha:1.0)
        }
        
        
        return [ackAction]
    }
    
    func incativateUser(action: UITableViewRowAction, indexPath: IndexPath){
        ref.child(array[indexPath.row].value(forKey: "uuid") as! String).child("active").setValue(false);
        self.array.remove(at: indexPath.row)
        if self.array.count == 0 {
            var indexset = IndexSet();
            indexset.insert(indexPath.section)
            self.tableView.deleteSections(indexset, with: .left)
        } else {
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        self.getFirebaseData()
    }
    
    func activateUser(action: UITableViewRowAction, indexPath: IndexPath){
        ref.child(inActive[indexPath.row].value(forKey: "uuid") as! String).child("active").setValue(true);
        self.inActive.remove(at: indexPath.row)
        if self.inActive.count == 0 {
            var indexset = IndexSet();
            indexset.insert(indexPath.section)
            self.tableView.deleteSections(indexset, with: .left)
        } else {
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        self.getFirebaseData()
    }
    
    func getFirebaseData(){
        ref.observeSingleEvent(of: .value, with: {(snap) in
            let value = snap.value as! [String: AnyObject]
            for (key,_) in value {
                let data = value[key] as! NSObject
                data.setValue(key, forKey: "uuid")
                
                if data.value(forKey: "admin") as! Bool != true {
                    if data.value(forKey: "active") as! Bool == true {
                        if(!self.alreadyInArr(uuid: data.value(forKey: "uuid") as! String, arr: self.array)){
                            self.array.append(data)
                        }
                    } else {
                        if(!self.alreadyInArr(uuid: data.value(forKey: "uuid") as! String, arr: self.inActive)){
                            self.inActive.append(data)
                        }
                    }
                }
            }
            print(self.array)
            print(self.inActive)
            self.tableView.reloadData()
        }, withCancel: {(error) in
            print(error)
        })
    }
    
    func alreadyInArr(uuid: String, arr: [NSObject]) -> Bool{
        for data in arr {
            print(data)
            if uuid == data.value(forKey: "uuid") as! String {
                return true;
            }
        }
        return false;
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func unwindEditUser(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
}
