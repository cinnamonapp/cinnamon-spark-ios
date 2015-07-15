//
//  CSMealRecordCommentsView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 19/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMealRecordLikesView: UITableViewController {
    
    var likes : [CSLike] = []
    
    var mealRecord : CSPhoto!

    convenience init(mealRecord: CSPhoto){
        self.init()
        
        self.mealRecord = mealRecord
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Look who likes this dish"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName: "CSMealRecordLikeCell", bundle: nil), forCellReuseIdentifier: "mealRecordLikeCell")
        tableView.backgroundColor = UIColor.blackColor()
        
        tableView.separatorColor = UIColor.clearColor()
        
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
        return likes.count
    }
    
    func likeAtIndexPath(indexPath: NSIndexPath) -> CSLike{
        return likes[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mealRecordLikeCell", forIndexPath: indexPath) as CSMealRecordLikeCell
        
        let like = likeAtIndexPath(indexPath)
        
        cell.configure(like: like)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func refreshData(){
        CSAPIRequest().getMealRecordLikes(mealRecord.id, success: handleLikesRequestSuccess, failure: handleLikesRequestFailure)
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

    
    func handleLikesRequestSuccess(request: AFHTTPRequestOperation!, response: AnyObject!) -> Void {
        var likesArray = (response as NSDictionary)["likes"] as [NSDictionary]
        
        likes = []
        for (index, likeDictionary) in enumerate(likesArray){
            let like = CSLike(dictionary: likeDictionary)
            likes.append(like)
            
            refreshMealRecordWithMealRecord(like.mealRecord)
        }
        
        tableView.reloadData()
    }
    
    func handleLikesRequestFailure(request: AFHTTPRequestOperation!, error: NSError!){
        println("Error in likes api. Getting likes resulted in an error: \(error)")
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
