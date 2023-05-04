//
//  UserDetailsViewModels.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-04-24.
//
import Combine

final class UserDetailsViewModel: ObservableObject {
    private var userID: Int
    
    @Published var profile:Profile?
    
    init(userID: Int) {
        self.userID = userID
    }
    
    func fetchProfile() {
        self.profile = Profile(id: 05,
                               name: "Jone Doe",
                               age: 25,
                               occupation: "Doctor")
    }
}

