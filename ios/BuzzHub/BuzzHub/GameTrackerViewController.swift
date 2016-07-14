//
//  GameTrackerViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/8/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import SocketIOClientSwift
import UIKit
import AVFoundation

class GameTrackerViewController: UIViewController {
    @IBOutlet var buzzLabel: UILabel?
    let socket = SocketIOClient(socketURL: NSURL(string: "http://45.55.138.232:8901")!, options: [.Log(true), .ForcePolling(true)])
    var gameKey = ""
    var audioPlayer = AVAudioPlayer()
    
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
        self.socket.on("playerBuzzed"){[weak self]data, ack in
            if let name = data[0] as? String, let key = data[1] as? String
            {
                if key == self!.gameKey {
                    self!.buzzLabel?.text = name + " Buzzed!"
                    self!.playSound()
                    
                }
                
            }
            
        }
    }
    @IBAction func resetBuzzerPressed(){
        self.socket.emit("resetBuzzers", gameKey)
        self.buzzLabel?.text = "No Current Buzzes"
        
    }
    
    @IBAction func endGamePressed(){
        self.socket.emit("end game", gameKey)
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        
    }
    
    func playSound(){
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("buzzersound", ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch{}
        
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
