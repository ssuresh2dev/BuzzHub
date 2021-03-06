//
//  PlayerSetupViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/8/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import SocketIOClientSwift
import UIKit

class PlayerSetupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var keyTextField: UITextField?
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var enterGameButton: UIButton?
    @IBOutlet var submitButton: UIButton?
    @IBOutlet var waitingLabel: UILabel?
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://45.55.138.232:8901")!, options: [.Log(true), .ForcePolling(true)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
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
        let keyString = self.keyTextField!.text
        let nameString = self.nameTextField!.text
        
        self.socket.emit("joinGroup", keyString!, nameString!)
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
        buzzerViewController.playerName = self.nameTextField!.text!
        buzzerViewController.keyString = self.keyTextField!.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
