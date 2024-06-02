//
//  FileReader.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 6/2/24.
//

import Foundation

class FileReader {
    static var bundle: Bundle = Bundle.main
    var url: URL?
    
    init(_ fileName:String) {
        self.url = FileReader.bundle.url(forResource: fileName, withExtension: "txt")
    }
    
    func toArray() -> [String] {
        if self.url != nil {
            do {
                let dataFromFile = try String(contentsOfFile: self.url!.path, encoding: .utf8)
                return dataFromFile.components(separatedBy: "\n")
            } catch {
                print("Error reading data: \(error.localizedDescription)")
            }
        }
        return []
    }
}
