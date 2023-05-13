//
//  ProfileFlowCoordinator.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-05-12.
//
import SwiftUI
import Combine

// Enum to identify Profile flow screen Types
enum ProfilePage: String, Identifiable {
    case main, personal, education
    
    var id: String {
        self.rawValue
    }
}

final class ProfileFlowCoordinator: ObservableObject, Hashable {
    @Published var page: ProfilePage
    
    private var id: UUID
    private var cancellables = Set<AnyCancellable>()
    
    let pushCoordinator = PassthroughSubject<ProfileFlowCoordinator, Never>()
    
    init(page: ProfilePage) {
        id = UUID()
        self.page = page
    }
    
    @ViewBuilder
    func build() -> some View {
        switch self.page {
        case .main:
            mainProfileView()
        case .personal:
            personalDetailsView()
        case .education:
            educationDetailsView()
        }
    }
    
    // MARK: Required methods for class to conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ProfileFlowCoordinator, rhs: ProfileFlowCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: View Creation Methods
    private func mainProfileView() -> some View {
        let mainView = MainProfileView()
        bind(view: mainView)
        return mainView
    }
    
    private func personalDetailsView() -> some View {
        return PersonalDetailsView()
    }
    
    private func educationDetailsView() -> some View {
        return EducationalDetailsView()
    }
    
    // MARK: View Bindings
    private func bind(view: MainProfileView) {
        view.didClickPersonal
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] didClick in
                if didClick {
                    self?.showPersonalDetails()
                }
            })
            .store(in: &cancellables)
        
        view.didClickEducation
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] didClick in
                if didClick {
                    self?.showEducationDetails()
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: Navigation Related Extensions
extension ProfileFlowCoordinator {
    private func showPersonalDetails() {
        pushCoordinator.send(ProfileFlowCoordinator(page: .personal))
    }
    
    private func showEducationDetails() {
        pushCoordinator.send(ProfileFlowCoordinator(page: .education))
    }
}
