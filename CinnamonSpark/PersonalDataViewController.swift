//
//  SignupViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 10/07/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class PersonalDataViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CSFastCameraControlsDelegate, UIScrollViewDelegate{

    var dataView : PersonalDataView{
        get{
            return view as PersonalDataView
        }
    }
    
    var genderPickerView : UIPickerView = UIPickerView()
    var heightPickerView : UIPickerView = UIPickerView()
    var weightPickerView : UIPickerView = UIPickerView()
    var birthdatePickerView : UIDatePicker = UIDatePicker()
    var activityPickerView : UIPickerView = UIPickerView()
    
    var titleLabel : UILabel!
    
    // Stuff for pickerView
    let genderArray = ["Male", "Female"]
    var heightsArray : [Int] {
        get{
            var numbers : [Int] = []
            for number in 150...210{
                numbers.append(number)
            }
            
            return numbers
        }
    }
    var ftHeightsArray : [Double] {
        get{
            var numbers : [Double] = []
            for number in 150...210{
                numbers.append(Double(number) * 0.0328084)
            }
            
            return numbers
        }
    }
    var heightUnitsArray : [String]{
        get{
            return ["cm", "ft"]
        }
    }
    
    var weightsArray : [Int] {
        get{
            var numbers : [Int] = []
            for number in 50...330{
                numbers.append(number)
            }
            
            return numbers
        }
    }
    var weightUnitsArray : [String]{
        get{
            return ["kg", "lb"]
        }
    }
    
    var activitiesArray : [(String, CGFloat, String)]{
        get{
            return [
                ("No exercise", 1.2, "Not active"),
                ("30 mins walk 3 days a week", 1.375, "Medium active"),
                ("30 mins exercise 4 days a week", 1.55, "Active")
//                ("50 mins hard exercise 6 days a week", 1.725, "Hard exercise")]
            ]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        dataView.genderField.tintColor = UIColor.clearColor()
        dataView.heightField.tintColor = UIColor.clearColor()
        dataView.weightField.tintColor = UIColor.clearColor()
        dataView.birthdateField.tintColor = UIColor.clearColor()
        dataView.activityField.tintColor = UIColor.clearColor()
        dataView.usernameField.tintColor = UIColor.clearColor()

        
        
        dataView.scrollView.delegate = self
        
        self.blurredBackgroundImage = UIImage(named: "onboarding-orange")
        
        birthdatePickerView.datePickerMode = .Date
        birthdatePickerView.setDate(NSDate(year: 1990, month: 01, day: 01, hour: 0, minute: 0, second: 0), animated: false)
        
        birthdatePickerView.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        birthdatePickerView.maximumDate = NSDate(year: 2004, month: 12, day: 31)
        
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        
        activityPickerView.delegate = self
        activityPickerView.dataSource = self
        
//        birthdatePickerView.delegate = self
//        birthdatePickerView.dataSource = self
        
        dataView.genderField.allowsEditingTextAttributes = false
        dataView.heightField.allowsEditingTextAttributes = false
        dataView.weightField.allowsEditingTextAttributes = false
        dataView.birthdateField.allowsEditingTextAttributes = false
        
        dataView.genderField.layer.borderColor = UIColor.whiteColor().CGColor
        dataView.genderField.layer.borderWidth = 1
        dataView.heightField.layer.borderColor = UIColor.whiteColor().CGColor
        dataView.heightField.layer.borderWidth = 1
        dataView.weightField.layer.borderColor = UIColor.whiteColor().CGColor
        dataView.weightField.layer.borderWidth = 1
        dataView.birthdateField.layer.borderColor = UIColor.whiteColor().CGColor
        dataView.birthdateField.layer.borderWidth = 1
        dataView.usernameField.layer.borderColor = UIColor.whiteColor().CGColor
        dataView.usernameField.layer.borderWidth = 1
        dataView.activityField.layer.borderColor = UIColor.whiteColor().CGColor
        dataView.activityField.layer.borderWidth = 1
        
        
        dataView.genderField.inputView = genderPickerView
        dataView.heightField.inputView = heightPickerView
        dataView.weightField.inputView = weightPickerView
        dataView.birthdateField.inputView = birthdatePickerView
        dataView.activityField.inputView = activityPickerView
        
        
        let cameraControls = CSFastCameraControls(frame: CGRectMake(0, 0, 400, 60))
        cameraControls.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        cameraControls.shutterButton.hidden = true
        
        titleLabel = UILabel(frame: CGRectMake(0, 0, 40, 40))
        titleLabel.font = DefaultFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Next"
        cameraControls.rightControl.addSubview(titleLabel)
        cameraControls.delegate = self
        
        dataView.genderField.inputAccessoryView = cameraControls
        dataView.heightField.inputAccessoryView = cameraControls
        dataView.weightField.inputAccessoryView = cameraControls
        dataView.birthdateField.inputAccessoryView = cameraControls
        dataView.usernameField.inputAccessoryView = cameraControls
        dataView.activityField.inputAccessoryView = cameraControls
        
        dataView.genderField.delegate = self
        dataView.heightField.delegate = self
        dataView.weightField.delegate = self
        dataView.birthdateField.delegate = self
        dataView.activityField.delegate = self
        
        dataView.genderField.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        if(pickerView === genderPickerView){
            return 1
        }
        if(pickerView === heightPickerView){
            return 2
        }
        if(pickerView === weightPickerView){
            return 2
        }
        if(pickerView === activityPickerView){
            return 1
        }
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView === genderPickerView){
            return 2
        }
        
        if(pickerView === heightPickerView){
            if(component == 0){
                return heightsArray.count // 150 - 210
            }
            if(component == 1){
                return heightUnitsArray.count
            }
        }
        
        if(pickerView === weightPickerView){
            if(component == 0){
                return weightsArray.count // 40 - 150
            }
            if(component == 1){
                return weightUnitsArray.count
            }
        }
        
        if(pickerView === activityPickerView){
            return activitiesArray.count
        }
        
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if(pickerView === genderPickerView){
            let genderArray = ["Male", "Female"]
            
            return genderArray[row]
        }
        
        if(pickerView === heightPickerView){
            var numbers : [Int] = heightsArray
            var units = heightUnitsArray
        
            if(component == 0){
                let selectedUnit = units[pickerView.selectedRowInComponent(1)]
                
                if(selectedUnit == "ft"){
                    return ftHeightsArray[row].format(".3")
                }
                
                return numbers[row].description
            }
            if(component == 1){
                return units[row]
            }
                
        }
        
        if(pickerView === weightPickerView){
            var numbers : [Int] = weightsArray
            
            var units = weightUnitsArray
            
            if(component == 0){
                return numbers[row].description
            }
            if(component == 1){
                return units[row]
            }
            
        }
        
        if(pickerView === activityPickerView){
            return activitiesArray[row].0
        }
        
        return "Ciao"
    }
    
    
    func datePickerValueChanged(sender: AnyObject?){
        let date = birthdatePickerView.date
        dataView.birthdateField.text = "\(date.day()).\(date.month()).\(date.year())"
        
        if(dataView.genderField.text != "?" && dataView.heightField.text != "?" && dataView.weightField.text != "?" && dataView.birthdateField.text != "?"){
            titleLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        println("Selected picker value")
        
        let selectedRow = pickerView.selectedRowInComponent(0)
        
        if(pickerView === genderPickerView){
            dataView.genderField.text = genderArray[selectedRow]
        }
        
        if(pickerView === heightPickerView){
            
            let selectedUnit = heightUnitsArray[pickerView.selectedRowInComponent(1)]
            
            if(selectedUnit == "cm"){
                dataView.heightField.text = "\(heightsArray[selectedRow]) \(selectedUnit)"
            }else if(selectedUnit == "ft"){
                let selectedHeight = ftHeightsArray[selectedRow].format(".3")
                dataView.heightField.text = "\(selectedHeight) \(selectedUnit)"
            }
            
            if(component == 1){
                pickerView.reloadComponent(0)
            }
        }
        
        if(pickerView === weightPickerView){
            let selectedUnit = weightUnitsArray[pickerView.selectedRowInComponent(1)]
            
            dataView.weightField.text = "\(weightsArray[selectedRow]) \(selectedUnit)"
        }
        
        if(pickerView === activityPickerView){
            dataView.activityField.text = "\(activitiesArray[selectedRow].2)"
        }
        
        
        if(didFillInformation()){
            titleLabel.textColor = UIColor.whiteColor()
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func calorieIntakeForGender(gender: String!, heightInCm height: Int, weightInKg weight: Int, age: Int, activityLevel: CGFloat) -> Int{
        var result = 1800 // An average
        
        let floatHeight = CGFloat(height)
        let floatWeight = CGFloat(weight)
        let floatAge = CGFloat(age)
        
        println(gender)
        
        if(gender == "Male"){
            var floatResult : CGFloat = 10.0 * floatWeight + (6.25 * floatHeight) - (5.0 * floatAge) + 5.0
            floatResult *= activityLevel
            
            result = Int(floatResult)
        }else if(gender == "Female"){
            var floatResult : CGFloat = 10.0 * floatWeight + (6.25 * floatHeight) - (5.0 * floatAge) - 161.0
            floatResult *= activityLevel
            
            result = Int(floatResult)
        }
        
        return result
    }
    
    
    func carbsIntakeForCalorieIntake(calorieIntake: Int) -> Int{
        return Int(CGFloat(calorieIntake) * 0.5 / 4.0)
    }
    
    
    func didFillInformation() -> Bool{
        return (dataView.genderField.text != "?" && dataView.heightField.text != "?" && dataView.weightField.text != "?" && dataView.birthdateField.text != "?" && dataView.activityField.text != "?" && dataView.usernameField.text != "?" && dataView.usernameField.text != "")
    }
    
    func fastCameraControlsDidTapRightControl(fastCameraControls: CSFastCameraControls){
        println("Next")
        if(didFillInformation()){
            let gender      = genderArray[genderPickerView.selectedRowInComponent(0)]
            
            let selectedHeightUnit = heightUnitsArray[heightPickerView.selectedRowInComponent(1)]
            let height : NSNumber      = (selectedHeightUnit == "cm") ? heightsArray[heightPickerView.selectedRowInComponent(0)] : ftHeightsArray[heightPickerView.selectedRowInComponent(0)]
            
            let selectedWeightUnit = weightUnitsArray[weightPickerView.selectedRowInComponent(1)]
            let weight      = weightsArray[weightPickerView.selectedRowInComponent(0)]
            
            let birthdate   = birthdatePickerView.date.dateByAddingHours(5)
            
            // Calories intake
            let age = birthdate.yearsAgo()
            var heightInCm : Int!
            if(selectedHeightUnit == "cm"){
                heightInCm = heightsArray[heightPickerView.selectedRowInComponent(0)]
            }else{
                heightInCm = Int(ftHeightsArray[heightPickerView.selectedRowInComponent(0)] * 30.48)
            }
            var weightInKg : Int!
            if(selectedWeightUnit == "kg"){
                weightInKg = weightsArray[weightPickerView.selectedRowInComponent(0)]
            }else{
                let weightInLb : Double = Double(weightsArray[weightPickerView.selectedRowInComponent(0)])
                let weightInKgDouble = weightInLb * Double(0.45359237)
                weightInKg = Int(weightInKgDouble)
            }
            
            let username = dataView.usernameField.text
            
            let activityLevel = activitiesArray[activityPickerView.selectedRowInComponent(0)].1
            
            let calorieIntake = calorieIntakeForGender(gender, heightInCm: heightInCm, weightInKg: weightInKg, age: age, activityLevel: activityLevel)
            
            var carbsGoal = carbsIntakeForCalorieIntake(calorieIntake)
            
            carbsGoal = carbsGoal - (carbsGoal % 5)
            
            let newUser = CSUser()
            newUser.username = username
            
            // Move forward
            if let navigationController = self.navigationController as? SignupFlowViewController{
                navigationController.moveToCarbsGoalControllerWithUser(newUser, carbsGoal: carbsGoal)
            }
            
        }else{
            if(dataView.genderField.isFirstResponder()){
                dataView.heightField.becomeFirstResponder()
            }else if(dataView.heightField.isFirstResponder()){
                dataView.weightField.becomeFirstResponder()
            }else if(dataView.weightField.isFirstResponder()){
                dataView.birthdateField.becomeFirstResponder()
            }else if(dataView.birthdateField.isFirstResponder()){
                dataView.activityField.becomeFirstResponder()
            }else if(dataView.activityField.isFirstResponder()){
                dataView.usernameField.becomeFirstResponder()
            }else if(dataView.usernameField.isFirstResponder()){
                dataView.genderField.becomeFirstResponder()
            }
        }
    }
    
    func fastCameraControlsDidTapLeftControl(fastCameraControls: CSFastCameraControls){
        
    }
    
    func fastCameraControlsDidTapShutterButton(fastCameraControls: CSFastCameraControls){
        
    }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPointMake(0, scrollView.contentOffset.y), animated: false)
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField === dataView.genderField){
            
            pickerView(genderPickerView, didSelectRow: 0, inComponent: 0)
            
        }else if(textField === dataView.heightField){
            
            pickerView(heightPickerView, didSelectRow: 0, inComponent: 0)
            
        }else if(textField === dataView.weightField){
            
            pickerView(weightPickerView, didSelectRow: 0, inComponent: 0)
            
        }else if(textField === dataView.birthdateField){
            
            datePickerValueChanged(birthdatePickerView)
            
        }else if(textField === dataView.activityField){
            
            pickerView(activityPickerView, didSelectRow: 0, inComponent: 0)
            
        }

    }

}


class PersonalDataView: UIView{
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var birthdateField: UITextField!
    @IBOutlet var weightField: UITextField!
    @IBOutlet var heightField: UITextField!
    @IBOutlet var genderField: CSUneditableTextField!
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var activityField: UITextField!
    
}


class CSUneditableTextField : UITextField{
    override func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectNull
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}

