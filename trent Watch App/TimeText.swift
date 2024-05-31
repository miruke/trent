//
//  TimeText.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 5/30/24.
//

//import Foundation
import SwiftUI

struct TimeText: View {
    var text: String

    var body: some View {
        Text(self.text)
            .font(.custom("ProtoMono-SemiBold", size: 26))
//            .border(Color.gray, width: 1)
            .padding()
            .foregroundStyle(Color("text.primary"))
//            .background(Color("list.primary"))
            
            .cornerRadius(15)
            .listRowInsets(EdgeInsets())
    }
}

#Preview {
    TimeText(text: "12:00 U 3'")
}
