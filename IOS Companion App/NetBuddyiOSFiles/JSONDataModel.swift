//
//  JSONDataModel.swift
//  NetBuddy
//
//  Created by Nick Dimitrakas on 5/5/22.
//

import Foundation

struct PacketInfo: Codable {
    
    let ID: Int
    let Source: String
    let Destination: String
    let `Protocol`: `Protocol`
    let Port: Int
    let Count: Int
    
}

struct `Protocol`: Codable {
    let type: String
    let data: [Int]
}

struct PacketEntities: Codable {
    let packetInfos: [String: PacketInfo]
}

func getData() -> [Int: PacketInfo] {
    var resultingDictionary: [Int: PacketInfo] = [:]
    let sem = DispatchSemaphore.init(value: 0)
    if let url = URL(string: "http://localhost:1337/nettraffic/") {
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { sem.signal()}
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode([PacketInfo].self, from: data)
                    for packetEntity in parsedJSON {
                        resultingDictionary[packetEntity.ID] = packetEntity
                    }
                } catch {
                    print(error)
                }
            }
        }
        .resume()
        sem.wait()
    }
    return resultingDictionary
}
