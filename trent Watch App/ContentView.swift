//
//  ContentView.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 5/29/24.
//

import SwiftUI

struct ContentView: View {
    let entries = TimeEntry.readToArray(file:"lep")

    var body: some View {
        ScrollViewReader { proxy in
            List(entries, id: \.self) { entry in
                TimeText(entry: entry)
                    .id(entry.id())
            }
            .listStyle(.carousel)
            .onTapGesture {
                if let entry = TimeEntry.findNext(entries: self.entries) {
                    withAnimation {
                        proxy.scrollTo(entry.id(), anchor: .top)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
