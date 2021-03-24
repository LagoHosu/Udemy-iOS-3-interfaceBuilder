//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
//import CLTypingLabel


//viewcontroller's life cycle
// viewDidLoaded() -> viewWillAppear(like controller bar) -> viewDidAppear(like countdown timer/start animation) -> viewWillDisappear(stop animation/hiding the navitagion bar) -> vidwDidDisappear()


//app lifecycle
//app launched -> app visible -> app recedes to background -> resources reclaimed 
class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel! //cltypinglabel
    
    //just before the welcomeview shows up, the navigation bar will be hidden
    override func viewWillAppear(_ animated: Bool) {
        //calling the override function from superclass, it would be better to write the code with super
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titleLabel.text = "⚡️FlashChat"
        
        titleLabel.text = "" 
        var charIndex = 0.0
        let titleText = K.appName
        for i in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1*charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(i)
            }
            charIndex += 1
         }

        
    }
    
    
}
