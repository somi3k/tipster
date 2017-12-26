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
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var viewBar: UIView!
    
    // Global variable animateOn
    var animateOn: Bool = true
    
    // Global variable for UserDefault
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reset storedBill to 0 if greater than 10 minutes elapsed
        let storedDate = defaults.double(forKey: "storedDate")
        let currentDate = Date().timeIntervalSince1970
        
        if (storedDate - currentDate >= 600) {
            defaults.set(0.00, forKey: "storedBill")
            defaults.set(0.00, forKey: "storedTipAmount")
        }
        defaults.set(Date().timeIntervalSince1970, forKey: "storedDate")
        
        // Check that defaults are initialized, otherwise set
        let defaultAnimateObject = defaults.object(forKey: "animateOn")
        let defaultTipPctObject = defaults.object(forKey: "defaultTipPercent")
        let defaultTaxObject = defaults.object(forKey: "defaultTax")
        let defaultBillObject = defaults.object(forKey: "storedBill")
        let defaultTipAmtObject = defaults.object(forKey: "storedTipAmount")
        let defaultImplicitTipRateObject = defaults.object(forKey: "implicitTipRate")
        if (defaultAnimateObject == nil) {
            defaults.set(true, forKey: "animateOn")
        }
        if (defaultTipPctObject == nil) {
            defaults.set(15, forKey: "defaultTipPercent")
        }
        if (defaultTaxObject == nil) {
            defaults.set(8.25, forKey: "defaultTax")
        }
        if (defaultTipAmtObject == nil) {
            defaults.set(0.00, forKey: "storedTipAmount")
        }
        if (defaultBillObject == nil) {
            defaults.set(0.00, forKey: "storedBill")
        }
        if (defaultImplicitTipRateObject == nil) {
            defaults.set(0, forKey: "implicitTipRate")
        }
        defaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restore defaults for tip, tax, animation, and bill
        animateOn = defaults.bool(forKey: "animateOn")

        // Force cursor to billAmount and begin editing
        billAmount.becomeFirstResponder()
        
        // Start labels out of view
        if (animateOn) {
            tipName.center.x -= view.bounds.width
            taxName.center.x -= view.bounds.width
            totalName.center.x -= view.bounds.width
            
            tipField.center.x += view.bounds.width
            taxLabel.center.x += view.bounds.width
            totalLabel.center.x += view.bounds.width
            
            billAmount.center.y -= view.bounds.width
            tipControl.center.y += view.bounds.height
            self.viewBar.alpha = 0
        }
        inputTip(self)
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
                self.tipField.center.x -= self.view.bounds.width
                self.totalName.center.x += self.view.bounds.width
                self.totalLabel.center.x -= self.view.bounds.width
                self.tipControl.center.y -= self.view.bounds.height
            })
            UIView.animate(withDuration: 0.2, delay: 0.15, options: [.curveEaseInOut], animations: {
                self.viewBar.alpha = 1
            })
        }
    }

    // Force cursor upon editing billAmount
    @IBAction func clearBillAmount(_ sender: Any) {
        billAmount.becomeFirstResponder()
    }
    
    // Force cursor upon editing tipField
    @IBAction func clearTipField(_ sender: Any) {
        tipField.becomeFirstResponder()
    }
    
    // Hide keyboard, restore bill amount on background tap
    @IBAction func onTap(_ sender: Any) {
        billAmount.endEditing(true)
        tipField.endEditing(true)
        view.endEditing(true)
        billAmount.text = formatOutput(defaults.double(forKey: "storedBill"))
    }
    
    // Format text input using current localization for currency
    func formatOutput(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let formattedOutput = formatter.string(from: amount as NSNumber)
        return formattedOutput!
    }
    
    // Take input from segmented control and calculate new total
    @IBAction func calculateTip(_ sender: Any) {
        let tipBar = [0.18, 0.2, 0.25]
        let tipPercent = (tipControl.selectedSegmentIndex != -1) ? tipBar[tipControl.selectedSegmentIndex] : Double(defaults.integer(forKey: "defaultTipPercent")) / 100.0
        let bill = defaults.double(forKey: "storedBill")
        let tax = bill * (defaults.double(forKey: "defaultTax") / 100.0)
        let tip = (bill + tax) * tipPercent
        defaults.set(tip, forKey: "storedTipAmount")
        defaults.synchronize()
        calculateTotal(self)
    }
    
    // Take custom input from tipField and calculate new total
    @IBAction func inputTip(_ sender: Any) {
        let tip = Double(tipField.text!) ?? defaults.double(forKey: "storedTipAmount")
        defaults.set(tip, forKey: "storedTipAmount")
        defaults.synchronize()
        calculateTotal(self)
    }
    
    // Take input from billAmount and calculate new total
    @IBAction func inputBill(_ sender: Any) {
        let bill = Double(billAmount.text!) ?? defaults.double(forKey: "storedBill")
        defaults.set(bill, forKey: "storedBill")
        defaults.synchronize()
        calculateTip(self)
    }
    
    // Calculate total from tipAmount and billAmount and update labels
    func calculateTotal(_ sender: Any) {
        let bill = defaults.double(forKey: "storedBill")
        let tax = bill * (defaults.double(forKey: "defaultTax") / 100.0)
        let tip = defaults.double(forKey: "storedTipAmount")
        var implicitTipRate = defaults.integer(forKey: "implicitTipRate")
        if (bill > 0.0) {
            implicitTipRate = Int((tip / (bill + tax)) * 100.0)
        }
        else {
            implicitTipRate = 0
        }
        let total = bill + tip + tax
        defaults.set(implicitTipRate, forKey: "implicitTipRate")
        tipName.text = "Tip (" + String(implicitTipRate) + "%)"
        taxLabel.text = formatOutput(tax)
        tipField.text = formatOutput(tip)
        totalLabel.text = formatOutput(total)
    }
}
