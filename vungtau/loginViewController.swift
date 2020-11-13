//
//  loginViewController.swift
//  vungtau
//
//  Created by Alexander Rohrig on 10/25/20.
//

import Cocoa

class loginViewController: NSViewController {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var enterButton: NSButton!
    @IBOutlet weak var passField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.string(forKey: defaultsPasswordKey) == nil {
            print("setting default password: letmein")
            defaults.set("letmein", forKey: defaultsPasswordKey)
        }
    }
    
    func login() {
        let app = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("app")) as! ViewController
        self.view.window?.contentViewController = app
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        if passField.stringValue == defaults.string(forKey: defaultsPasswordKey) {
            login()
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        NSApp.terminate(self)
    }
    
}
