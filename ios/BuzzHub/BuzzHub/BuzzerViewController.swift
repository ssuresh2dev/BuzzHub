//
//  BuzzerViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/8/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class BuzzerViewController: UIViewController {
    let socket = SocketIOClient(socketURL: NSURL(string: "http://45.55.138.232:8901")!, options: [.Log(true), .ForcePolling(true)])
    var playerName = ""
    var keyString = ""
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var buzzButton: UIButton?
    @IBOutlet var lockoutText: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket.connect()
        self.nameLabel?.text = playerName
        self.addHandlers()
        self.lockoutText?.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buzzPressed(){
        self.socket.emit("buzz", playerName, keyString)
        self.lockoutText?.text = "You have buzzed!"
        self.view.backgroundColor = UIColor.greenColor()
        
        
    }

    func addHandlers(){
        self.socket.on("playerBuzzed"){[weak self]data, ack in
            if let name = data[0] as? String, let key = data[1] as? String
            {
                if key == self!.keyString {
                    self!.buzzButton?.enabled = false
                    self!.lockoutText?.text = "You cannot buzz right now."
                }
                if name == self!.playerName {
                    self!.lockoutText?.text = "You have buzzed!"
                }
            }

        }
        self.socket.on("buzzerReset"){[weak self]data, ack in
            if let key = data[0] as? String
            {
                if key == self!.keyString {

                self!.buzzButton?.enabled = true
                    self!.lockoutText?.text = ""
                    self!.view.backgroundColor = UIColor.whiteColor()
                    
                }
            }

        }
        self.socket.on("game over"){[weak self]data, ack in
            if let key = data[0] as? String
            {
                if key == self!.keyString {
                    self!.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
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
