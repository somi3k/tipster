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

class SettingsViewController: UIViewController {
  
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var defaultTipLabel: UILabel!
  @IBOutlet weak var defaultTaxLabel: UILabel!
  @IBOutlet weak var animationsLabel: UILabel!
  @IBOutlet weak var darkThemeLabel: UILabel!
  @IBOutlet weak var defaultTipfield: UITextField!
  @IBOutlet weak var defaultTaxField: UITextField!
  @IBOutlet weak var animationSwitch: UISwitch!
  @IBOutlet weak var darkThemeSwitch: UISwitch!
  @IBOutlet weak var historyLabel: UIButton!
  
  // Global variable for animation
  var animateOn: Bool = true
  var darkTheme: Bool = false
  
  // Global declaration for UserDefaults
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Settings"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Round corners of text fields
    defaultTaxField.layer.cornerRadius = 10.0
    defaultTaxField.clipsToBounds = true
    defaultTipfield.layer.cornerRadius = 10.0
    defaultTipfield.clipsToBounds = true
    
    // Retrieve and set defaults
    defaultTipfield.text = String(defaults.integer(forKey:
      "defaultTipPercent")) + "%"
    defaultTaxField.text = String(defaults.double(forKey:
      "defaultTax")) + "%"
    animateOn = defaults.bool(forKey: "animateOn")
    animationSwitch.isOn = animateOn
    darkTheme = defaults.bool(forKey: "darkTheme")
    darkThemeSwitch.isOn = darkTheme
    updateColors(self)
    
    // Start labels out of view
    if animateOn {
      defaultTipLabel.center.y -= view.bounds.width
      defaultTaxLabel.center.x -= view.bounds.width
      animationsLabel.center.x -= view.bounds.width
      darkThemeLabel.center.x -= view.bounds.width
      
      defaultTipfield.center.y -= view.bounds.width
      defaultTaxField.center.x += view.bounds.width
      animationSwitch.center.x += view.bounds.width
      darkThemeSwitch.center.x += view.bounds.width
      historyLabel.center.y += view.bounds.width
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Animate labels back into view
    if animateOn {
      UIView.animate(withDuration: 0.2, delay: 0.0,
                     options: [.curveEaseInOut], animations: {
        self.defaultTipLabel.center.y += self.view.bounds.width
        self.defaultTipfield.center.y += self.view.bounds.width
        self.defaultTaxLabel.center.x += self.view.bounds.width
        self.defaultTaxField.center.x -= self.view.bounds.width
        self.animationsLabel.center.x += self.view.bounds.width
        self.animationSwitch.center.x -= self.view.bounds.width
        self.darkThemeLabel.center.x += self.view.bounds.width
        self.darkThemeSwitch.center.x -= self.view.bounds.width
        self.historyLabel.center.y -= self.view.bounds.width
      })
    }
  }
  
  // Update elements with chosen color scheme
  @IBAction func updateColors(_ sender: Any) {
    if darkTheme {
      mainView.backgroundColor = UIColor(red: 56.0/255.0, green: 89.0/255.0,
                                         blue: 75.0/255.0, alpha: 1.0)
      defaultTipfield.keyboardAppearance = .dark
      defaultTipfield.backgroundColor = UIColor(red: 140.0/255.0,
                                                green: 158.0/255.0,
                                                blue: 148.0/255.0, alpha: 1.0)
      defaultTaxField.backgroundColor = UIColor(red: 140.0/255.0,
                                                green: 158.0/255.0,
                                                blue: 148.0/255.0, alpha: 1.0)
      defaultTaxField.keyboardAppearance = .dark
      animationSwitch.thumbTintColor = .black
      animationSwitch.tintColor = .black
      animationSwitch.onTintColor = UIColor(red: 27.0/255.0, green: 54.0/255.0,
                                            blue: 46.0/255.0, alpha: 1.0)
      darkThemeSwitch.thumbTintColor = .black
      darkThemeSwitch.tintColor = .black
      darkThemeSwitch.onTintColor = UIColor(red: 27.0/255.0, green: 54.0/255.0,
                                            blue: 46.0/255.0, alpha: 1.0)
    } else {
      mainView.backgroundColor = UIColor(red: 190.0/255.0, green: 255.0/255.0,
                                         blue: 222.0/255.0, alpha: 1.0)
      defaultTipfield.keyboardAppearance = .light
      defaultTipfield.backgroundColor = UIColor(red: 217.0/255.0, green: 254.0/255.0,
                                                blue: 233.0/255.0, alpha: 1.0)
      defaultTaxField.backgroundColor = UIColor(red: 217.0/255.0, green: 254.0/255.0,
                                                blue: 233.0/255.0, alpha: 1.0)
      defaultTaxField.keyboardAppearance = .light
      animationSwitch.thumbTintColor = .white
      animationSwitch.tintColor = UIColor(red: 61.0/255.0, green: 146.0/255.0,
                                          blue: 77.0/255.0, alpha: 1.0)
      animationSwitch.onTintColor = UIColor(red: 106.0/255.0, green: 200.0/255.0,
                                            blue: 178.0/255.0, alpha: 1.0)
      darkThemeSwitch.thumbTintColor = .white
      darkThemeSwitch.tintColor = UIColor(red: 61.0/255.0, green: 146.0/255.0,
                                          blue: 77.0/255.0, alpha: 1.0)
      darkThemeSwitch.onTintColor = UIColor(red: 106.0/255.0, green: 200.0/255.0,
                                            blue: 178.0/255.0, alpha: 1.0)
    }
  }
  
