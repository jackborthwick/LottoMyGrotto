//
//  ViewController.swift
//  LottoMyGrotto
//
//  Created by Jack Borthwick on 7/8/15.
//  Copyright (c) 2015 Jack Borthwick. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var entryArray = [Entries]()
    @IBOutlet private var tableView :UITableView!
    var hasGottenWinner = false
    
    //MARK: table view methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = self.tableView?.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "cell")
        }
        cell!.textLabel!.text = (entryArray[indexPath.row].entryNumOne + " " + entryArray[indexPath.row].entryNumTwo + " " + entryArray[indexPath.row].entryNumThree + " " + entryArray[indexPath.row].entryNumFour + " " + entryArray[indexPath.row].entryNumFive + " " + entryArray[indexPath.row].entryPowerball)
        if (hasGottenWinner) {
            cell!.detailTextLabel!.text = entryArray[indexPath.row].winStatus
        }
        return cell!
    }
    
    func newEntry (sender: UIBarButtonItem){
        var ballsToAddArray = newRandom()
        let entry = Entries()
        entry.entryNumOne = ballsToAddArray[0]
        entry.entryNumTwo = ballsToAddArray[1]
        entry.entryNumThree = ballsToAddArray[2]
        entry.entryNumFour = ballsToAddArray[3]
        entry.entryNumFive = ballsToAddArray[4]
        entry.entryPowerball = ballsToAddArray[5]
        entry.saveInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            if success {
                self.fetchEntries()
            }
            else {
            }
            
        })
    }
    
    
    func newRandom () -> [String] {
        var ballsArray = [String]()
        while ballsArray.count < 5 {
            let random = Int(arc4random_uniform(UInt32(75))+1)
            if !contains(ballsArray, "\(random)") {
                println("yesm \(random)")
                ballsArray.append("\(random)")
            }
        }
        println(ballsArray.count)
        ballsArray.append("\(Int(arc4random_uniform(UInt32(15))+1))")
        return ballsArray
    }
    
    func fetchEntries() {
        var taskQuery = PFQuery(className: "Entries")
        taskQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?,error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [Entries] {
                    self.entryArray = objects
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getWinners(sender: UIBarButtonItem) {
        var winBallArray = newRandom()
        for index in 0...self.entryArray.count-1 {
            var normBallCount = 0
            var powerballBool = false
            var toWinArray = [entryArray[index].entryNumOne,entryArray[index].entryNumTwo,entryArray[index].entryNumThree,entryArray[index].entryNumFour,entryArray[index].entryNumFive]
            var toWinPB = entryArray[index].entryPowerball
            if contains(toWinArray,winBallArray[0]){
                normBallCount++;
            }
            if contains(toWinArray,winBallArray[1]){
                normBallCount++;
            }
            if contains(toWinArray,winBallArray[2]){
                normBallCount++;
            }
            if contains(toWinArray,winBallArray[3]){
                normBallCount++;
            }
            if contains(toWinArray,winBallArray[4]){
                normBallCount++;
            }
            if toWinPB == winBallArray[5]{
                powerballBool = true;
            }
            
            if (powerballBool && normBallCount == 5){
                entryArray[index].winStatus = "Jackpot"
            }
            else if (normBallCount == 5){
                entryArray[index].winStatus = "1,000,000"
            }
            else if (powerballBool && normBallCount == 4){

                entryArray[index].winStatus = "5,000"
            }
            else if (normBallCount == 4) {
                entryArray[index].winStatus = "500"
            }
            else if (powerballBool && normBallCount == 3){
                entryArray[index].winStatus = "50"
            }
            else if ((powerballBool && normBallCount == 2) || (normBallCount == 3)){
                entryArray[index].winStatus = "5"
            }
            else if (powerballBool || (powerballBool && normBallCount == 1)){
                entryArray[index].winStatus = "2"
            }
            else if (normBallCount == 1){
                entryArray[index].winStatus = "1"
            }
            else {
                entryArray[index].winStatus = ""
            }
            println("win status is" + entryArray[index].winStatus)
        }
        hasGottenWinner = true
        self.tableView.reloadData()
    }
    //MARK: life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        fetchEntries()
        var addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newEntry:")
        var getWinnersButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "getWinners:")
        self.navigationItem.rightBarButtonItems = [addButton,getWinnersButton]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

