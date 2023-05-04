//
//  RoutCoordinator.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-04-23.
//
import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    @Published var path: NavigationPath
    
    private var cancellables = Set<AnyCancellable>()
    
    init(path: NavigationPath) {
        self.path = path
    }
    
    @ViewBuilder
    func build() -> some View {
        homeView()
    }
    
    private func push<T: Hashable>(_ coordinator: T) {
        path.append(coordinator)
    }
    
    private func homeView() -> some View {
        let homeView = HomeView()
        bind(view: homeView)
        return homeView
    }
    
    private func usersFlow() {
        let usersFlowCoordinator = UserFlowCoordinator(page: .users)
        self.bind(coordinator: usersFlowCoordinator)
        self.push(usersFlowCoordinator)
    }
    
    private func settingsFlow() {
        
    }
    
    private func profileFlow() {
        
    }
    
    private func bind(view: HomeView) {
        view.didClickMenuItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] item in
                switch item {
                case "Users":
                    self?.usersFlow()
                case "Settings":
                    self?.settingsFlow()
                case "Profile":
                    self?.profileFlow()
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
    
    private func bind(coordinator: UserFlowCoordinator) {
        coordinator.showUserProfile
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinator in
                self?.push(coordinator)
            })
            .store(in: &cancellables)
    }
}

