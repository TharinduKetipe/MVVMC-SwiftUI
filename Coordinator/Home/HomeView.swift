//
//  HomeView.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-05-02.
//
import SwiftUI
import Combine

struct HomeView: View {
    let didClickMenuItem = PassthroughSubject<String, Never>()
    @State var menuItems = ["Users", "Settings", "Profile"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(menuItems, id: \.self) { item in
                    Button(action: {
                        didClickMenuItem.send(item)
                    }) {
                        Text(item)
                    }
                }
            }
            .navigationBarTitle("MVVMC DEMO")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
