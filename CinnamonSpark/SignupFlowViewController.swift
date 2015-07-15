//
//  SignupFlowViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 10/07/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class SignupFlowViewController: UINavigationController {
    
    var signupDelegate : SignupFlowViewControllerDelegate?
    
    var personalDataViewController      : PersonalDataViewController!
    var carbsGoalViewController         : CarbsGoalViewController!
    var macronutrientsViewController    : MacronutrientsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Init
        personalDataViewController = PersonalDataViewController(nibName: "PersonalDataViewController", bundle: nil)
        carbsGoalViewController = CarbsGoalViewController(nibName: "CarbsGoalViewController", bundle: nil)
        macronutrientsViewController = MacronutrientsViewController(nibName: "MacronutrientsViewController", bundle: nil)
        
        setViewControllers([personalDataViewController], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func didCompleteSignup(){
        if let signupDelegate = self.signupDelegate{
            signupDelegate.signupFlowViewController(self, didCompleteSignupWithEvent: SignupFlowEvent.Success)
        }
    }
    
    func moveToCarbsGoalControllerWithUser(user: CSUser?, carbsGoal: Int){
        
        carbsGoalViewController.initialCarbsGoal = carbsGoal
        carbsGoalViewController.initialUser = user
        
        pushViewController(carbsGoalViewController, animated: true)
    }
    
    func moveToMacronutrientsController(){
        pushViewController(macronutrientsViewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


enum SignupFlowEvent : Int{
    case Success, Failure
}

protocol SignupFlowViewControllerDelegate: NSObjectProtocol{
    func signupFlowViewController(
        signupFlowViewController: SignupFlowViewController,
        didCompleteSignupWithEvent event: SignupFlowEvent
    )
}