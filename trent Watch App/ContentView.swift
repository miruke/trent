//
//  ContentView.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 5/29/24.
//

import SwiftUI


struct ContentView: View {
    let items = ["12:00 U",
                 "12:03 U",
                 "12:04 UA",
                 "12:05 E",
                 "12:06 E",
                 "12:12 E",
                 "12:22 E",
                 "12:30 E",
                 "12:32 E",
                 "12:36 E",
                 "12:44 E",
                 "12:47 E",
                 "12:54 E",
                 "12:58 E",
    ]
    @State private var scrollTarget: Int? = nil
    
    func findItem(hh: Int, mm: Int) -> Int? {
        // iterate through array
        if let index = items.firstIndex(where: { item in
            let itemString = String(item)
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
                if let index = findItem(hh:12, mm:32) {
                    withAnimation {
                        proxy.scrollTo(items[index], anchor: .top) // Scroll to the 5th item (index 4)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
