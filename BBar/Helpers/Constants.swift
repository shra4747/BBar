//
//  Constants.swift
//  BBar
//
//  Created by Shravan Prasanth on 3/29/21.
//

import Foundation
import KeyboardShortcuts
import SwiftUI
import Cocoa

extension KeyboardShortcuts.Name {
    static let nextGame = Self("nextGame", default: .init(.n, modifiers: [.shift, .control, .option]))
    static let teamInfo = Self("teamInfo", default: .init(.t, modifiers: [.shift, .control, .option]))
    static let spotlightSearch = Self("spotlight", default: .init(.space, modifiers: [.shift, .control, .option]))
}



