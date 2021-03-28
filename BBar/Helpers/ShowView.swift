//
//  ShowView.swift
//  BBAR
//
//  Created by Shravan Prasanth on 3/26/21.
//

import Foundation
import SwiftUI

struct ShowView {
    
    var selectView: AnyView
    let width: Int
    let height: Int
    let title: String = ""
    func showSelectView() {
        var window: NSWindow!

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName(title)
        window.contentView = NSHostingView(rootView: selectView)
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(true)
        window.orderFront(self)
    }
}
