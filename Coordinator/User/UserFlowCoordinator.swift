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

final class UserFlowCoordinator: ObservableObject, Hashable {
    private var id: UUID
    private var userID: Int
    @Published var page: Page
    
    private var cancellables = Set<AnyCancellable>()
    let showUserProfile = PassthroughSubject<UserFlowCoordinator, Never>()
    
    init(page: Page, userID: Int = 0) {
        id = UUID()
        self.page = page
        self.userID = userID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserFlowCoordinator, rhs: UserFlowCoordinator) -> Bool {
        return lhs.id == rhs.id
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
    
    private func usersListView() -> some View {
        let viewModel = UsersListViewModel()
        let usersListView = UsersListView(viewModel: viewModel)
        bind(view: usersListView)
        return usersListView
    }
    
    private func userDetailsView() -> some View {
        let viewModel = UserDetailsViewModel(userID: userID)
        let userDetailsView = UserDetailsView(viewModel: viewModel)
        return userDetailsView
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
    private func showUserProfile(for user: User) {
        showUserProfile.send(UserFlowCoordinator(page: .profile, userID: user.id))
    }
}
