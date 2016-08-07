//
//  RegistureViewController.swift
//  PokechainDemo
//
//  Created by 夏婷 on 16/7/18.
//  Copyright © 2016年 夏婷. All rights reserved.
//

import UIKit

class RegistureViewController: UIViewController {
    
    var sessId:String! = "" //保存获取图片验证码时的SessId
    @IBOutlet weak var idefyBtn: UIButton!
    @IBOutlet weak var userField: UITextField!
    
    @IBOutlet weak var idefyCodeFiled: UITextField!
    
    @IBOutlet weak var phoneCodeFiled: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "loginBackgroundImage.png")!)
        
        self.userField.backgroundColor = UIColor.clearColor()
        self.idefyCodeFiled.backgroundColor = UIColor.clearColor()
        self.phoneCodeFiled.backgroundColor = UIColor.clearColor()
        self.updateIdefyCode(self)
    }
    
    
    
    //获取图片验证码
    @IBAction func updateIdefyCode(sender: AnyObject) {
//      methodName=UserVerify&token=&user_id=&version=4.4
        let para = ["methodName":"UserVerify","version":"4.4"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            if error == nil{
             
               
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let dic = obj["data"] as! NSDictionary
                
                let image = dic["image"] as! String
                //将图片地址中的{}进行Unicode编码
                let url = NSString.init(string: image).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
                
                dispatch_async(dispatch_get_main_queue(), { 
                    
                self.idefyBtn.sd_setBackgroundImageWithURL(NSURL.init(string: url!), forState: UIControlState.Normal)
                    self.idefyBtn.sd_setBackgroundImageWithURL(NSURL.init(string: url!), forState: UIControlState.Highlighted)
                })
                self.sessId = dic["sessid"] as! String
                
            }
        }
        
        
    }
    
    //发送验证码
    @IBAction func sendPhoneCode(sender: AnyObject) {
       
        
        //methodName=UserLogin&mobile=18515996749&sessid=%7B01f1b9bc-e990-c1b5-e201-1eed6909f821%7D&token=&user_id=&verify=Yxua&version=4.4
        let para = ["methodName":"UserLogin","mobile":self.userField.text!,"sessid":self.sessId,"verify":self.idefyCodeFiled.text!,"version":"4.4"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
               
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if obj["msg"] as! String == "success"{
                    
                    let alert = UIAlertController.init(title: "提示", message: "短信发送成功！", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(action)
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
            
        }

    }
    
    
    @IBAction func nextStop(sender: AnyObject) {
        
        //code=197354&device_id=0819b83fb99&methodName=UserAuth&mobile=18515996749&token=&user_id=&version=4.4
        
        let para = ["code":self.phoneCodeFiled.text!,"methodName":"UserAuth","mobile":self.userField.text!,"version":"4.4"]
        BaseRequest.postWithURL(HOME_URL, para: para) { (data, error) in
            
            if error == nil{
                
                let str = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                print(str!)
                let obj = try!NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if obj["msg"] as! String == "success"{
                    
                    let dic = obj["data"] as! NSDictionary
                    
                    let userID = dic["user_id"] as! NSInteger
                    
                    let token = dic["token"] as! String
                    //用于判断用户是否已经存在
                    let isHave = dic["pwd_exist"] as! Bool
                    
                    if isHave{
                        
                        let alert = UIAlertController.init(title: "提示", message: "用户已经存在", preferredStyle: UIAlertControllerStyle.Alert)
                        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                        alert.addAction(action)
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {
                            let newUser = NewUserController()
                            newUser.userId = String(userID)
                            newUser.token = token
                            self.navigationController?.pushViewController(newUser, animated: true)
                            
                        })
                    }
                }
            }
        }
        

       

    }
    
    
    @IBAction func backtoPreView(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
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
