//
//  LoginViewController.swift
//  DNApp
//
//  Created by Karlis Berzins on 15/08/15.
//  Copyright © 2015 Karlis Berzins. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLogin(controller: LoginViewController)
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var emailImageView: SpringImageView!
    @IBOutlet weak var passwordImageView: SpringImageView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    weak var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

// MARK: Actions

    @IBAction func loginButtonDidTouch(sender: AnyObject) {

        guard let userEmail = emailTextField.text, userPassword = passwordTextField.text else {
            return
        }

        DNService.loginWithEmail(userEmail, password: userPassword) { (token) -> () in
            if let token = token {
                LocalStore.saveToken(token)
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.loginViewControllerDidLogin(self)
            } else {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
            }
        }
    }

    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        dialogView.animation = "zoomOut"
        dialogView.animate()
    }

// MARK: TextField Delegate

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField {
            emailImageView.image = UIImage(named: "icon-mail-active")
            emailImageView.animate()
        } else {
            emailImageView.image = UIImage(named: "icon-mail")
        }

        if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-password-active")
            passwordImageView.animate()
        } else {
            passwordImageView.image = UIImage(named: "icon-password")
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
    }
}