  // Update animation default setting
  @IBAction func toggleAnimations(_ sender: Any) {
    defaults.set(animationSwitch.isOn, forKey: "animateOn")
    defaults.synchronize()
  }
  
  // Update dark theme default setting
  @IBAction func toggleDarkTheme(_ sender: Any) {
    defaults.set(darkThemeSwitch.isOn, forKey: "darkTheme")
    defaults.synchronize()
    updateColors(self)
  }
  
  // Force cursor upon editing defaultTipfield and place percent symbol
  @IBAction func clearTip(_ sender: Any) {
    defaultTipfield.placeholder = "%"
    defaultTipfield.becomeFirstResponder()
  }
  
  // Force cursor upon editing defaultTaxField and place percent symbol
  @IBAction func clearTax(_ sender: Any) {
    defaultTaxField.placeholder = "%"
    defaultTaxField.becomeFirstResponder()
  }
  
  // Reset view when tapping outside editing fields
  @IBAction func onTap(_ sender: Any) {
    defaultTipfield.endEditing(true)
    defaultTaxField.endEditing(true)
    defaultTaxField.text = String(defaults.double(forKey:
      "defaultTax")) + "%"
    defaultTipfield.text = String(defaults.integer(forKey:
      "defaultTipPercent")) + "%"
  }
  
  // Reset saved history totals to zero with confirmation
  @IBAction func deleteHistory(_ sender: Any) {
    let delete = UIAlertController(title: "Delete History", message:
      "All saved entried will be deleted.", preferredStyle:
      UIAlertControllerStyle.alert)
    delete.addAction(UIAlertAction(title: "Ok", style: .default, handler:
      { (action: UIAlertAction!) in
      for index in 1...10 {
        let key = "history" + String(index)
        self.defaults.set(0.0, forKey: key)
      }
      self.defaults.set(0.0, forKey: "storedBill")
      self.defaults.set(0.0, forKey: "storedTipAmount")
      self.defaults.set(0.0, forKey: "storedTotal")
      self.defaults.set(0, forKey: "implicitTipRate")
      self.defaults.set(1, forKey: "historyPosition")
      self.defaults.set(0.0, forKey: "twoLabel")
      self.defaults.set(0.0, forKey: "threeLabel")
      self.defaults.set(0.0, forKey: "fourLabel")
      self.defaults.set(0.0, forKey: "fiveLabel")
      self.defaults.synchronize()
    }))
    delete.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
      { (action: UIAlertAction!) in
    }))
    present(delete, animated: true, completion: nil)
  }
  
  // Update tax percentage default setting
  @IBAction func saveDefaultTax(_ sender: Any) {
    let taxRate = Double(defaultTaxField.text!) ?? defaults.double(forKey:
      "defaultTax")
    defaults.set(taxRate, forKey: "defaultTax")
    let bill = defaults.double(forKey: "storedBill")
    let tax = bill * (taxRate / 100.0)
    let tipAmount = (bill + tax) * ((Double(defaults.integer(forKey:
      "defaultTipPercent"))) / 100.0)
    defaults.set(tipAmount, forKey: "storedTipAmount")
    defaults.synchronize()
  }
  
  // Update tip percentage default setting
  @IBAction func saveDefaultTip(_ sender: Any) {
    let tipPercent = Int(defaultTipfield.text!) ?? defaults.integer(forKey:
      "defaultTipPercent")
    defaults.set(tipPercent, forKey: "defaultTipPercent")
    let bill = defaults.double(forKey: "storedBill")
    let taxRate = defaults.double(forKey: "defaultTax") / 100
    let tax = bill * taxRate
    let tipAmount = (bill + tax) * ((Double(defaults.integer(forKey: 
      "defaultTipPercent"))) / 100.0)
    defaults.set(tipAmount, forKey: "storedTipAmount")
    defaults.synchronize()
  }
}
