//
//  LoginViewController.swift
//  Twitter
//
//  Created by Santiago Escalante  on 3/4/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func onLoginButton(_ sender: Any) {
        //authentication url
        let myUrl = "https://api.twitter.com/oauth/request_token"
        //call Twitter API
        TwitterAPICaller.client?.login(url: myUrl, success: {
            //persist log-in between app restarts
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            //login success
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("Unable to login."); 
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool){
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true{
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
