//
//  SpotlightSearch.swift
//  BBar
//
//  Created by Shravan Prasanth on 3/29/21.
//

import SwiftUI

struct SpotlightSearch: View {
    @State var text = ""
    @State private var becomeFirstResponder = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0).frame(width: 600, height: 81, alignment: .center)
            ZStack {
                RoundedRectangle(cornerRadius: 10).frame(width: 590, height: 70, alignment: .center).foregroundColor(Color(.white))
                FirstResponderNSSearchFieldRepresentable(text: $text).font(.title).padding().frame(width: 580, height: 80)
            }
        }
        
    }
}

struct SpotlightSearch_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightSearch()
    }
}
