//
//  CreateUserController.swift
//  rehab
//
//  Created by Infinity0106 on 4/8/18.
//  Copyright © 2018 Bernardo Orozco Garza. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseCore

class CreateUserController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var swV1: UISwitch!
    @IBOutlet weak var swV2: UISwitch!
    @IBOutlet weak var swV3: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let secondaryOptions = FirebaseOptions(googleAppID: "1:713378228951:ios:914e9d23918f635d", gcmSenderID: "713378228951");
        secondaryOptions.bundleID = "mx.itesm.rehab"
        secondaryOptions.apiKey = "AIzaSyB8yPwjodvdSrFnPHZ-KhWnBEH6CaWK7TU"
        secondaryOptions.clientID = "713378228951-fbrt6f3rker7llavggv4r5fb18g9pjdn.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://rehab-e26f7.firebaseio.com"
        secondaryOptions.storageBucket = "rehab-e26f7.appspot.com"
        
        FirebaseApp.configure(name: "secondary", options: secondaryOptions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createUser(_ sender: UIButton) {
        let sec = FirebaseApp.app(name: "secondary")
        Auth.auth(app: sec!).createUser(withEmail: tfEmail.text!, password: "123456") {(user,err) in
            if err == nil{
                let uid : String = Auth.auth(app: sec!).currentUser!.uid
//                active
                Database.database().reference().child("usuarios").child(uid).child("active").setValue(true)
//                admin
                Database.database().reference().child("usuarios").child(uid).child("admin").setValue(false)
//                email
                Database.database().reference().child("usuarios").child(uid).child("email").setValue(self.tfEmail.text!)
//                nombre
                Database.database().reference().child("usuarios").child(uid).child("nombre").setValue(self.tfName.text!)
//                videos
                if self.swV1.isOn {
                    Database.database().reference().child("usuarios").child(uid).child("videos").childByAutoId().setValue("https://firebasestorage.googleapis.com/v0/b/rehab-e26f7.appspot.com/o/prueba.mp4?alt=media")
                }
                //TODO: Faltan mas url de videos
                
                try! Auth.auth(app: sec!).signOut()
                self.navigationController!.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func backView(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
