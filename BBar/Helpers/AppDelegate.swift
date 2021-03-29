//
//  AppDelegate.swift
//  MenuBarSwiftUI
//
//  Created by Shravan Prasanth on 3/26/21.
//

import Cocoa
import SwiftUI
import KeyboardShortcuts

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var newEntryPanel: FloatingPanel!
    var isShowingSpotlight = false

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("status"))
        }
        
//
//
        guard let _ = UserDefaults.standard.object(forKey: "savedTeamData") else {
//
            showOnboard(self)
            constructMenu()
            return
        }

        constructMenu()
        
        
        KeyboardShortcuts.onKeyDown(for: .nextGame) {
            self.getNextGame(self)
        }
        
        KeyboardShortcuts.onKeyDown(for: .teamInfo) {
            self.showTeam(self)
        }
        
        KeyboardShortcuts.onKeyDown(for: .spotlightSearch) {
            ShowView(selectView: AnyView(SpotlightSearch().focusable(false)), width: 600, height: 540, closable: false).showSelectView()
        }

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func createFloatingPanel() {
          // Create the SwiftUI view that provides the window contents.
          // I've opted to ignore top safe area as well, since we're hiding the traffic icons
          let contentView = SpotlightSearch()
              .edgesIgnoringSafeArea(.top)

          // Create the window and set the content view.
          newEntryPanel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 600, height: 81), backing: .buffered, defer: false)

          newEntryPanel.title = "Floating Panel Title"
          newEntryPanel.contentView = NSHostingView(rootView: contentView)
    }
    
    @objc func showOnboard(_ sender: Any?) {
        ShowView(selectView: AnyView(Onboard()), width: 1280, height: 720, closable: false).showSelectView()
    }
    
    @objc func showTeam(_ sender: Any?) {
        guard let savedTeamData = UserDefaults.standard.object(forKey: "savedTeamData") else {
            ShowView(selectView: AnyView(NBAlert(title: "ERROR", description: "Error getting saved team.", buttonText: "Ok.")), width: 250, height: 300, closable: true).showSelectView()
            return
        }
        
        let dict: Dictionary<String, Dictionary<String, String>> = savedTeamData as! Dictionary<String, Dictionary<String, String>>
        let values = (Array(dict.values)[0])
        let valueDict: Dictionary<String, String> = values
        
        let threeABR = (valueDict["3DABR"] ?? "Error")
        let espnABR = (valueDict["ESPNABR"] ?? "Error")
     
        let name = Array(dict.keys)[0]
        ShowView(selectView: AnyView(NBAlert(title: "\(name)", description: "ESPN: \(espnABR), ABR: \(threeABR)", buttonText: "OK!", image: "\(threeABR)")), width: 250, height: 300, closable: true).showSelectView()
    }
    
    @objc func getNextGame(_ sender: Any?) {
        guard let savedTeamData = UserDefaults.standard.object(forKey: "savedTeamData") else {
            ShowView(selectView: AnyView(NBAlert(title: "ERROR", description: "Error getting saved team.", buttonText: "Ok.")), width: 250, height: 300, closable: true).showSelectView()
            return
        }
        let ddict: Dictionary<String, Dictionary<String, String>> = savedTeamData as! Dictionary<String, Dictionary<String, String>>
        let values = (Array(ddict.values)[0])
        let valueDict: Dictionary<String, String> = values
        
        let threeABR = (valueDict["3DABR"] ?? "ATL")

        API().getNextGame(completion: { dict in
            ShowView(selectView: AnyView(NBAlert(title: dict["name"] as! String, description: "\(dict["shortName"] as! String) on \(dict["detail"] as! String)", buttonText: "Game On!", image: "\(threeABR)")), width: 250, height: 300, closable: true).showSelectView()
        })
    }
    
    @objc func showPreferences(_ sender: Any?) {
        ShowView(selectView: AnyView(HStack {
            HStack {
                KeyboardShortcuts.Recorder(for: .nextGame)
                Text("Next Game").frame(width: 80)
            }.padding()
            HStack {
                KeyboardShortcuts.Recorder(for: .teamInfo)
                Text("Team Info").frame(width: 80)
            }.padding()
        }), width: 400, height: 300, title: "Preferenes", closable: true, notFirstResponder: false).showSelectView()
    }
    
    @objc func reset(_ sender: Any?) {
        UserDefaults.standard.set(nil, forKey: "savedTeamData")
        showOnboard(self)
        
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        let nextGameMenuItem = NSMenuItem()
        nextGameMenuItem.title = "Next Game 🏀"
        nextGameMenuItem.action = #selector(AppDelegate.getNextGame(_:))
        nextGameMenuItem.setShortcut(for: .nextGame)
        menu.addItem(nextGameMenuItem)
        
        let teamDataMenuItem = NSMenuItem()
        teamDataMenuItem.title = "Team Info ℹ️"
        teamDataMenuItem.action = #selector(AppDelegate.showTeam(_:))
        teamDataMenuItem.setShortcut(for: .teamInfo)
        menu.addItem(teamDataMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Preferences 🅿️", action: #selector(AppDelegate.showPreferences(_:)), keyEquivalent: "p"))
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Reset App 🔃", action: #selector(AppDelegate.reset(_:)), keyEquivalent: "r"))
        menu.addItem(NSMenuItem(title: "Quit ✖️", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }


}

