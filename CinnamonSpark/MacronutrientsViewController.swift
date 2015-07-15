//
//  MacronutrientsViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 13/07/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class MacronutrientsViewController: UIViewController, CSFastCameraControlsDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.blurredBackgroundImage = UIImage(named: "onboarding-mix")
        
        
        let cameraControls = CSFastCameraControls(frame: CGRectMake(0, 0, 400, 60))
        cameraControls.frame.origin.y = UIScreen.mainScreen().bounds.height - cameraControls.frame.height
        cameraControls.frame.size.width = UIScreen.mainScreen().bounds.width
        cameraControls.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        cameraControls.shutterButton.hidden = true
        
        var titleLabel = UILabel(frame: CGRectMake(0, 0, 40, 40))
        titleLabel.font = DefaultFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Next"
        cameraControls.rightControl.addSubview(titleLabel)
        cameraControls.delegate = self
        
        view.addSubview(cameraControls)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fastCameraControlsDidTapLeftControl(fastCameraControls: CSFastCameraControls) {
        
    }
    
    func fastCameraControlsDidTapShutterButton(fastCameraControls: CSFastCameraControls) {
        
    }
    
    func fastCameraControlsDidTapRightControl(fastCameraControls: CSFastCameraControls) {
        println("Finished")
        if let navigationController = self.navigationController as? SignupFlowViewController{
            navigationController.didCompleteSignup()
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

}
