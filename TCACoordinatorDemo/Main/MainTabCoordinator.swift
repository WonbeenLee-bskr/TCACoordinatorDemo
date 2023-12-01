//
//  MainTabCoordinator.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

@Reducer
struct MainTabCoordinator {
    enum Tab: Hashable {
        case portfolio
        case magazine
        case setting
    }
    
    enum Deeplink {
        case portfolio
    }
    
    enum Action {
        case portfolio(PortfolioCoordinator.Action)
        case magazine(MagazineCoordinator.Action)
        case setting(SettingCoordinator.Action)
        case deeplinkOpened(Deeplink)
        case tabSelected(Tab)
    }
    
    struct State: Equatable {
        static let initialState = State(
            portfolio: .initialState,
            magazine: .initialState,
            setting: .initialState,
            selectedTab: .portfolio
        )
        
        var portfolio: PortfolioCoordinator.State
        var magazine: MagazineCoordinator.State
        var setting: SettingCoordinator.State
        
        var selectedTab: Tab
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.portfolio, action: \.portfolio) {
            PortfolioCoordinator()
        }
        Scope(state: \.magazine, action: \.magazine) {
            MagazineCoordinator()
        }
        Scope(state: \.setting, action: \.setting) {
            SettingCoordinator()
        }
        
        Reduce { state, action in
            switch action {
            case .tabSelected(let tab):
                state.selectedTab = tab
            default:
                break
            }
            return .none
        }
    }
}

struct MainTabCoordinatorView: View {
    let store: StoreOf<MainTabCoordinator>
    
    var body: some View {
        WithViewStore(store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(get: { $0 }, send: MainTabCoordinator.Action.tabSelected)) {
                Group {
                    PortfolioCoordinatorView(
                        store: store.scope(
                            state: { $0.portfolio },
                            action: { .portfolio($0)}
                        )
                    )
                    .tag(MainTabCoordinator.Tab.portfolio)
                    .tabItem { Text("Portfolio") }
                    
                    MagazineCoordinatorView(
                        store: store.scope(
                            state: { $0.magazine },
                            action: { .magazine($0)}
                        )
                    )
                    .tag(MainTabCoordinator.Tab.magazine)
                    .tabItem { Text("Magazine") }
                    
                    SettingCoordinatorView(
                        store: store.scope(
                            state: { $0.setting },
                            action: { .setting($0) }
                        )
                    )
                    .tag(MainTabCoordinator.Tab.setting)
                    .tabItem { Text("Setting") }
                }
                .toolbarBackground(Color.yellow, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
