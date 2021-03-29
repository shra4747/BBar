//
//  ResponderTextField.swift
//  BBar
//
//  Created by Shravan Prasanth on 3/29/21.
//

import Foundation
import SwiftUI
import Cocoa

class FirstResponderNSSearchFieldController: NSViewController {

  @Binding var text: String

  init(text: Binding<String>) {
    self._text = text
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    let searchField = NSSearchField()
    searchField.delegate = self
    searchField.font = NSFont(name: "Ariel", size: 50)
    self.view = searchField
  }

  override func viewDidAppear() {
    self.view.window?.makeFirstResponder(self.view)
    
    view.window?.level = .floating
  }
    
//    override func viewDidDisappear() {
//        NSApp.keyWindow?.close()
//    }
}

extension FirstResponderNSSearchFieldController: NSSearchFieldDelegate {

  func controlTextDidChange(_ obj: Notification) {
    if let textField = obj.object as? NSTextField {
        if textField.stringValue.lowercased().contains("n") {
            self.text = "Next Game:"
        }
        else if textField.stringValue.lowercased().contains("t") {
            self.text = "Team Data:"
        }
        self.text = textField.stringValue + "."
    }
  }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        // End Editing
        NSApp.keyWindow?.close()
        if let textField = obj.object as? NSTextField {
            if textField.stringValue.lowercased().contains("next") || textField.stringValue.lowercased().contains("game") {
                // Next Game
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
            else if textField.stringValue.lowercased().contains("team") || textField.stringValue.lowercased().contains("data") {
                // Team Data
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
        }
    }
}

struct FirstResponderNSSearchFieldRepresentable: NSViewControllerRepresentable {

  @Binding var text: String

  func makeNSViewController(
    context: NSViewControllerRepresentableContext<FirstResponderNSSearchFieldRepresentable>
  ) -> FirstResponderNSSearchFieldController {
    return FirstResponderNSSearchFieldController(text: $text)
  }

  func updateNSViewController(
    _ nsViewController: FirstResponderNSSearchFieldController,
    context: NSViewControllerRepresentableContext<FirstResponderNSSearchFieldRepresentable>
  ) {
  }
}

extension NSSearchField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
} 
