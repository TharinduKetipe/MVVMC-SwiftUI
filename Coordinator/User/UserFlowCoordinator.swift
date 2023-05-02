//
//  UserNavCoordinator.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-04-23.
//

import SwiftUI
import Combine

enum Page: String, Identifiable {
    case users, profile
    
    var id: String {
        self.rawValue
    }
}

class UserFlowCoordinator: ObservableObject, Hashable {
    var id: UUID
    @Published var page: Page
    
    private var cancellables = Set<AnyCancellable>()
    let showUserProfile = PassthroughSubject<UserFlowCoordinator, Never>()
    
    init(page: Page) {
        id = UUID()
        self.page = page
    }
    
    
    @ViewBuilder
    func build() -> some View {
        switch self.page {
        case .users:
            usersListView()
        case .profile:
            userDetailsView()
        }
    }
    
        func usersListView() -> some View {
            let viewModel = UsersListViewModel()
            let usersListView = UsersListView(viewModel: viewModel)
            bind(view: usersListView)
            return usersListView
        }

    
    func userDetailsView() -> some View {
        let viewModel = UserDetailsViewModel()
        let userDetailsView = UserDetailsView(viewModel: viewModel)
        return userDetailsView
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserFlowCoordinator, rhs: UserFlowCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    private func bind(view: UsersListView) {
            view.didClickUser
            .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] user in
                    self?.showUserProfile(for: user)
                })
                .store(in: &cancellables)
        }
}

extension UserFlowCoordinator {
    func showUserProfile(for: User) {
        //showUserProfile.send(UserFlowCoordinator(path: path, page: .profile))
    }
}
