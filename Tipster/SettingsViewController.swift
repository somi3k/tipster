//
//  SettingsViewController.swift
//  Tipster
//
//  Created by Somi Singh on 12/23/17.
//  Copyright © 2017 Somi Singh. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipLabel: UILabel!
    @IBOutlet weak var defaultTaxLabel: UILabel!
    @IBOutlet weak var animationsLabel: UILabel!
    @IBOutlet weak var darkThemeLabel: UILabel!
    @IBOutlet weak var defaultTipfield: UITextField!
    @IBOutlet weak var defaultTaxField: UITextField!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    
    // Global variable for animation
    var animateOn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve and set defaults
        let defaults = UserDefaults.standard
        defaultTipfield.text = defaults.string(forKey: "defaultTip")
        defaultTaxField.text = defaults.string(forKey: "defaultTax")
        animateOn = defaults.bool(forKey: "animateOn")
        animationSwitch.isOn = animateOn

        // Force cursor to defaultTipField and begin editing
        defaultTipfield.becomeFirstResponder()
        
        // Start labels out of view
        if (animateOn) {
            defaultTipLabel.center.y -= view.bounds.width
            defaultTaxLabel.center.x -= view.bounds.width
            animationsLabel.center.x -= view.bounds.width
            darkThemeLabel.center.y += view.bounds.width
        
            defaultTipfield.center.y -= view.bounds.width
            defaultTaxField.center.x += view.bounds.width
            animationSwitch.center.x += view.bounds.width
            darkThemeSwitch.center.y += view.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate labels back into view
        if (animateOn) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.defaultTipLabel.center.y += self.view.bounds.width
                self.defaultTipfield.center.y += self.view.bounds.width
            })
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.defaultTaxLabel.center.x += self.view.bounds.width
                self.defaultTaxField.center.x -= self.view.bounds.width
                self.animationsLabel.center.x += self.view.bounds.width
                self.animationSwitch.center.x -= self.view.bounds.width
            })
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.darkThemeLabel.center.y -= self.view.bounds.width
                self.darkThemeSwitch.center.y -= self.view.bounds.width
            })
        }
    }
    
    // Update animation default setting
    @IBAction func toggleAnimations(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(animationSwitch.isOn, forKey: "animateOn")
        defaults.synchronize()
    }
    
    // Update tax percentage default setting
    @IBAction func saveDefaultTax(_ sender: Any) {
        let tax = Double(defaultTaxField.text!)
        let defaults = UserDefaults.standard
        defaults.set(tax, forKey: "defaultTax")
        defaults.synchronize()
    }
    
    // Update tip percentage default setting
    @IBAction func saveDefaultTip(_ sender: Any) {
        let tip = Int(defaultTipfield.text!)
        let defaults = UserDefaults.standard
        defaults.set(tip, forKey: "defaultTip")
        defaults.synchronize()
    }
}
