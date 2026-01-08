//
//  ContentView.swift
//  awesome-notch
//
//  Created by MacBook on 1/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var notchDimension: CGSize? = nil
    
    var body: some View {
        VStack {
            Text("Notch size")
            Text(
                notchDimension.map{ "width: \($0.width), height: \($0.height)"
                } ?? "no size")
            Rectangle()
                .frame(
                    width: notchDimension?.width ,
                    height: notchDimension?.height
                )
                .background(.red)
        }
        .padding()
        .onAppear {
            if let screen = NSScreen.main {
                notchDimension = screen.notchSize
            }
        }
    }
}

#Preview {
    ContentView()
}
