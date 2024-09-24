//
//  ContentView.swift
//  DuplicatedContacts
//
//  Created by Javid on 22.09.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                deleteDuplicateContacts()
            }) {
                Text("Benzer Kişileri Sil")
            }
            
            .padding()
        }
    }
    
}
