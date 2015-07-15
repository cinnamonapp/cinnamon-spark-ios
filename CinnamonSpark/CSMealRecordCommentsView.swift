//
//  CSMealRecordCommentsView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 19/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMealRecordCommentsView: SLKTextViewController {

    var comments : [CSComment] = []
    
    var mealRecord : CSPhoto!
    
    init(){
        super.init(tableViewStyle: UITableViewStyle.Plain)
        self.inverted = false
        self.title = "Comments"
    }

    required init!(coder decoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName: "CSMealRecordCommentCell", bundle: nil), forCellReuseIdentifier: "mealRecordCommentCell")
        tableView.backgroundColor = UIColor.blackColor()
        
        tableView.separatorColor = UIColor.clearColor()
        
        textInputbar.barStyle = UIBarStyle.Black
        textInputbar.textView.layer.borderWidth = 1
        textInputbar.textView.layer.borderColor = UIColor.whiteColor().CGColor
        textInputbar.textView.backgroundColor = UIColor.blackColor()
        textInputbar.textView.textColor = UIColor.whiteColor()
        textInputbar.textView.layer.cornerRadius = 0
        textInputbar.textView.font = DefaultFont?.fontWithSize(15)
        textInputbar.textView.placeholder = "Say something nice..."
        textInputbar.textView.keyboardAppearance = UIKeyboardAppearance.Dark
        
        rightButton.backgroundColor = UIColorFromHex(0x75A87F, alpha: 1)
        rightButton.titleLabel?.font = DefaultFont?.fontWithSize(15)
        rightButton.tintColor = UIColor.whiteColor()

        
        refreshData()
        
        refreshMealRecordWithMealRecord(mealRecord)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController{
            navigationController.navigationBarHidden = false
            navigationController.cs_rootViewController?.controlsHidden = true
            navigationController.cs_rootViewController?.swipeInteractionEnabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        if let navigationController = self.navigationController{
            navigationController.navigationBarHidden = true
            navigationController.cs_rootViewController?.controlsHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return comments.count
    }

    func commentAtIndexPath(indexPath: NSIndexPath) -> CSComment{
        return comments[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mealRecordCommentCell", forIndexPath: indexPath) as CSMealRecordCommentCell

        let comment = commentAtIndexPath(indexPath)
        
        cell.configure(comment: comment)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        let text : String = textView.text
        super.didPressRightButton(sender)
        
        let comment = CSComment(dictionary: [
            "message": text
        ])
        comment.user = CSUser.currentUser()
        comment.mealRecord = mealRecord

        comments.insert(comment, atIndex: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        
        println(CSPhoto.self.description())
        
        comment.save(success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.refreshData()
        }) { (request:AFHTTPRequestOperation!, error:NSError!) -> Void in
            
        }
    }
    
    func needsMealRecordDataFromAPI() -> Bool{
        return (mealRecord.URL == nil)
    }
    
    func refreshMealRecordWithMealRecord(mealRecord: CSPhoto){
        self.mealRecord = mealRecord
        
        if(!needsMealRecordDataFromAPI()){
            self.setBlurredBackgroundImageWithURL(mealRecord.photoURL(.BlurredBackground))
            tableView.backgroundColor = UIColor.clearColor()
        }
    }
    
    func refreshData(){
        CSAPIRequest().getMealRecordComments(mealRecord.id, success: handleCommentsRequestSuccess, failure: handleCommentsRequestFailure)
    }
    
    func handleCommentsRequestSuccess(request: AFHTTPRequestOperation!, response: AnyObject!) -> Void {
        var commentsArray = (response as NSDictionary)["comments"] as [NSDictionary]
        
        comments = []
        for (index, commentDictionary) in enumerate(commentsArray){
            let comment = CSComment(dictionary: commentDictionary)
            comments.append(comment)
            
            refreshMealRecordWithMealRecord( comment.mealRecord )
        }
        
        tableView.reloadData()
    }
    
    func handleCommentsRequestFailure(request: AFHTTPRequestOperation!, error: NSError!){
        println("Error in comments api. Getting comments resulted in an error: \(error)")
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
