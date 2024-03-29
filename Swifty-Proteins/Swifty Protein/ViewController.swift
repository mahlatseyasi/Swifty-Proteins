//
//  ViewController.swift
//  Swifty Protein
//
//  Created by Mahlatse KHOZA on 2019/11/05.
//  Copyright © 2019 Mahlatse KHOZA. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var TouchIDButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    var passTouchID : Bool = false

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if passTouchID == true {
            passTouchID = false
            return true
        } else {
            return false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UsernameField.text = "";
        PasswordField.text = "";
    }

    @IBAction func TouchID(_ sender: Any) {
        if self.passTouchID == true {
            return
        } else {
            let context:LAContext = LAContext()
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "TouchID to Login ", reply: { (wasSuccessful, error) in
                    if wasSuccessful {
                        self.passTouchID = true
                        DispatchQueue.main.async(){
                            self.TouchIDButton.sendActions(for: .touchUpInside)
                        }
                    } else {
                        self.passTouchID = false
                        self.createAlert(title: "Warning", message: "Authentication Failed.")
                    }
                })
            }
        }
    }

    @IBAction func LoginAction(_ sender: Any) {
        if (UsernameField.text == "admin" && PasswordField.text == "admin") {
            PasswordField.text = ""
            passTouchID = true
        } else {
            createAlert(title: "Warning", message: "Authentication Failed.")
            PasswordField.text = ""
            passTouchID = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LoginButton.layer.cornerRadius = 10
        let context:LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            self.TouchIDButton.isHidden = false
        } else {
            self.TouchIDButton.isHidden = true
            createAlert(title: "Compatibility Error", message: "Device does not support TouchID")
        }
    }

    /* alert func */
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        print(message)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        };
    }
}

