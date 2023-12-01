//
//  SettingCoordinator.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

@Reducer
struct SettingCoordinator {
    struct State: IdentifiedRouterState, Equatable {
        static let initialState = Self(routeIDs: [.root(.settingDetail, embedInNavigationView: false)])
        var settingDetailState = SettingDetail.State()
        var settingMyInfoState = SettingMyInfo.State()
        
        var routeIDs: IdentifiedArrayOf<Route<SettingScreen.State.ID>>
        
        var routes: IdentifiedArrayOf<Route<SettingScreen.State>> {
            get {
                let routers = routeIDs.map { route -> Route<SettingScreen.State> in
                    route.map { id in
                        switch id {
                        case .settingDetail:
                            return .settingDetail(settingDetailState)
                        case .settingMyInfo:
                            return .settingMyInfo(settingMyInfoState)
                        }
                    }
                }
                return IdentifiedArray(uniqueElements: routers)
            }
            set {
                let routeIDs = newValue.map { route -> Route<SettingScreen.State.ID> in
                    route.map { id in
                        switch id {
                        case .settingDetail(let settingDetailState):
                            self.settingDetailState = settingDetailState
                            return .settingDetail
                        case .settingMyInfo(let settingMyInfoState):
                            self.settingMyInfoState = settingMyInfoState
                            return .settingMyInfo
                        }
                    }
                }
                self.routeIDs = IdentifiedArray(uniqueElements: routeIDs)
            }
        }
    }
    
    enum Action: IdentifiedRouterAction {
        case updateRoutes(IdentifiedArrayOf<Route<SettingScreen.State>>)
        case routeAction(SettingScreen.State.ID, action: SettingScreen.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .routeAction(_, action: .settingDetail(.myInfoButtonTapped)):
                state.routeIDs.push(.settingMyInfo)
                return .none
            default:
                return .none
            }
        }.forEachRoute {
            SettingScreen(environment: .test)
        }
    }
}

struct SettingCoordinatorView: View {
    let store: StoreOf<SettingCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .settingDetail:
                    CaseLet(
                        /SettingScreen.State.settingDetail,
                         action: SettingScreen.Action.settingDetail,
                         then: SettingDetailView.init(store:))
                case .settingMyInfo:
                    CaseLet(
                        /SettingScreen.State.settingMyInfo,
                         action: SettingScreen.Action.settingMyInfo,
                         then: SettingMyInfoView.init(store:))
                }
            }
        }
    }
}
