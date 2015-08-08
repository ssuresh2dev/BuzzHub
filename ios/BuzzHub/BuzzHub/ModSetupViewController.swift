//
//  ModSetupViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/8/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class ModSetupViewController: UIViewController, UITableViewDataSource {
    let socket = SocketIOClient(socketURL: "http://45.55.138.232:8900")
    
    var playersArray = [String]()
    var gameKeyString = ""
    
    @IBOutlet var keyText: UILabel?
    @IBOutlet var namesTable: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let gameKey = randomStringWithLength()
        self.keyText?.text = gameKey as String
        gameKeyString = gameKey as String
        self.socket.connect()
        
        socket.on("connect") {data, ack in
            self.socket.emit("keyGenerate", gameKey)
            self.addHandlers()
        }

        // Do any additional setup after loading the view.
    }
    
    func addHandlers(){
        self.socket.on("addNew"){data, ack in
            
            var newPlayerName = data?[1] as? String
            self.playersArray.append(newPlayerName!)
            self.namesTable?.reloadData()
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGamePressed(){
        //self.navigationController?.pushViewController(GameTrackerViewController(), animated: true)
        self.socket.emit("startGame", self.keyText!.text!)
        self.performSegueWithIdentifier("pushToGameTracker", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameTrackerViewController = segue.destinationViewController as! GameTrackerViewController
        gameTrackerViewController.gameKey = self.gameKeyString
    }
    
    func randomStringWithLength () -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: 8)
        
        for (var i=0; i < 8; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default , reuseIdentifier: "playerCell")
        cell.textLabel?.text = playersArray[indexPath.row]
        return cell
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
