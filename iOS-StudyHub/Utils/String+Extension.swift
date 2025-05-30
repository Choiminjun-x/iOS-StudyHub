//
//  String+Extension.swift
//  CardInfo
//
//  Created by 최민준(Minjun Choi) on 5/7/25.
//

import Foundation
import CryptoKit

extension String {

    func url() -> URL? {
        guard self.hasPrefix("https://") || self.hasPrefix("http://") else {
            let url = "https://" + self
            return URL(string: url) ?? URL(string: url.encodeUrl())
        }
        return URL(string: self) ?? URL(string: self.encodeUrl())
    }
    
    func encodeUrl() -> String {
        let allowedCharacterSet = (CharacterSet(charactersIn: ":/?#[]!$&’()*+,;=%-.<>\\^_`{}|~\" ").inverted)
        
        if let escapedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            return escapedString
        }
        
        return self
    }
    
    func filterEscapeSequence() -> String {
        var newString = ""
        newString = self.replacingOccurrences(of: "\0", with: "\\0")
        newString = self.replacingOccurrences(of: "\t", with: "\\t")
        newString = self.replacingOccurrences(of: "\r", with: "\\r")
        newString = self.replacingOccurrences(of: "\n", with: "\\n")
        return newString
    }
    
    func convertToDictionary() -> [String:AnyObject]? {
        guard let data = self.data(using: .utf8) else { return nil }
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
        return json
    }
    
    var sha256: String {
          let digest = SHA256.hash(data: self.data(using: .utf8) ?? .init())
          return digest.map { String(format: "%02x", $0) }.joined()
      }
}
