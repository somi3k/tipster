/// Copyright (c) 2017 Somi Singh
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var shareView: UIView!
  @IBOutlet weak var historyView: UIView!
  @IBOutlet weak var totalName: UILabel!
  @IBOutlet weak var tipName: UILabel!
  @IBOutlet weak var taxName: UILabel!
  @IBOutlet weak var billAmount: UITextField!
  @IBOutlet weak var tipField: UITextField!
  @IBOutlet weak var taxLabel: UILabel!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var viewBar: UIView!
  @IBOutlet weak var twoLabel: UILabel!
  @IBOutlet weak var threeLabel: UILabel!
  @IBOutlet weak var fourLabel: UILabel!
  @IBOutlet weak var fiveLabel: UILabel!
  @IBOutlet weak var historyOne: UILabel!
  @IBOutlet weak var historyTwo: UILabel!
  @IBOutlet weak var historyThree: UILabel!
  @IBOutlet weak var historyFour: UILabel!
  @IBOutlet weak var historyFive: UILabel!
  @IBOutlet weak var historySix: UILabel!
  @IBOutlet weak var historySeven: UILabel!
  @IBOutlet weak var historyEight: UILabel!
  @IBOutlet weak var historyNine: UILabel!
  @IBOutlet weak var historyTen: UILabel!
  
  // Global variable animateOn
  var animateOn: Bool = true
  var darkTheme: Bool = false
  
  // Global variable for UserDefault
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Reset storedBill to 0 if greater than 10 minutes elapsed
    let storedDate = defaults.double(forKey: "storedDate")
    let currentDate = Date().timeIntervalSince1970
    if (currentDate - storedDate >= 600.0) {
      defaults.set(0.00, forKey: "storedBill")
      defaults.set(0.00, forKey: "storedTipAmount")
    }
    defaults.set(Date().timeIntervalSince1970, forKey: "storedDate")
    
    // Check that defaults are initialized, otherwise set
    let defaultAnimateObject = defaults.object(forKey: "animateOn")
    let defaultDarkObject = defaults.object(forKey: "darkTheme")
    let defaultTipPctObject = defaults.object(forKey: "defaultTipPercent")
    let defaultTaxObject = defaults.object(forKey: "defaultTax")
    let defaultBillObject = defaults.object(forKey: "storedBill")
    let defaultTotalObject = defaults.object(forKey: "storedTotal")
    let defaultTipAmtObject = defaults.object(forKey: "storedTipAmount")
    let defaultImplicitTipRateObject = defaults.object(forKey: "implicitTipRate")
    let defaultHistoryPosition = defaults.object(forKey: "historyPosition")
    let defaultTwoLabel = defaults.object(forKey: "twoLabel")
    let defaultThreeLabel = defaults.object(forKey: "threeLabel")
    let defaultFourLabel = defaults.object(forKey: "fourLabel")
    let defaultFiveLabel = defaults.object(forKey: "fiveLabel")
    for index in 1...10 {
      let key = "history" + String(index)
      let history = defaults.object(forKey: key)
      if history == nil {
        defaults.set(0.0, forKey: key)
      }
    }
    if defaultAnimateObject == nil {
      defaults.set(true, forKey: "animateOn")
    }
    if defaultDarkObject == nil {
      defaults.set(false, forKey: "darkTheme")
    }
    if defaultTwoLabel == nil {
      defaults.set(0.0, forKey: "twoLabel")
    }
    if defaultThreeLabel == nil {
      defaults.set(0.0, forKey: "threeLabel")
    }
    if defaultFourLabel == nil {
      defaults.set(0.0, forKey: "fourLabel")
    }
    if defaultFiveLabel == nil {
      defaults.set(0.0, forKey: "fiveLabel")
    }
    if defaultTipPctObject == nil {
      defaults.set(15, forKey: "defaultTipPercent")
    }
    if defaultTaxObject == nil {
      defaults.set(8.25, forKey: "defaultTax")
    }
    if defaultTipAmtObject == nil {
      defaults.set(0.00, forKey: "storedTipAmount")
    }
    if defaultBillObject == nil {
      defaults.set(0.00, forKey: "storedBill")
    }
    if defaultTotalObject == nil {
      defaults.set(0.00, forKey: "storedTotal")
    }
    if defaultImplicitTipRateObject == nil {
      defaults.set(0, forKey: "implicitTipRate")
    }
    if defaultHistoryPosition == nil {
      defaults.set(1, forKey: "historyPosition")
    }
    defaults.synchronize()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Restore defaults for animation and darkTheme
    animateOn = defaults.bool(forKey: "animateOn")
    darkTheme = defaults.bool(forKey: "darkTheme")
    updateColors(self)
    
    // Force cursor to billAmount and begin editing
    clearBillAmount(self)
    
    // Start labels out of view
    if animateOn {
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
    updateHistory(self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Animate labels and fields back into view
    if animateOn {
      UIView.animate(withDuration: 0.2, delay: 0.05, options:
        [.curveEaseInOut], animations: {
        self.billAmount.center.y += self.view.bounds.width
      })
      UIView.animate(withDuration: 0.2, delay: 0.05, options:
        [.curveEaseInOut], animations: {
        self.tipName.center.x += self.view.bounds.width
        self.taxName.center.x += self.view.bounds.width
        self.taxLabel.center.x -= self.view.bounds.width
        self.tipField.center.x -= self.view.bounds.width
        self.totalName.center.x += self.view.bounds.width
        self.totalLabel.center.x -= self.view.bounds.width
        self.tipControl.center.y -= self.view.bounds.height
      })
      UIView.animate(withDuration: 0.2, delay: 0.15, options:
        [.curveEaseInOut], animations: {
        self.viewBar.alpha = 1
      })
    }
  }
  
  // Force cursor upon editing billAmount and place currency symbol
  @IBAction func clearBillAmount(_ sender: Any) {
    billAmount.text = ""
    billAmount.placeholder = NumberFormatter().currencySymbol
    billAmount.becomeFirstResponder()
  }
  
  // Force cursor upon editing tipField and place currency symbol
  @IBAction func clearTipField(_ sender: Any) {
    tipField.placeholder = NumberFormatter().currencySymbol
    tipField.becomeFirstResponder()
  }
  
  // Hide keyboard, restore bill amount on background tap
  @IBAction func onTap(_ sender: Any) {
    billAmount.endEditing(true)
    tipField.endEditing(true)
    view.endEditing(true)
    billAmount.text = formatOutput(defaults.double(forKey: "storedBill"))
  }
  
  // Save last 10 calculations to UserDefaults
  @IBAction func saveTotal(_ sender: Any) {
    // Save total to next position in default list
    let position = defaults.integer(forKey: "historyPosition")
    let key = "history" + String(position)
    let total = defaults.double(forKey: "storedTotal")
    defaults.set(total, forKey: key)
    let newPosition = (position == 10) ? 1 : (position + 1)
    defaults.set(newPosition, forKey: "historyPosition")
    defaults.synchronize()
    updateHistory(self)
  }
  
  // Update elements with chosen color scheme
  func updateColors(_ sender: Any) {
    if darkTheme {
      mainView.backgroundColor = UIColor(red: 56.0/255.0, green: 89.0/255.0,
                                         blue: 75.0/255.0, alpha: 1.0)
      shareView.backgroundColor = UIColor(red: 80.0/255.0, green: 130.0/255.0,
                                          blue: 120.0/255.0, alpha: 1.0)
      historyView.backgroundColor = UIColor(red: 73.0/255.0, green: 128.0/255.0,
                                            blue: 112.0/255.0, alpha: 1.0)
      tipControl.tintColor = .black
      billAmount.keyboardAppearance = .dark
      tipField.keyboardAppearance = .dark
    }
    else {
      mainView.backgroundColor = UIColor(red: 190.0/255.0, green: 255.0/255.0,
                                         blue: 222.0/255.0, alpha: 1.0)
      shareView.backgroundColor = UIColor(red: 170.0/255.0, green: 239.0/255.0,
                                          blue: 210.0/255.0, alpha: 1.0)
      historyView.backgroundColor = UIColor(red: 161.0/255.0, green: 239.0/255.0,
                                            blue: 205.0/255.0, alpha: 1.0)
      tipControl.tintColor = UIColor(red: 13.0/255.0, green: 106.0/255.0,
                                     blue: 24.0/255.0, alpha: 1.0)
      billAmount.keyboardAppearance = .light
      tipField.keyboardAppearance = .light
    }
  }
  
  // Update labels with current history from UserDefaults
  func updateHistory(_ sender: Any) {
    historyOne.text = formatOutput(defaults.double(forKey: "history1"))
    historyTwo.text = formatOutput(defaults.double(forKey: "history2"))
    historyThree.text = formatOutput(defaults.double(forKey: "history3"))
    historyFour.text = formatOutput(defaults.double(forKey: "history4"))
    historyFive.text = formatOutput(defaults.double(forKey: "history5"))
    historySix.text = formatOutput(defaults.double(forKey: "history6"))
    historySeven.text = formatOutput(defaults.double(forKey: "history7"))
    historyEight.text = formatOutput(defaults.double(forKey: "history8"))
    historyNine.text = formatOutput(defaults.double(forKey: "history9"))
    historyTen.text = formatOutput(defaults.double(forKey: "history10"))
    twoLabel.text = formatOutput(defaults.double(forKey: "twoLabel"))
    threeLabel.text = formatOutput(defaults.double(forKey: "threeLabel"))
    fourLabel.text = formatOutput(defaults.double(forKey: "fourLabel"))
    fiveLabel.text = formatOutput(defaults.double(forKey: "fiveLabel"))
  }
  
  // Take input from segmented control and calculate new total
  @IBAction func calculateTip(_ sender: Any) {
    let tipBar = [0.18, 0.2, 0.25]
    let tipPercent = (tipControl.selectedSegmentIndex != -1) ?
      tipBar[tipControl.selectedSegmentIndex] :
      Double(defaults.integer(forKey: "defaultTipPercent")) / 100.0
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
  
  // Format text input using current localization for currency
  func formatOutput(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    let formattedOutput = formatter.string(from: amount as NSNumber)
    return formattedOutput!
  }
  
  // Calculate total from tipAmount and billAmount and update labels
  func calculateTotal(_ sender: Any) {
    let bill = defaults.double(forKey: "storedBill")
    let tax = bill * (defaults.double(forKey: "defaultTax") / 100.0)
    let tip = defaults.double(forKey: "storedTipAmount")
    var implicitTipRate = defaults.integer(forKey: "implicitTipRate")
    let total = bill + tip + tax
    defaults.set(total, forKey: "storedTotal")
    // Caclculate implicit tip and store values in UserDefaults
    if (bill > 0.0) {
      implicitTipRate = Int((tip / (bill + tax)) * 100.0)
      defaults.set((total / 2.0), forKey: "twoLabel")
      defaults.set((total / 3.0), forKey: "threeLabel")
      defaults.set((total / 4.0), forKey: "fourLabel")
      defaults.set((total / 5.0), forKey: "fiveLabel")
    } else {
      implicitTipRate = 0
    }
    defaults.set(implicitTipRate, forKey: "implicitTipRate")
    defaults.synchronize()
    tipName.text = "Tip (" + String(implicitTipRate) + "%)"
    taxLabel.text = formatOutput(tax)
    tipField.text = formatOutput(tip)
    totalLabel.text = formatOutput(total)
    twoLabel.text = formatOutput(defaults.double(forKey: "twoLabel"))
    threeLabel.text = formatOutput(defaults.double(forKey: "threeLabel"))
    fourLabel.text = formatOutput(defaults.double(forKey: "fourLabel"))
    fiveLabel.text = formatOutput(defaults.double(forKey: "fiveLabel"))
  }
}
