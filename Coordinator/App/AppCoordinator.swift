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
    
    // MARK: Flow Control Methods
    private func usersFlow() {
        let usersFlowCoordinator = UserFlowCoordinator(page: .users)
        self.bind(userCoordinator: usersFlowCoordinator)
        self.push(usersFlowCoordinator)
    }
    
    private func settingsFlow() {
        let settingsFlowCoordinator = SettingsFlowCoordinator(page: .main)
        self.bind(settingsCoordinator: settingsFlowCoordinator)
        self.push(settingsFlowCoordinator)
    }
    
    private func profileFlow() {
        let profileFlowCoordinator = ProfileFlowCoordinator(page: .main)
        self.bind(profileCoordinator: profileFlowCoordinator)
        self.push(profileFlowCoordinator)
    }
    
    // MARK: HomeView Bindings
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
    
    // MARK: Flow Coordinator Bindings
    private func bind(userCoordinator: UserFlowCoordinator) {
        userCoordinator.pushCoordinator
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinator in
                self?.push(coordinator)
            })
            .store(in: &cancellables)
    }
    
    private func bind(settingsCoordinator: SettingsFlowCoordinator) {
        settingsCoordinator.pushCoordinator
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinator in
                self?.push(coordinator)
            })
            .store(in: &cancellables)
    }
    
    private func bind(profileCoordinator: ProfileFlowCoordinator) {
        profileCoordinator.pushCoordinator
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinator in
                self?.push(coordinator)
            })
            .store(in: &cancellables)
    }
}

