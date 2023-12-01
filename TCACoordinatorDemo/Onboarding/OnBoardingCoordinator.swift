//
//  OnBoardingCoordinator.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

@Reducer
struct OnBoardingCoordinator {
    struct State: IdentifiedRouterState, Equatable {
        static let initialState = Self(routeIDs: [.root(.onboading, embedInNavigationView: true)])
        
        var onboadingState = OnBoarding.State()
        var mainTabCoordinatorState = MainTabCoordinator.State.initialState
        
        var routeIDs: IdentifiedArrayOf<Route<OnBoardingScreen.State.ID>>
        
        var routes: IdentifiedArrayOf<Route<OnBoardingScreen.State>> {
            get {
                let routers = routeIDs.map { route -> Route<OnBoardingScreen.State> in
                    route.map { id in
                        switch id {
                        case .onboading:
                            return .onboarding(onboadingState)
                        case .mainTabCoordinator:
                            return .mainTabCoordinator(mainTabCoordinatorState)
                        }
                    }
                }
                return IdentifiedArray(uniqueElements: routers)
            }
            set {
                let routeIDs = newValue.map { route -> Route<OnBoardingScreen.State.ID> in
                    route.map { id in
                        switch id {
                        case .onboarding(let onboardingState):
                            self.onboadingState = onboardingState
                            return .onboading
                        case .mainTabCoordinator(let mainTabCoordinatorState):
                            self.mainTabCoordinatorState = mainTabCoordinatorState
                            return .mainTabCoordinator
                        }
                    }
                }
                self.routeIDs = IdentifiedArray(uniqueElements: routeIDs)
            }
        }
        
        mutating func clear() {
            mainTabCoordinatorState = .initialState
        }
        
        mutating func switchTab(to tab: MainTabCoordinator.Tab) {
            mainTabCoordinatorState.selectedTab = tab
        }
    }
    
    enum Action: IdentifiedRouterAction {
        case updateRoutes(IdentifiedArrayOf<Route<OnBoardingScreen.State>>)
        case routeAction(OnBoardingScreen.State.ID, action: OnBoardingScreen.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .routeAction(_, action: .onboarding(.loginButtonTapped)):
                state.routeIDs.push(.mainTabCoordinator)
                return .none
                
            case .routeAction(_, action: .mainTabCoordinator(
                .setting(.routeAction(_, action: .settingMyInfo(.logoutButtonTapped))))):
                
                state.routeIDs.popToRoot()
                state.clear()
                return .none
                
            case .routeAction(_, action: .mainTabCoordinator(
                .portfolio(.routeAction(_ , action: .step3(.goToSettingTabButtonTapped))))):
                
//                state.routeIDs.popTo(.mainTabCoordinator)
                state.switchTab(to: .setting)
                return .none
            default:
                return .none
            }
        }.forEachRoute {
            OnBoardingScreen(environment: .test)
        }
    }
}

struct OnBoardingCoordinatorView: View {
    let store: StoreOf<OnBoardingCoordinator>
    
    /// 이동해야 할 DestinationView 를 정의하는 곳
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .onboarding:
                    CaseLet(
                        /OnBoardingScreen.State.onboarding,
                         action: OnBoardingScreen.Action.onboarding,
                         then: OnBoardingView.init(store:))
                case .mainTabCoordinator:
                    CaseLet(
                        /OnBoardingScreen.State.mainTabCoordinator,
                         action: OnBoardingScreen.Action.mainTabCoordinator,
                         then: MainTabCoordinatorView.init(store:))
                }
            }
        }
    }
}

/// Screen 에 들어있는 화면들의 네비게이션을 관장하는 객체
/// 하위의 하위뷰의 Action을 받아 네비게이션 처리를 하는 것도 가능하다.
/// 각 흐름별로 Coordinator 를 구분해주어 화면전환 책임이 이전(NavigationStackDemo)보다 분산되었다.
