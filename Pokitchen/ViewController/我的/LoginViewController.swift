//
//  LoginViewController.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "loginBackgroundImage.png")!)
        
        self.userField.backgroundColor = UIColor.clearColor()
        self.passwordField.backgroundColor = UIColor.clearColor()
        
        self.passwordField.secureTextEntry = true
    }
    //总觉得哪里不对啊

    @IBAction func backToPreView(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func login(sender: AnyObject) {
        
        //methodName=UserSignin&mobile=18515996749&password=c543bdde17c6bb115b84324ff80aaa70&token=&user_id=&version=4.4
        let para = ["methodName":"UserSignin","mobile":self.userField.text!,"password":self.passwordField.text!.md5,"version":"4.4"
        ]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil
            {
                let str = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                print(str!)
                let obj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let dic = obj["data"] as! NSDictionary
                defaultUser.userId = String(dic["user_id"] as! NSInteger)
                defaultUser.nickname = dic["nickname"] as! String
                defaultUser.token = dic["token"] as! String
                defaultUser.isLogin = true
                dispatch_async(dispatch_get_main_queue(), { 
                    print("登录成功")
                    self.navigationController?.popViewControllerAnimated(true)
                })
                
            }
            
        }
   
        

    }
    
   
    @IBAction func registureUser(sender: AnyObject) {
        
        let registureVC = RegistureViewController.init()
        self.navigationController?.pushViewController(registureVC, animated: true)
    }
    
    
    @IBOutlet weak var forgetPassword: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
