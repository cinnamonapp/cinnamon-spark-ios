//
//  SignupViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 10/07/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CarbsGoalViewController: UIViewController, UIScrollViewDelegate, CSFastCameraControlsDelegate {
    
    var initialCarbsGoal : Int!
    var initialUser : CSUser?
    var selectedCarbsGoal : Int!
    
    var carbsGoalView : CarbsGoalView{
        get{
            return view as CarbsGoalView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blurredBackgroundImage = UIImage(named: "onboarding-orange")
        
        carbsGoalView.scrollView.delegate = self
        
        carbsGoalView.frame = UIScreen.mainScreen().bounds
        
        carbsGoalView.ringView.progress = 0
        
        selectedCarbsGoal = initialCarbsGoal
        
        setCarbsGoal(initialCarbsGoal)
        carbsGoalView.setSuggestedCarbsGoal(initialCarbsGoal)
        
        // Do any additional setup after loading the view.
        carbsGoalView.minusButton.addTarget(self, action: "decreaseCarbsGoal:", forControlEvents: UIControlEvents.TouchUpInside)
        carbsGoalView.plusButton.addTarget(self, action: "increaseCarbsGoal:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let cameraControls = CSFastCameraControls(frame: CGRectMake(0, 0, 400, 60))
        cameraControls.frame.origin.y = view.frame.height - cameraControls.frame.height
        cameraControls.frame.size.width = view.frame.width
        cameraControls.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        cameraControls.shutterButton.hidden = true
        
        let backButtonImageView = UIImageView(image: UIImage(named: "CameraBackButton"))
        backButtonImageView.frame = CGRectMake(0, 0, 40, 40)
        cameraControls.leftControl.addSubview(backButtonImageView)
        
        var titleLabel = UILabel(frame: CGRectMake(0, 0, 40, 40))
        titleLabel.font = DefaultFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Next"
        cameraControls.rightControl.addSubview(titleLabel)
        cameraControls.delegate = self
        
        carbsGoalView.addSubview(cameraControls)
        
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPointMake(0, scrollView.contentOffset.y), animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decreaseCarbsGoal(sender: AnyObject?){
        setCarbsGoal(selectedCarbsGoal - 5)
    }
    
    func increaseCarbsGoal(sender: AnyObject?){
        setCarbsGoal(selectedCarbsGoal + 5)
    }
    
    func setCarbsGoal(carbsGoal: Int){
        selectedCarbsGoal = carbsGoal
        
        carbsGoalView.carbsGoalLabel.text = "\(selectedCarbsGoal)g"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

    func fastCameraControlsDidTapLeftControl(fastCameraControls: CSFastCameraControls) {
        if let navigationController = self.navigationController{
            navigationController.popViewControllerAnimated(true)
        }
    }
    
    func fastCameraControlsDidTapRightControl(fastCameraControls: CSFastCameraControls) {
        
        if let initialUser = self.initialUser{
            
            initialUser.dailyCarbsLimit = selectedCarbsGoal
            
            CSAPIRequest().checkCurrentUserInUsingDeviceUUID { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                CSAPIRequest().updateCurrentUserWithDictionary(initialUser.toDictionary())
            }
        }
        
        // Move forward
        if let navigationController = self.navigationController as? SignupFlowViewController{
            navigationController.moveToMacronutrientsController()
        }
        
    }
    
    func fastCameraControlsDidTapShutterButton(fastCameraControls: CSFastCameraControls) {
        
    }
    
}


class CarbsGoalView: UIView{
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var carbsGoalLabel: UICountingLabel!
    @IBOutlet var ringView: RingView!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    
    @IBOutlet var suggestedCarbsGoalLabel: UILabel!
    
    func setSuggestedCarbsGoal(carbsGoalString: String!){
        suggestedCarbsGoalLabel.text = "The American Diabetes Association recommends a daily intake of \(carbsGoalString) of carbs based on your height & weight."
    }
    func setSuggestedCarbsGoal(carbsGoalMax: Int!){
        setSuggestedCarbsGoal("\(carbsGoalMax-50)-\(carbsGoalMax)g")
    }
}

