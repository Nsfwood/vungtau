//
//  CheckCell.swift
//  vungtau
//
//  Created by Alexander Rohrig on 10/14/20.
//

import Cocoa

class CheckCell: NSTableCellView {

    @IBOutlet weak var checkButton: NSButton!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        checkButton.action = #selector(ViewController.checkPressed(sender:))
    }
    
}
