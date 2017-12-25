//
//  ViewController.swift
//  Tipster
//
//  Created by somi on 12/23/17.
//  Copyright © 2017 somi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var totalName: UILabel!
    @IBOutlet weak var tipName: UILabel!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var viewBar: UIView!
    
    // Global variable for tip, defaultTip, animateOn
    var tip: Double = 0
    var defaultTip: Double = 0
    var animateOn: Bool = true
    
    // Set animations ON, defaultTip 15 if no defaults set
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        // Reset stored bill to 0 if greater than 10 minutes elapsed
        let storedDate = defaults.double(forKey: "storedDate")
        let currentDate = Date().timeIntervalSince1970
        if (storedDate - currentDate >= 600) {
            defaults.set(0.00, forKey: "storedBill")
        }
        defaults.set(Date().timeIntervalSince1970, forKey: "storedDate")
        
        if (!defaults.bool(forKey: "animateOn")) {
            defaults.set(true, forKey: "animateOn")
        }
        let defaultTipObject = defaults.object(forKey: "defaultTip")
        if (defaultTipObject == nil) {
            defaults.set(15, forKey: "defaultTip")
        }
    }
    
    // Load default tip, stored bill amount, and re-calculate bill on return
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        defaultTip = Double(defaults.integer(forKey: "defaultTip")) / 100.0
        animateOn = defaults.bool(forKey: "animateOn")
        if (defaults.double(forKey: "storedBill") != 0.0) {
            billAmount.text = String(defaults.double(forKey: "storedBill"))
        }
        // Start labels out of view
        if (animateOn) {
            billLabel.center.x -= view.bounds.width
            tipName.center.x -= view.bounds.width
            totalName.center.x -= view.bounds.width
        
            billAmount.center.x += view.bounds.width
            tipLabel.center.x += view.bounds.width
            totalLabel.center.x += view.bounds.width
        
            tipControl.center.y += view.bounds.height
            self.viewBar.alpha = 0
        }
        calculateTip(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate labels back into view
        if (animateOn) {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.billLabel.center.x += self.view.bounds.width
                self.billAmount.center.x -= self.view.bounds.width
            })
        
            UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseInOut], animations: {
                self.tipName.center.x += self.view.bounds.width
                self.tipLabel.center.x -= self.view.bounds.width
                self.viewBar.alpha = 1
            })
        
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.totalName.center.x += self.view.bounds.width
                self.totalLabel.center.x -= self.view.bounds.width
                self.tipControl.center.y -= self.view.bounds.height
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //print("view did disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Hide keyboard when tapping outside of input box
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    // Load tip percentage from UserDefaults or from user input, calculate tip amount and total bill
    @IBAction func calculateTip(_ sender: Any) {
        let defaults = UserDefaults.standard
        let tipPercentage = [0.18, 0.2, 0.25]
        let bill = Double(billAmount.text!) ?? 0
        tip = bill * (tipControl.selectedSegmentIndex == -1 ? defaultTip : tipPercentage[tipControl.selectedSegmentIndex])
        let total = bill + tip
        defaults.set(bill, forKey: "storedBill")
        tipLabel.text = String(format: "$%.02f", tip)
        totalLabel.text = String(format: "$%.02f", total)
    }
}

