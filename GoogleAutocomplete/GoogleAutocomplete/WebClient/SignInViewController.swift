//
//  SignInViewController.swift
//  MapAll
//
//  Created by Harry on 23/10/17.
//  Copyright © 2017 Harry. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit

typealias SignInCompletion = (_ suceess : Bool?) -> Void


class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollViewData: TPKeyboardAvoidingScrollView!
    @IBOutlet var viewSocial: UIView!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnTwitter: UIButton!
    @IBOutlet var btnInstagram: UIButton!
    @IBOutlet var viewSeperator: UIView!
    @IBOutlet var viewUserInputs: UIView!
    @IBOutlet var txtFieldEmail: CustomTextField!
    @IBOutlet var txtFieldPassword: CustomTextField!
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    
    var dictSocialMediaInfo : Dictionary<String, Any>?
    
    var signInCompletion : SignInCompletion?
    
    //MARK: -
    
    class func open(rootViewController : UIViewController, completion : SignInCompletion?) {
        let signInViewController = SF.storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signInViewController.signInCompletion = completion
        let navController = UINavigationController(rootViewController: signInViewController)
        navController.isNavigationBarHidden = true
        rootViewController.present(navController, animated: true, completion: {
            
        })
    }
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        let userTutorial = UserTutorial(with: "Darshan", lname: "Vyas")
        let object: Data = NSKeyedArchiver.archivedData(withRootObject: userTutorial)
        UserDefaults.standard.set(object, forKey: "DEFAULTS_KEY")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
        
        let data = UserDefaults.standard.object(forKey: "DEFAULTS_KEY") as? Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: data!) as? UserTutorial
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Buttons
    
    @IBAction func btnFacebookTapped(_ sender: Any) {
        self.view.endEditing(true)
        signInWithFacebook()
    }
    
    @IBAction func btnTwitterTapped(_ sender: Any) {
        self.view.endEditing(true)
        signInWithTwitter()
    }
    
    @IBAction func btnInstagramTapped(_ sender: Any) {
        self.view.endEditing(true)
        signInWithInstagram()
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier:"ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.presentPopupViewController(forgotPassVC, animationType:.slideBottomTop, backgroundTouch: false, dismissed: {
        })
        
    }
    
    @IBAction func btnSignInTapped(_ sender: Any) {
        self.view.endEditing(true)
        if isSignInDataValid() {
            // Remove social dict info
            dictSocialMediaInfo = nil
            signIn()
        }
    }
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
        self.view.endEditing(true)
        dictSocialMediaInfo = nil
        navigateToSignUpScreen()
    }
    
    //MARK: - Other Methods
    
    func isSignInDataValid() -> Bool {
        var message = ""
        if txtFieldEmail.text?.isValid == false {
            message = K.Message.enterPhoneorEmail
        }
        //else if txtFieldEmail.text?.isEmail == false {
          //  message = K.Message.enterValidEmail
        //}
        else if txtFieldPassword.text?.isValid == false {
            message = K.Message.enterPassword
        }
        if message.isValid {
            ISMessages.show(message)
            return false
        }
        return true
    }

    func signInWithFacebook() {
        FBSDKAccessToken.setCurrent(nil)
        let fetchUserInfoFromFaceBook = {() -> Void in
            let graphResquest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,first_name,last_name,email,gender,birthday"])
            
            _ = graphResquest?.start { connection, result, error in
                let dictionary = result as! Dictionary<String, Any>
                self.dictSocialMediaInfo = [:]
                if let picture = dictionary["picture"] as? [String:Any] ,
                    let imgData = picture["data"] as? [String:Any] ,
                    let imgUrl = imgData["url"] as? String {
                    self.dictSocialMediaInfo?["profile_photo"] = imgUrl
                }
                
                self.dictSocialMediaInfo?["full_name"] = (dictionary["first_name"] as? String)! + " " + (dictionary["last_name"] as? String)!
                //self.dictSocialMediaInfo["last_name"] = dictionary["last_name"]
                self.dictSocialMediaInfo?["email"] = dictionary["email"] ?? ""
                self.dictSocialMediaInfo?["social_id"] = dictionary["id"]
                self.dictSocialMediaInfo?["social_type"] = "facebook"
                self.signIn()
            }
        }
        if FBSDKAccessToken.current() != nil {
            fetchUserInfoFromFaceBook()
        }else {
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: { (signInResult, error) in
                if error != nil {
                    print("Process error")
                }
                else if (signInResult?.isCancelled)! {
                    print("Cancelled")
                }
                else {
                    fetchUserInfoFromFaceBook()
                    print("logged in")
                }
            })
        }
    }
    
    func signInWithTwitter() {
        Twitter.sharedInstance().logIn(with: self) { (session, error) in
            if session != nil {
                self.dictSocialMediaInfo = [:]
                self.dictSocialMediaInfo?["full_name"] = session?.userName
                self.dictSocialMediaInfo?["social_id"] = session?.userID
                self.dictSocialMediaInfo?["social_type"] = "twitter"
                self.signIn()
            }else {
                ISMessages.show(error?.localizedDescription)
            }
        }
    }
    
    func signInWithInstagram() {
        InstagramAuthViewController.showInViewController(self) { (accessToken, userInfo, error) in
            if userInfo != nil {
                if let dictData = userInfo!["data"] as? Dictionary<String, Any> {
                    self.dictSocialMediaInfo = [:]
                    self.dictSocialMediaInfo?["full_name"] = dictData["full_name"]
                    self.dictSocialMediaInfo?["social_id"] = dictData["id"]
                    self.dictSocialMediaInfo?["social_type"] = "twitter"
                    self.signIn()
                }
            }
        }

    }
    
    func navigateToSignUpScreen() -> Void {
        SignUpViewController.open(rootViewController: self, withSocialMediaInfo: dictSocialMediaInfo) { (success) in
            self.signInCompletion?(success)
        }
    }
    
    //MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Webservice Call
    
    func signIn() -> Void {
        SVProgressHUD.show()
        var param : Dictionary<String, Any> = ["username" : txtFieldEmail.text!,
                                               "password" : txtFieldPassword.text!]
        if self.dictSocialMediaInfo != nil {
            param["email"] = self.dictSocialMediaInfo?["email"]
            param["social_id"] = self.dictSocialMediaInfo?["social_id"]
            param["social_type"] = self.dictSocialMediaInfo?["social_type"]
        }
        
        _ = WebClient.requestWithUrl(url: K.URL.LOGIN, parameters: param) { (response, error) in
            if error == nil {
                let dictData = response as! Dictionary<String, Any>
                let user =  User(dict: dictData[K.Key.Data] as! [String : Any])
                user.save()
                AppUtility.updateDeviceToken()
                self.dismiss(animated: true, completion: {
                    self.signInCompletion?(true)
                })
            }
            else if (error as NSError?)?.code == 2 {
                self.navigateToSignUpScreen()
            }else {
                ISMessages.show(error?.localizedDescription)
            }
            SVProgressHUD.dismiss()
        }
    }
}

