//
//  Onboard.swift
//  BBAR
//
//  Created by Shravan Prasanth on 3/26/21.
//

import SwiftUI
import Foundation

struct Onboard: View {
    let teams: [[Dictionary<String, Dictionary<String, String>>]] = [
        [
            ["Atlanta Hawks": ["3DABR": "ATL", "ESPNABR": "atl"]],
            ["Boston Celtics": ["3DABR": "BOS", "ESPNABR": "bos"]],
            ["Brooklyn Nets": ["3DABR": "BKN", "ESPNABR": "bkn"]],
            ["Charlotte Hornets": ["3DABR": "CHA", "ESPNABR": "cha"]],
            ["Chicago Bulls": ["3DABR": "CHI", "ESPNABR": "chi"]],
            ["Cleveland Cavaliers": ["3DABR": "CLE", "ESPNABR": "cle"]],
            ["Dallas Mavericks": ["3DABR": "DAL", "ESPNABR": "dal"]],
            ["Denver Nuggets": ["3DABR": "DEN", "ESPNABR": "den"]]
        ],
        [
            ["Detroit Pistons": ["3DABR": "DET", "ESPNABR": "det"]],
            ["Golden-State Warriors": ["3DABR": "GSW", "ESPNABR": "gs"]],
            ["Houston Rockets": ["3DABR": "HOU", "ESPNABR": "hou"]],
            ["Indiana Pacers": ["3DABR": "IND", "ESPNABR": "ind"]],
            ["Los-Angeles Clippers": ["3DABR": "LAC", "ESPNABR": "lac"]],
            ["Los-Angeles Lakers": ["3DABR": "LAL", "ESPNABR": "lal"]],
            ["Memphis Grizzlies": ["3DABR": "MEM", "ESPNABR": "mem"]],
            ["Miami Heat": ["3DABR": "MIA", "ESPNABR": "mia"]]
        ],
        [
            ["Milwaukee Bucks": ["3DABR": "MIL", "ESPNABR": "mil"]],
            ["Minnesota Timberwolves": ["3DABR": "MIN", "ESPNABR": "min"]],
            ["New-Orleans Pelicans": ["3DABR": "NOP", "ESPNABR": "no"]],
            ["New-York Knicks": ["3DABR": "NYK", "ESPNABR": "ny"]],
            ["Oklahoma-City Thunder": ["3DABR": "OKC", "ESPNABR": "okc"]],
            ["Orlando Magic": ["3DABR": "ORL", "ESPNABR": "orl"]],
            ["Philadelphia Sixers": ["3DABR": "PHI", "ESPNABR": "phi"]],
            ["Phoenix Suns": ["3DABR": "PHO", "ESPNABR": "phx"]]
        ],
        [
            ["Portland Trail-Blazers": ["3DABR": "POR", "ESPNABR": "por"]],
            ["Sacramento Kings": ["3DABR": "SAC", "ESPNABR": "sac"]],
            ["San-Antonio Spurs": ["3DABR": "SAN", "ESPNABR": "sa"]],
            ["Toronto Raptors": ["3DABR": "TOR", "ESPNABR": "tor"]],
            ["Utah Jazz": ["3DABR": "UTA", "ESPNABR": "uth"]],
            ["Washington Wizards": ["3DABR": "WAS", "ESPNABR": "wsh"]]
        ]
    ]
    @State var text = "Choose your favorite Team!"
    @State var isClicked = false
    @State var currentTeam: Dictionary<String, Dictionary<String, String>> = [:]
    @State var showingAlert = false
    var body: some View {
        VStack {
            HStack {
                Text(text).fontWeight(.bold).font(.system(size: 50)).padding()
                if isClicked {
                    Button(action: {
                        UserDefaults.standard.set(currentTeam, forKey: "savedTeamData")
//                        API().getNextGame()
                        NSApplication.shared.keyWindow?.close()
                        ShowView(selectView: AnyView(NBAlert(title: "NBA.Bar completed set up.", description: "The application has finished the setup process. Enjoy!", buttonText: "Dismiss")), width: 250, height: 300, closable: true).showSelectView()
                    }) {
                        Text("Select")
                    }
                }
                else {}
            }
            VStack {
                ForEach(teams, id: \.self) { section in
                    
                    HStack {
                        ForEach(section, id: \.self) { team in
                            Button(action: {
                                text = String(Array(team.keys)[0])
                                isClicked = true
                                currentTeam = team
                            }) {}.buttonStyle(NormalButtonStyle(team: String(Array(team.values)[0]["3DABR"] ?? "BKN")))
                        }
                    }
                }
            }
        }.frame(width: 1280, height: 720, alignment: .center)
    }
    
    
    struct NormalButtonStyle: ButtonStyle {
        let team: String
        func makeBody(configuration: Self.Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 30).frame(width: 100, height: 100, alignment: .center).foregroundColor(Color.init(hex: "#dedede")).shadow(radius: 10)
                Image(team).resizable().renderingMode(.original).frame(width: 80, height: 80, alignment: .center)
            }.padding()
        }
    }
}

struct Onboard_Previews: PreviewProvider {
    static var previews: some View {
        Onboard()
    }
}
