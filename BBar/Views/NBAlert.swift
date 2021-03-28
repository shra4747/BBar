//
//  NBAlert.swift
//  BBAR
//
//  Created by Shravan Prasanth on 3/26/21.
//

import SwiftUI

struct NBAlert: View {
    @State var title: String
    @State var description: String
    @State var buttonText: String
    @State var image: String = "logo"
    var body: some View {
        VStack {
            Image(image).resizable().frame(width: 100, height: 100, alignment: .center).shadow(radius: 10)
            
            Text(title).font(.system(size: 15)).fontWeight(.bold).multilineTextAlignment(.center)
            
            Text(description).font(.system(size: 10)).padding(2).multilineTextAlignment(.center).padding(.horizontal)
            
            Button(action: {
                NSApplication.shared.keyWindow?.close()
            }) {}.buttonStyle(ColorButton(color: Color.init(hex: "#a6a6a6"), text: buttonText))
            
        }.frame(width: 250, height: 300, alignment: .center)
    }
    
    struct ColorButton: ButtonStyle {
        let color: Color
        let text: String
        func makeBody(configuration: Self.Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 5).foregroundColor(color).frame(maxWidth: 100, minHeight: 20, maxHeight: 20, alignment: .center)
                Text(text).font(.system(size: 11))
            }
        }
    }
}

struct NBAlert_Previews: PreviewProvider {
    static var previews: some View {
        NBAlert(title: "Brooklyn Nets vs. Minnisota Timberwolves", description: "On Mon, March 29th BKN vs. MIN at 7:30pm EDT.", buttonText: "Simba:)")
    }
}
