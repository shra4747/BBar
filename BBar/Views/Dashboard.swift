//
//  Dashboard.swift
//  BBar
//
//  Created by Shravan Prasanth on 3/28/21.
//

import SwiftUI

struct Dashboard: View {
    var body: some View {
        HStack(spacing: 3) {
            ZStack {
                Rectangle().frame(width:200).foregroundColor(.white)
                VStack(spacing: 40) {
                    VStack {
                        VStack(spacing: 2) {
                            Text("Dashboard").fontWeight(.semibold).foregroundColor(.black).padding(.trailing, 35).font(.system(size: 26))
                            RoundedRectangle(cornerRadius: 10).frame(width: 140, height: 3).foregroundColor(Color.init(hex: "#969696")).padding(.trailing, 24).opacity(0.6)
                        }.padding(.top, 20)
                    }
                    
                    Button(action: {
                        
                        
                    }) {
                        Text("Next Game").foregroundColor(Color(.gray))
                    }.scaleEffect(1.3).padding(.trailing, 48)
                }
            }
            Rectangle().foregroundColor(.white)
        }.frame(width: 960, height: 540, alignment: .center)
        .background(Color.init(hex: "#ebebeb")).onAppear {
            NSApp.keyWindow?.center()
            NSEvent.addGlobalMonitorForEvents(matching: [NSEvent.EventTypeMask.keyDown, NSEvent.EventTypeMask.keyUp, NSEvent.EventTypeMask.flagsChanged]) { (event) in
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
