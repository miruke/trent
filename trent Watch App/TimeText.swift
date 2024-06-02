//
//  TimeText.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 5/30/24.
//

//import Foundation
import SwiftUI

struct TimeText: View {
    var entry: TimeEntry

    var body: some View {
        Text(self.entry.toText(padding: 3))
            .font(.custom("ProtoMono-SemiBold", size: 26))
            .padding()
            .foregroundStyle(Color("text.primary"))
            .listRowInsets(EdgeInsets())
    }
}

#Preview {
    TimeText(entry: TimeEntry(text: "12:00 U"))
}
