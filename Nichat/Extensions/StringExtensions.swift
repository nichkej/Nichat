//
//  StringExtensions.swift
//  Nichat
//
//  Created by Nikola Jovicevic on 22.7.23..
//

import Foundation

extension String {
    func prefixes() -> [String] {
        // used when checking whether a search query responds to a users
        // prefixArray["nichke"] = ["n", "ni", "nic", "nich", "nichk", "nichke"]
        // we store every valid search query which yields x inside x.prefixArray()
        var prefixArray: [String] = []
        for length in 1 ... self.count {
            prefixArray.append(String(self.prefix(length)))
        }
        return prefixArray
    }
    
    func isValidUsername() -> Bool {
        // valid username consists only of lowercase letters and digits
        for index in self.indices {
            if !self[index].isASCII || (!(self[index] >= "0" && self[index] <= "9") && !(self[index] >= "a" && self[index] <= "z")) {
                return false
            }
        }
        return true
    }
}
