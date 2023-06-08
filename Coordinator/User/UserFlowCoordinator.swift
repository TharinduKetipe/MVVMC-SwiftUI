//
//  UserNavCoordinator.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-04-23.
//
import SwiftUI
import Combine

// Enum to identify User flow screen Types
enum UserPage: String, Identifiable {
    case users, profile
    
    var id: String {
        self.rawValue
    }
}

final class UserFlowCoordinator: ObservableObject, Hashable {
    @Published var page: UserPage
    
    private var id: UUID
    private var userID: Int?
    private var cancellables = Set<AnyCancellable>()
    
    let pushCoordinator = PassthroughSubject<UserFlowCoordinator, Never>()
    
    init(page: UserPage, userID: Int? = nil) {
        id = UUID()
        self.page = page
        
        if page == .profile {
            guard let userID = userID else {
                fatalError("userID must be provided for profile type")
            }
            self.userID = userID
        }
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
    
    // MARK: Required methods for class to conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserFlowCoordinator, rhs: UserFlowCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: View Creation Methods
    private func usersListView() -> some View {
        let viewModel = UsersListViewModel()
        let usersListView = UsersListView(viewModel: viewModel)
        bind(view: usersListView)
        return usersListView
    }
    
    private func userDetailsView() -> some View {
        let viewModel = UserDetailsViewModel(userID: userID ?? 0)
        let userDetailsView = UserDetailsView(viewModel: viewModel)
        return userDetailsView
    }
    
    // MARK: View Bindings
    private func bind(view: UsersListView) {
        view.didClickUser
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.showUserProfile(for: user)
            })
            .store(in: &cancellables)
    }
}

// MARK: Navigation Related Extensions
extension UserFlowCoordinator {
    private func showUserProfile(for user: User) {
        pushCoordinator.send(UserFlowCoordinator(page: .profile, userID: user.id))
    }
}
