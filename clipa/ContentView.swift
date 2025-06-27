//
//  ContentView.swift
//  clipa
//
//  Created by Chivan Visal on 27/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clipboard")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("Clipa")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Clipboard Manager")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Clipa is running in the menu bar.\nClick the clipboard icon to access your clipboard history.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

#Preview {
    ContentView()
}
