//
//  ViewController.swift
//  rehab
//
//  Created by alumno on 3/12/18.
//  Copyright © 2018 Bernardo Orozco Garza. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var tfMail: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    
    var users = [NSObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Database.database().reference().child("usuarios").observeSingleEvent(of: .value, with: {(snap) in
            let value = snap.value as! [String: AnyObject]
            for (key,_) in value {
                let data = value[key] as! NSObject
                data.setValue(key, forKey: "uuid")
                self.users.append(data)
            }
        }, withCancel: {(error) in
            print(error)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Database.database().reference().child("usuarios").observeSingleEvent(of: .value, with: {(snap) in
            let value = snap.value as! [String: AnyObject]
            for (key,_) in value {
                let data = value[key] as! NSObject
                data.setValue(key, forKey: "uuid")
                self.users.append(data)
            }
        }, withCancel: {(error) in
            print(error)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        view.endEditing(true)
        if(tfMail.text != ""){
            Auth.auth().signIn(withEmail: tfMail.text!, password: tfPass.text!) { (user, error) in
                if(error==nil){
                    if(self.aviable(uid: user!.uid)){
                        if(user!.email=="admin@p.com"){
                            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "adminInit"), animated: true)
                        }else{
                            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "userInit"), animated: true)
                        }
                        self.tfPass.text=""
                        self.tfMail.text=""
                    }else{
                        self.presentError(msg: "Email without permission")
                    }
                }else{
                    self.presentError(msg: error!.localizedDescription);
                }
            }
        }else{
            presentError(msg: "No email provided");
        }
    }
    func aviable(uid: String) -> Bool{
        print(uid);
        for ele in users{
            if(ele.value(forKey: "uuid") as! String == uid && ele.value(forKey: "active") as! Bool == true) {
                return true;
            }
        }
        return false;
    }
    func presentError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){
        
    }
}

