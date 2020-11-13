//
//  ViewController.swift
//  vungtau
//
//  Created by Alexander Rohrig on 10/12/20.
//

import Cocoa

let defaultsPasswordKey = "vungtau.password"

class ViewController: NSViewController {
    
    let defaults = UserDefaults.standard
    
    let fileManager = FileManager()
    
    let onAppPath = "/Volumes/Post/Admin/David/ON/"
    let offAppPath = "/Volumes/Post/Admin/David/OFF/"
    let cleanAppPath = "/Volumes/Post/Admin/David/CLEAN.app"
    
    var conIndexes: Set<Int> = []
    var listOfApps: [String] = []
//    var disIndexes = []
    
    var loggedIn = false
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var disconnectButton: NSButton!
    @IBOutlet weak var outButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if defaults.string(forKey: defaultsPasswordKey) == nil {
//            print("setting default password: letmein")
//            defaults.set("letmein", forKey: defaultsPasswordKey)
//        }
        
        tableView.selectionHighlightStyle = .none
        
        getDirectories()
        printVolumes()
        
//        logMeIn()
    }

    override var representedObject: Any? {
        didSet {
        
        }
    }
    
    @IBAction func conPressed(_ sender: Any) {
        print(conIndexes)
        for x in conIndexes {
            var base = URL(fileURLWithPath: onAppPath)//"/Users/alexanderrohrig/Documents/employment/freelanceDeveloper/fiverr/vungtau/ON") // TESTING URL ONLY
            base.appendPathComponent(listOfApps[x])
            print(base)
            NSWorkspace.shared.open(base)
        }
    }
    
    @IBAction func disPressed(_ sender: Any) {
        for x in conIndexes {
            var base = URL(fileURLWithPath: offAppPath)//"/Users/alexanderrohrig/Documents/employment/freelanceDeveloper/fiverr/vungtau/OFF") // TESTING URL ONLY
            print(listOfApps[x])
            let m = listOfApps[x].replacingOccurrences(of: "ON", with: "OFF")
            base.appendPathComponent(m)
            print(base)
            NSWorkspace.shared.open(base)
        }
    }
    
    @IBAction func outPressed(_ sender: Any) {
        let cleanURL = URL(fileURLWithPath: cleanAppPath)//"/Users/alexanderrohrig/Documents/employment/freelanceDeveloper/fiverr/vungtau/CLEAN.app") // TESTING URL ONLY
        print(cleanURL)
        NSWorkspace.shared.open(cleanURL)
        logout()
    }
    
    func bugReport() {
        var listOfOnApps = try! fileManager.contentsOfDirectory(atPath: onAppPath)
        var listOfOffApps = try! fileManager.contentsOfDirectory(atPath: offAppPath)
        print(listOfOnApps)
        print(listOfOffApps)
        listOfOnApps.append(contentsOf: listOfOffApps)
        var dubug = listOfOnApps.joined(separator: "\n")
        //dubug.write(toFile: <#T##StringProtocol#>, atomically: true, encoding: .utf8)
    }
    
    func logMeIn() {
        let alert = NSAlert()
        alert.messageText = "Log In"
        alert.informativeText = "Enter your password"
        alert.alertStyle = .warning
        
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        let passLabel = NSTextField(labelWithString: "Password:")
        let passField = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        let stack = NSStackView(frame: NSRect(x: 0, y: 0, width: 200, height: 45))
        
        stack.addView(passField, in: .bottom)
        stack.addView(passLabel, in: .top)
        stack.orientation = .vertical
        stack.alignment = .leading
        
        alert.accessoryView = stack
        
        let response = alert.runModal()
        
        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
            if passField.stringValue == defaults.string(forKey: defaultsPasswordKey) {
                print("logged in")
                loggedIn = true
            }
            else {
                print("wrong password")
                logMeIn()
            }
        }
        else {
            // TODO: close app
        }
    }
    
    func logout() {
        loggedIn = false;
        let app = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("login")) as! loginViewController
        self.view.window?.contentViewController = app
    }
    
    func getDirectories() {
        listOfApps = try! fileManager.contentsOfDirectory(atPath: onAppPath)//"/Users/alexanderrohrig/Documents/employment/freelanceDeveloper/fiverr/vungtau/ON")
        print(listOfApps)
        if listOfApps[0] == ".DS_Store" {
            listOfApps.remove(at: 0)
        }
        tableView.reloadData()
    }
    
    func printVolumes() {
        let keys = [URLResourceKey.volumeNameKey, URLResourceKey.volumeIsRemovableKey, URLResourceKey.volumeIsEjectableKey]
        let path = fileManager.mountedVolumeURLs(includingResourceValuesForKeys: keys, options: FileManager.VolumeEnumerationOptions.produceFileReferenceURLs)
        if let urls = path as? [NSURL] {
            for url in urls {
                print(url)
            }
        }
    }
    
    // MARK: - Table View Cell Actions
    
    @objc func checkPressed(sender: NSButton) {
        if sender.state == .on {
            print("\(sender.tag) checked")
            conIndexes.insert(sender.tag)
        }
        else if sender.state == .off {
            print("\(sender.tag) unchecked")
            conIndexes.remove(sender.tag)
        }
//        tableViewRowSelected = sender.tag
//        performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "showEdit"), sender: self)
    }

}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = NSUserInterfaceItemIdentifier("check")
        guard let view = tableView.makeView(withIdentifier: cell, owner: self) as? CheckCell else { return nil }
        view.checkButton.tag = row
        view.checkButton.state = .off
        view.checkButton.title = "\(listOfApps[row])"
        return view
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return listOfApps.count
    }
}
