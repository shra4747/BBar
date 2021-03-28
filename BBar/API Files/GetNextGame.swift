//
//  NextGame.swift
//  BBAR
//
//  Created by Shravan Prasanth on 3/26/21.
//

import Foundation

extension API {
    func getNextGame(completion: @escaping ([String: Any]) -> ()) {
        
        guard let savedTeamData = UserDefaults.standard.object(forKey: "savedTeamData") else {
            print("error")
            return
        }
        let currentTeam: Dictionary<String, Dictionary<String, String>> = savedTeamData as! Dictionary<String, Dictionary<String, String>>
        
        let teamFullName = currentTeam.keys.first ?? "Atlanta Hawls"
        let iconABR = (currentTeam.values.first!)["3DABR"] ?? "ATL"
        let testEspn = (currentTeam.values)
        let stringEspn = ("\(testEspn)")
        var espnABR = ""
        
        if let range = stringEspn.range(of: "\"ESPNABR\": ") {
            let phone = stringEspn[range.upperBound...]
            espnABR = ((("\(phone)").prefix(5)).replacingOccurrences(of: "\"", with: ""))
        }
        
        print("\(teamFullName): \(iconABR), \(espnABR)")


        let link = "\(API.Links().specificTeam)\(espnABR)"
        let url = URL(string: "\(link)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) else{return}
            if let jsonDict = json as? [String: Any] {
                let id = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["id"] as! String
                let name = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["name"] as! String
                let shortName = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["shortName"] as! String
                let competitions = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["competitions"] as! [[String: Any]]
                
                let detail = (((competitions.first)!["status"] as! [String: Any])["type"] as! [String: Any])["detail"]

                let returnDict = ["id": id, "name": name, "shortName": shortName , "detail": detail]
                
                DispatchQueue.main.async {
                    completion(returnDict as [String : Any])
                }
            }
        })

        task.resume()
        
    }
    }

