//
//  SettingsViewController.swift
//  Tipster
//
//  Created by somi on 12/23/17.
//  Copyright © 2017 somi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var animateOn: Bool = true

    @IBOutlet weak var defaultTipLabel: UILabel!
    @IBOutlet weak var animationsLabel: UILabel!
    
    @IBOutlet weak var defaultTipfield: UITextField!
    
    @IBOutlet weak var animationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
    
    // Retrieve and set defaults
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        defaultTipfield.text = defaults.string(forKey: "defaultTip")
        animateOn = defaults.bool(forKey: "animateOn")
        animationSwitch.isOn = animateOn

        // Start labels out of view
        if (animateOn) {
            defaultTipLabel.center.x -= view.bounds.width
            animationsLabel.center.x -= view.bounds.width
        
            defaultTipfield.center.x += view.bounds.width
            animationSwitch.center.x += view.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate labels back into view
        if (animateOn) {
            UIView.animate(withDuration: 0.2, animations: {
                self.defaultTipLabel.center.x += self.view.bounds.width
                self.defaultTipfield.center.x -= self.view.bounds.width
            })
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: [], animations: {
                self.animationsLabel.center.x += self.view.bounds.width
                self.animationSwitch.center.x -= self.view.bounds.width
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleAnimations(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(animationSwitch.isOn, forKey: "animateOn")
        defaults.synchronize()
    }
    
    // Save entered tip value to UserDefaults
    @IBAction func saveDefaultTip(_ sender: Any) {
        let tip = Int(defaultTipfield.text!)
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
