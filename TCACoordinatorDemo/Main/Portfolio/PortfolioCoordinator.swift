//
//  PortfolioCoordinator.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

@Reducer
struct PortfolioCoordinator {
    struct State: IdentifiedRouterState, Equatable {
        static let initialState = Self(routeIDs: [.root(.portfolioDetail, embedInNavigationView: false)])
        
        var portfolioDetailState = PortfolioDetail.State()
        var step1State = Step1.State()
        var step2State = Step2.State()
        var step3State = Step3.State()
        
        var routeIDs: IdentifiedArrayOf<Route<PortfolioScreen.State.ID>>
        
        var routes: IdentifiedArrayOf<Route<PortfolioScreen.State>> {
            get {
                let routes = routeIDs.map { route -> Route<PortfolioScreen.State> in
                    route.map { id in
                        switch id {
                        case .portfolioDetail:
                            return .portfolioDetail(portfolioDetailState)
                        case .step1:
                            return .step1(step1State)
                        case .step2:
                            return .step2(step2State)
                        case .step3:
                            return .step3(step3State)
                        }
                    }
                }
                return IdentifiedArray(uniqueElements: routes)
            }
            set {
                let routeIDs = newValue.map { route -> Route<PortfolioScreen.State.ID> in
                    route.map { id in
                        switch id {
                        case .portfolioDetail(let portfolioDetailState):
                            self.portfolioDetailState = portfolioDetailState
                            return .portfolioDetail
                        case .step1(let step1State):
                            self.step1State = step1State
                            return .step1
                        case .step2(let step2State):
                            self.step2State = step2State
                            return .step2
                        case .step3(let step3State):
                            self.step3State = step3State
                            return .step3
                        }
                    }
                }
                self.routeIDs = IdentifiedArray(uniqueElements: routeIDs)
            }
        }
    }
    
    enum Action: IdentifiedRouterAction {
        case updateRoutes(IdentifiedArrayOf<Route<PortfolioScreen.State>>)
        case routeAction(PortfolioScreen.State.ID, action: PortfolioScreen.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .routeAction(_, action: .portfolioDetail(.nextButtonTapped)):
                state.routeIDs.push(.step1)
                return .none
            case .routeAction(_, action: .step1(.nextButtonTapped)):
                state.routeIDs.push(.step2)
                return .none
            case .routeAction(_, action: .step2(.nextButtonTapped)):
                state.routeIDs.push(.step3)
                return .none
            case .routeAction(_, action: .step3(.goToSettingTabButtonTapped)):
                state.routeIDs.popToRoot()
                return .none
            default:
                return .none
            }
        }.forEachRoute {
            PortfolioScreen(environment: .test)
        }
    }
}

struct PortfolioCoordinatorView: View {
    let store: StoreOf<PortfolioCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .portfolioDetail:
                    CaseLet(
                        /PortfolioScreen.State.portfolioDetail,
                         action: PortfolioScreen.Action.portfolioDetail,
                         then: PortfolioDetailView.init(store:))
                case .step1:
                    CaseLet(
                        /PortfolioScreen.State.step1,
                         action: PortfolioScreen.Action.step1,
                         then: Step1View.init(store:))
                    
                case .step2:
                    CaseLet(
                        /PortfolioScreen.State.step2,
                         action: PortfolioScreen.Action.step2,
                         then: Step2View.init(store:))
                    
                case .step3:
                    CaseLet(
                        /PortfolioScreen.State.step3,
                         action: PortfolioScreen.Action.step3,
                         then: Step3View.init(store:))
                }
            }
        }
    }
}
