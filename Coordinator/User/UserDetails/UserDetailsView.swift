//
//  UserDetailsView.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-04-23.
//

import SwiftUI

struct UserDetailsView: View {
    @ObservedObject var viewModel: UserDetailsViewModel
    
    var body: some View {
        Text("USER DETAILS")
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(viewModel: UserDetailsViewModel())
    }
}
