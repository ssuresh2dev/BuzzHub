//
//  BuzzerViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/8/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class BuzzerViewController: UIViewController {
    
    let socket = SocketIOClient(socketURL: "http://45.55.138.232:8900")
    var playerName = ""
    var keyString = ""
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var buzzButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket.connect()
        self.nameLabel?.text = playerName
        self.addHandlers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buzzPressed(){
        self.socket.emit("buzz", playerName, keyString)
        
    }

    func addHandlers(){
        self.socket.on("playerBuzzed"){[weak self]data, ack in
            if let name = data?[0] as? String, let key = data?[1] as? String
            {
                if key == self!.keyString {
                    self!.buzzButton?.enabled = false
                }
            }

        }
        self.socket.on("buzzerReset"){[weak self]data, ack in
            if let key = data?[0] as? String
            {
                if key == self!.keyString {

                self!.buzzButton?.enabled = true
                    
                }
            }

        }
        self.socket.on("game over"){[weak self]data, ack in
            if let key = data?[0] as? String
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
