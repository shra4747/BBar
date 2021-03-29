//
//  Keys.swift
//  BBar
//
//  Created by Shravan Prasanth on 3/28/21.
//

import Foundation
import SwiftUI

struct KeyEventHandling: NSViewRepresentable {
    class KeyView: NSView {
        override var acceptsFirstResponder: Bool { true }
        override func keyDown(with event: NSEvent) {
            super.keyDown(with: event)
            print(">> key \(event.charactersIgnoringModifiers ?? "")")
        }
    }

    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        DispatchQueue.main.async { // wait till next event cycle
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}

//struct TestKeyboardEventHandling: View {
//    var body: some View {
//        Text("Hello, World!")
//            .background(KeyEventHandling())
//    }
//}
