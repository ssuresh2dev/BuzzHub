//
//  PlayerSetupViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/8/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import Socket_IO_Client_Swift
import UIKit

class PlayerSetupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var keyTextField: UITextField?
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var enterGameButton: UIButton?
    @IBOutlet var submitButton: UIButton?
    @IBOutlet var waitingLabel: UILabel?
    
    let socket = SocketIOClient(socketURL: "http://45.55.138.232:8901")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterGameButton?.enabled = false
        self.enterGameButton?.hidden = true
        self.socket.connect()
        self.addHandlers()
        self.waitingLabel?.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goPressed(){
        //self.navigationController?.pushViewController(BuzzerViewController(), animated: true)
        var keyString = self.keyTextField!.text
        var nameString = self.nameTextField!.text
        self.socket.emit("joinGroup", keyString, nameString)
        self.submitButton?.enabled = false
        self.submitButton?.hidden = true
        self.waitingLabel?.text = "Waiting for Moderator..."
        
        
        
    }
    
    func addHandlers(){
        self.socket.on("moveToBuzz"){data, ack in
            self.enterGameButton?.enabled = true
            self.enterGameButton?.hidden = false
            self.waitingLabel?.text = ""
        }
        
    }
    
    @IBAction func enterGamePressed(){
        self.performSegueWithIdentifier("pushToBuzzer", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let buzzerViewController = segue.destinationViewController as! BuzzerViewController
        buzzerViewController.playerName = self.nameTextField!.text
        buzzerViewController.keyString = self.keyTextField!.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
