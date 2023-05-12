//
//  SettingsFlowCoordinator.swift
//  Coordinator
//
//  Created by Tharindu Ketipearachchi on 2023-05-12.
//
import SwiftUI
import Combine

enum SettingsPage: String, Identifiable {
    case main, privacy, custom
    
    var id: String {
        self.rawValue
    }
}

final class SettingsFlowCoordinator: ObservableObject, Hashable {
    private var id: UUID
    @Published var page: SettingsPage
    
    private var cancellables = Set<AnyCancellable>()
    let pushCoordinator = PassthroughSubject<SettingsFlowCoordinator, Never>()
    
    init(page: SettingsPage) {
        id = UUID()
        self.page = page
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SettingsFlowCoordinator, rhs: SettingsFlowCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    @ViewBuilder
    func build() -> some View {
        switch self.page {
        case .main:
            mainSettingsView()
        case .privacy:
            privacySettingsView()
        case .custom:
            customSettingsView()
        }
    }
    
    private func mainSettingsView() -> some View {
        let mainView = MainSettingsView()
        bind(view: mainView)
        return mainView
    }
    
    private func privacySettingsView() -> some View {
        return PrivacySettingsView()
    }
    
    private func customSettingsView() -> some View {
        return CustomSettingsView()
    }
    
    private func bind(view: MainSettingsView) {
        view.didClickPrivacy
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] didClick in
                if didClick {
                    self?.showPrivacySettings()
                }
            })
            .store(in: &cancellables)
        
        view.didClickCustom
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] didClick in
                if didClick {
                    self?.showCustomSettings()
                }
            })
            .store(in: &cancellables)
    }
}

extension SettingsFlowCoordinator {
    private func showPrivacySettings() {
        pushCoordinator.send(SettingsFlowCoordinator(page: .privacy))
    }
    
    private func showCustomSettings() {
        pushCoordinator.send(SettingsFlowCoordinator(page: .custom))
    }
}
