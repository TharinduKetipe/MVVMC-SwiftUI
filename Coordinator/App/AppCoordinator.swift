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
    
    func usersFlow() {
        let usersFlowCoordinator = UserFlowCoordinator(page: .users)
        self.push(usersFlowCoordinator)
    }
    
    func settingsFlow() {
        
    }
    
    func profileFlow() {
        
    }
    
    func push<T: Hashable>(_ coordinator: T) {
        path.append(coordinator)
    }
    
    @ViewBuilder
    func build() -> some View {
        homeView()
    }
    
    func homeView() -> some View {
        let homeView = HomeView()
        bind(view: homeView)
        return homeView
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
}

