//
//  AppDelegate.swift
//  MenuBarSwiftUI
//
//  Created by Shravan Prasanth on 3/26/21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        
        guard let _ = UserDefaults.standard.object(forKey: "savedTeamData") else {
            showOnboard(self)
            constructMenu()
            return
        }

        constructMenu()

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @objc func showOnboard(_ sender: Any?) {
        ShowView(selectView: AnyView(Onboard()), width: 1280, height: 720).showSelectView()
    }
    
    @objc func showTeam(_ sender: Any?) {
        guard let savedTeamData = UserDefaults.standard.object(forKey: "savedTeamData") else {
            ShowView(selectView: AnyView(NBAlert(title: "ERROR", description: "Error getting saved team.", buttonText: "Ok.")), width: 250, height: 300).showSelectView()
            return
        }
        
        let dict: Dictionary<String, Dictionary<String, String>> = savedTeamData as! Dictionary<String, Dictionary<String, String>>
        let values = (Array(dict.values)[0])
        let valueDict: Dictionary<String, String> = values
        
        let threeABR = (valueDict["3DABR"] ?? "Error")
        let espnABR = (valueDict["ESPNABR"] ?? "Error")
     
        let name = Array(dict.keys)[0]
        ShowView(selectView: AnyView(NBAlert(title: "\(name)", description: "ESPN: \(espnABR), ABR: \(threeABR)", buttonText: "OK!", image: "\(threeABR)")), width: 250, height: 300).showSelectView()
    }
    
    @objc func getNextGame(_ sender: Any?) {
        guard let savedTeamData = UserDefaults.standard.object(forKey: "savedTeamData") else {
            ShowView(selectView: AnyView(NBAlert(title: "ERROR", description: "Error getting saved team.", buttonText: "Ok.")), width: 250, height: 300).showSelectView()
            return
        }
        let ddict: Dictionary<String, Dictionary<String, String>> = savedTeamData as! Dictionary<String, Dictionary<String, String>>
        let values = (Array(ddict.values)[0])
        let valueDict: Dictionary<String, String> = values
        
        let threeABR = (valueDict["3DABR"] ?? "ATL")

        API().getNextGame(completion: { dict in
            ShowView(selectView: AnyView(NBAlert(title: dict["name"] as! String, description: "\(dict["shortName"] ?? "ERROR") on \(dict["detail"] ?? "ERROR")", buttonText: "Game On!", image: "\(threeABR)")), width: 250, height: 300).showSelectView()
        })
    }
    
    @objc func reset(_ sender: Any?) {
        UserDefaults.standard.set(nil, forKey: "savedTeamData")
        showOnboard(self)
    }
    
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Next Game", action: #selector(AppDelegate.getNextGame(_:)), keyEquivalent: "n"))
        menu.addItem(NSMenuItem(title: "Team Data", action: #selector(AppDelegate.showTeam(_:)), keyEquivalent: "t"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Reset App", action: #selector(AppDelegate.reset(_:)), keyEquivalent: "r"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

      statusItem.menu = menu
    }


}

