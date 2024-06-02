//
//  FileReader.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 6/2/24.
//

import Foundation

class FileReader {
    static func readToArray(file: String) -> [String] {
        if let url = Bundle.main.url(forResource: file, withExtension: "txt") {
            do {
                let dataFromFile = try String(contentsOfFile: url.path, encoding: .utf8)
                return dataFromFile.components(separatedBy: "\n")
            } catch {
                print("Error reading data: \(error.localizedDescription)")
            }
        }
        return []
    }
}
