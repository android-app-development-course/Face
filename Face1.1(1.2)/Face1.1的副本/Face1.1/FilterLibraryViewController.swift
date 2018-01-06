//
//  FilterLibraryViewController.swift
//  Face1.1
//
//  Created by 刘友 on 2018/1/5.
//  Copyright © 2018年 刘友. All rights reserved.
//

import UIKit

protocol GetFilterValueDelegate: NSObjectProtocol {
    func getValue(_ controller:FilterLibraryViewController, FilterId: Int)
}

class FilterLibraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var Filter_id:Int = 0
    
    weak var delegate: GetFilterValueDelegate?
    
    @IBOutlet weak var santaH_Filter: UIButton!
    
    @IBOutlet weak var santab_Filter: UIButton!
    
    @IBOutlet weak var santa_Filter: UIButton!
    
   
    func initButton() {
        santaH_Filter.tag = 101
        santab_Filter.tag = 102
        santa_Filter.tag = 103
        
        santaH_Filter.addTarget(self, action: #selector(self.btnClickToChooseFilter(sender:)), for: UIControlEvents.touchUpInside)
        santab_Filter.addTarget(self, action: #selector(self.btnClickToChooseFilter(sender:)), for: UIControlEvents.touchUpInside)
        santa_Filter.addTarget(self, action: #selector(self.btnClickToChooseFilter(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    func btnClickToChooseFilter(sender: UIButton?) {
        let tag = sender?.tag
        switch (tag!)
        {
        case 101://santaH
            print("圣诞帽")
            Filter_id = 3
            //GoFilterValueBack()
            break
        case 102://santab
            print("胡子")
            Filter_id = 2
            //GoFilterValueBack()
            break
        case 103://santa
            print("圣诞老人")
            Filter_id = 1
            //GoFilterValueBack()
            break
        default:
            break
        }
        
        //self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)

        //dismiss(animated: true, completion: nil)
        GoFilterValueBack()
    }
    
    func GoFilterValueBack()
    {
        //调用代理方法
//        if((delegate) != nil)
//        {
            self.delegate?.getValue(self, FilterId: Filter_id)
            print("id为\(Filter_id)")
            //self.navigationController?.popToRootViewController(animated: true)
            
            
        //}
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        let destVC = (segue.destination as! ViewController)
//        destVC.i = Filter_id
//    }
    
    
    /*

     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
