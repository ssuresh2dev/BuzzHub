//
//  GameTrackerViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/8/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import Socket_IO_Client_Swift
import UIKit

class GameTrackerViewController: UIViewController {
    @IBOutlet var buzzLabel: UILabel?
    let socket = SocketIOClient(socketURL: "localhost:8900")
    var gameKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket.connect()
        self.addHandlers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addHandlers(){
        self.socket.on("playerBuzzed"){data, ack in
//            var gameKeyCompare = data[1]
//            var playerName = data[0]
            
            
        }
    }
    @IBAction func resetBuzzerPressed(){
        
    }
    
    @IBAction func endGamePressed(){
        
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
