//
//  ContentView.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 5/29/24.
//

import SwiftUI
import Foundation

func readDataFromFileToArray(atPath filePath: String) -> [String] {
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
    
    func getCurrentHourAndMinute() -> (hour: Int, minute: Int) {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        return (hour, minute)
    }
    
    func findItem(hh: Int, mm: Int) -> Int? {
        // iterate through array
        // day finishes at 3:59
        let DAY_FIRST_H = 4
        let H = hh < DAY_FIRST_H ? hh + 24 : hh
        let V = (H * 60 + mm)
        if let index = items.firstIndex(where: { item in
            let itemString = String(item)
            if itemString.count < 6 {
                return false
            }
            var h = Int(itemString.prefix(2))!
            let m = Int(itemString.prefix(5).suffix(2))!
            
            if h < DAY_FIRST_H {
                h = h + 24
            }
            return (h * 60 + m) >= V
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
                let (hh, mm) = getCurrentHourAndMinute()
                if let index = findItem(hh:hh, mm:mm) {
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
