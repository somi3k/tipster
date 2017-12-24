//
//  SettingsViewController.swift
//  Tipster
//
//  Created by somi on 12/23/17.
//  Copyright © 2017 somi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    

    @IBOutlet weak var defaultTip: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Save entered tip value to UserDefaults
    @IBAction func saveDefaultTip(_ sender: Any) {
        let tip = Int(defaultTip.text!)
        let defaults = UserDefaults.standard
        defaults.set(tip, forKey: "defaultTip")
        defaults.synchronize()
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
