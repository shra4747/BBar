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
        
        let _ = currentTeam.keys.first ?? "Atlanta Hawks"
        let _ = (currentTeam.values.first!)["3DABR"] ?? "ATL"
        let testEspn = (currentTeam.values)
        let stringEspn = ("\(testEspn)")
        var espnABR = ""
        
        if let range = stringEspn.range(of: "\"ESPNABR\": ") {
            let phone = stringEspn[range.upperBound...]
            espnABR = ((("\(phone)").prefix(5)).replacingOccurrences(of: "\"", with: ""))
        }
        

        let link = "\(API.Links().specificTeam)\(espnABR)"
        let url = URL(string: "\(link)")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) else{return}
            if let jsonDict = json as? [String: Any] {
                let id = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["id"] as! String
                let name = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["name"] as! String
                let shortName = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["shortName"] as! String
                _ = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["competitions"] as! [[String: Any]]
                
                let ztime = (Array(arrayLiteral: ((Array(arrayLiteral: (jsonDict["team"] as? [String: Any])?["nextEvent"])))[0]).first!! as? [NSDictionary])?.first!["date"] as! String

                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
                let date = dateFormatter.date(from: ztime)

                let formatter1 = DateFormatter()
                formatter1.dateStyle = .medium
                formatter1.timeZone = .autoupdatingCurrent
                formatter1.timeStyle = .short
                
                let detail = (formatter1.string(from: date!))

                let returnDict = ["id": id, "name": name, "shortName": shortName , "detail": detail]
                
                
                
                DispatchQueue.main.async {
                    completion(returnDict as [String : Any])
                }
            }
        })

        task.resume()
        
    }
    }

