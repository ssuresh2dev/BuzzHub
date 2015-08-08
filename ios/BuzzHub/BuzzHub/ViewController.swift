//
//  ViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/7/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift


class ViewController: UIViewController {

    //let socket = SocketIOClient(socketURL: "localhost:8900")

    @IBAction func playAsModeratorPressed() {
        //self.navigationController?.pushViewController(ModSetupViewController(), animated: true)
        self.performSegueWithIdentifier("pushToModSetup", sender: self)
    }
    
    @IBAction func playAsParticipantPressed() {
        //self.socket.emit("buzz", playerName)
        //self.navigationController?.pushViewController(PlayerSetupViewController(), animated: true)
        self.performSegueWithIdentifier("pushToPlayerSetup", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.socket.connect()
                // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

