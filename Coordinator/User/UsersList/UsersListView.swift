//
//  UsersListView.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-04-23.
//
import SwiftUI
import Combine

struct UsersListView: View {
    @ObservedObject var viewModel: UsersListViewModel
    
    let didClickUser = PassthroughSubject<User, Never>()
 
    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                Button(action: {
                    didClickUser.send(user)
                }) {
                    Text(user.name)
                }
            }
            .navigationBarTitle("Users")
            .onAppear()
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView(viewModel: UsersListViewModel())
    }
}
