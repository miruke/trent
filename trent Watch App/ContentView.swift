//
//  ContentView.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 5/29/24.
//

import SwiftUI
import Foundation

func readDataFromFileToArray(atPath filePath: String) -> [String] {
    let url = Bundle.main.url(forResource: filePath, withExtension: "txt")
    let path = Bundle.main.url(forResource: filePath, withExtension: "txt")!.path
    do {
        let dataFromFile = try String(contentsOfFile: path, encoding: .utf8)
        
        let dataArray = dataFromFile.components(separatedBy: "\n")
        
        return dataArray
    } catch {
        print("Error reading data: \(error.localizedDescription)")
        return []
    }
}

struct ContentView: View {
    let items = readDataFromFileToArray(atPath:"lep")
    
    func findItem(hh: Int, mm: Int) -> Int? {
        // iterate through array
        if let index = items.firstIndex(where: { item in
            let itemString = String(item)
            if itemString.count < 6 {
                return false
            }
            let h = Int(itemString.prefix(2))!
            let m = Int(itemString.prefix(5).suffix(2))!
            return h == hh && m >= mm
        }) {
            return index
        }
        return nil
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List(items, id: \.self) { item in
                TimeText(text:item)
                    .id(item)
            }
            .listStyle(.carousel)
            .onTapGesture {
                if let index = findItem(hh:7, mm:22) {
                    withAnimation {
                        proxy.scrollTo(items[index], anchor: .top)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
