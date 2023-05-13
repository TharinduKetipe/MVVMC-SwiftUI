//
//  UserDetailsViewModels.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-04-24.
//
import Combine

final class UserDetailsViewModel: ObservableObject {
    @Published var profile:Profile?
    private var userID: Int
    
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

