//
//  Localization.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/17/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import Foundation

var localization: Localization = Localization()

class Localization {
    var localizedDict: [String: Any]
    
     init() {
        let path = Bundle.main.path(forResource: "Localizable", ofType: "strings")
        if let map = NSDictionary(contentsOfFile: path!) as? [String: Any] {
            localizedDict = map
        } else {
            localizedDict = [String: Any]()
        }
    }
    
    func getMap(key: String) -> [String: String]? {
        if let map = localizedDict[key] as? [String: String] {
            return map
        }
        return nil
    }
    
}

extension String {
    var localized: String {
        if let index1 = self.firstIndex(of: ".") {
            let key1 = String(self[self.startIndex ..< index1])
            let key2 = String(self[index(index1, offsetBy: 1) ..< self.endIndex])
            
            if let map = localization.getMap(key: key1) {
                if let localizedString = map[key2] {
                    return localizedString
                }
            }
            return "{\(key1)}.{\(key2)}"
            
        } else {
            return "{\(self)}"
        }
        
    }
}
