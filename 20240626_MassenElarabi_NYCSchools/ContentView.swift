//
//  ContentView.swift
//  20240626_MassenElarabi_NYCSchools
//
//  Created by Massen Elarabi on 6/26/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NYCSchoolsView()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
