//
//  ViewController.swift
//  BuzzHub
//
//  Created by SAMEER SURESH on 8/7/15.
//  Copyright (c) 2015 SAMEER SURESH. All rights reserved.
//

import UIKit
import SystemConfiguration
import Onboard


class ViewController: UIViewController {
    
    var timer = NSTimer()

    @IBAction func playAsModeratorPressed() {
        self.performSegueWithIdentifier("pushToModSetup", sender: self)
    }
    
    @IBAction func playAsParticipantPressed() {
        self.performSegueWithIdentifier("pushToPlayerSetup", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey("launchedBefore")
        if !launchedBefore  {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchedBefore")
            let firstPage = OnboardingContentViewController(title: "Welcome to BuzzHub", body: "The buzzer app for trivia games of all kinds", image: UIImage(named: "buzzhub_b_logo"), buttonText: "") {}
            
            let secondPage = OnboardingContentViewController(title: "Starting a Game", body: "Simply choose one person to moderate the game, enter the key they provide, and join the group", image: UIImage(named: "buzzhub_b_logo"), buttonText: "") {}
            
            let thirdPage = OnboardingContentViewController(title: "For the Best In-Game Experience", body: "Turn up the volume on your phone, and enter a unique name for yourself!", image: UIImage(named: "buzzhub_b_logo"), buttonText: "Dismiss") {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "background1"), contents: [firstPage, secondPage, thirdPage])
            
            onboardingVC.shouldBlurBackground = true
            onboardingVC.shouldMaskBackground = true
            onboardingVC.swipingEnabled = true
            onboardingVC.allowSkipping = true
            onboardingVC.skipHandler = {
                onboardingVC.dismissViewControllerAnimated(true, completion: nil)
            }
            self.presentViewController(onboardingVC, animated: true, completion: nil)
        }
        
        let noConnectionLabel = UILabel(frame: CGRectMake(0, -60, self.view.frame.width, 60))
        noConnectionLabel.backgroundColor = UIColor.orangeColor()
        noConnectionLabel.font = UIFont(name: "Avenir Next", size: 16)
        noConnectionLabel.textAlignment = .Center
        noConnectionLabel.text = "Checking Network Connection..."
        self.view.addSubview(noConnectionLabel)
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                noConnectionLabel.frame.origin.y += 60
            }, completion: nil)

        let connected = isConnectedToNetwork()
        if (!connected) {
            noConnectionLabel.backgroundColor = UIColor.redColor()
            noConnectionLabel.text = "Not Connected to the Internet"
        }
        else {
            noConnectionLabel.backgroundColor = UIColor.greenColor()
            noConnectionLabel.text = "Successfully Connected to Internet!"
            let delay = 2 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    noConnectionLabel.frame.origin.y -= 60
                    }, completion: nil)
            }
        }
                // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        startTimer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopTimer()
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(animateBackground), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func animateBackground() {
 
        for i in 1...11 {
            let intHeight2 = Int(self.view.frame.height / 3)
            let height2 = CGFloat(Int(arc4random_uniform(UInt32(intHeight2))))
            let strand2 = UIView(frame: CGRectMake(self.view.frame.width * (CGFloat(i)/12), -1 * height2, 2, height2))
            strand2.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(strand2)
            
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                strand2.frame.origin.y += height2
                }, completion: nil)
            UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                strand2.frame.origin.y -= height2
                }, completion: nil)
        
        }
        
    }


}

