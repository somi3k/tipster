//
//  ViewController.swift
//  Tipster
//
//  Created by Somi Singh on 12/23/17.
//  Copyright © 2017 Somi Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var totalName: UILabel!
    @IBOutlet weak var tipName: UILabel!
    @IBOutlet weak var taxName: UILabel!
    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var viewBar: UIView!
    
    // Global variables for tip, tax, defaultTip, animateOn
    var tip: Double = 0
    var tax: Double = 0
    var defaultTip: Double = 0
    var animateOn: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reset storedBill to 0 if greater than 10 minutes elapsed
        let defaults = UserDefaults.standard
        let storedDate = defaults.double(forKey: "storedDate")
        let currentDate = Date().timeIntervalSince1970
        if (storedDate - currentDate >= 600) {
            defaults.set(0.00, forKey: "storedBill")
        }
        defaults.set(Date().timeIntervalSince1970, forKey: "storedDate")
        
        // Set default values of animation ON, tip 15, tax 8.25 if nil
        if (!defaults.bool(forKey: "animateOn")) {
            defaults.set(true, forKey: "animateOn")
        }
        let defaultTipObject = defaults.object(forKey: "defaultTip")
        if (defaultTipObject == nil) {
            defaults.set(15, forKey: "defaultTip")
        }
        let defaultTaxObject = defaults.object(forKey: "defaultTax")
        if (defaultTaxObject == nil) {
            defaults.set(8.25, forKey: "defaultTax")
        }
        defaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restore defaults for tip, tax, animation, and bill
        let defaults = UserDefaults.standard
        defaultTip = Double(defaults.integer(forKey: "defaultTip")) / 100.0
        animateOn = defaults.bool(forKey: "animateOn")
        tax = defaults.double(forKey: "defaultTax") / 100.0
        if (defaults.double(forKey: "storedBill") != 0.0) {
            billAmount.text = String(format: "%.02f", defaults.double(forKey: "storedBill"))
        }
        
        // Force cursor to billAmount and begin editing
        billAmount.becomeFirstResponder()
        
        // Start labels out of view
        if (animateOn) {
            tipName.center.x -= view.bounds.width
            taxName.center.x -= view.bounds.width
            totalName.center.x -= view.bounds.width
            
            tipLabel.center.x += view.bounds.width
            taxLabel.center.x += view.bounds.width
            totalLabel.center.x += view.bounds.width
            
            billAmount.center.y -= view.bounds.width
            tipControl.center.y += view.bounds.height
            self.viewBar.alpha = 0
        }
        calculateTip(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate labels and fields back into view
        if (animateOn) {
            UIView.animate(withDuration: 0.2, delay: 0.05, options: [.curveEaseInOut], animations: {
                self.billAmount.center.y += self.view.bounds.width
            })
            UIView.animate(withDuration: 0.2, delay: 0.05, options: [.curveEaseInOut], animations: {
                self.tipName.center.x += self.view.bounds.width
                self.taxName.center.x += self.view.bounds.width
                self.taxLabel.center.x -= self.view.bounds.width
                self.tipLabel.center.x -= self.view.bounds.width
                self.totalName.center.x += self.view.bounds.width
                self.totalLabel.center.x -= self.view.bounds.width
                self.tipControl.center.y -= self.view.bounds.height
            })
            UIView.animate(withDuration: 0.2, delay: 0.15, options: [.curveEaseInOut], animations: {
                self.viewBar.alpha = 1
            })
        }
    }

    // Hide keyboard, restore bill amount on background tap
    @IBAction func onTap(_ sender: Any) {
        let defaults = UserDefaults.standard
        billAmount.text = String(format: "%.02f", defaults.double(forKey: "storedBill"))
        view.endEditing(true)
    }
    
    // Format text input using current localization for currency
    func formatOutput(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let formattedOutput = formatter.string(from: amount as NSNumber)
        return formattedOutput!
    }
    
    // Load tip percentage from UserDefaults or from user input, calculate tip amount and total bill
    @IBAction func calculateTip(_ sender: Any) {
        let defaults = UserDefaults.standard
        let tipPercentage = [0.18, 0.2, 0.25]
        let bill = Double(billAmount.text!) ?? 0
        let taxAmount = bill * tax
        tip = (bill + taxAmount) * (tipControl.selectedSegmentIndex == -1 ? defaultTip : tipPercentage[tipControl.selectedSegmentIndex])
        let total = bill + tip
        defaults.set(bill, forKey: "storedBill")
        taxLabel.text = formatOutput(taxAmount)
        tipLabel.text = formatOutput(tip)
        totalLabel.text = formatOutput(total)
        defaults.synchronize()
    }
}
