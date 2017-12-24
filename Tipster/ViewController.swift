//
//  ViewController.swift
//  Tipster
//
//  Created by somi on 12/23/17.
//  Copyright © 2017 somi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    // Global variable for tip, defaultTip
    var tip: Double = 0
    var defaultTip: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Load default tip and calculate bill
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        defaultTip = Double(defaults.integer(forKey: "defaultTip")) / 100.0
        calculateTip(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did disappear")
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

        let tipPercentage = [0.18, 0.2, 0.25]
        let bill = Double(billAmount.text!) ?? 0
        tip = bill * (tipControl.selectedSegmentIndex == -1 ? defaultTip : tipPercentage[tipControl.selectedSegmentIndex])
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.02f", tip)
        totalLabel.text = String(format: "$%.02f", total)
    }
}

