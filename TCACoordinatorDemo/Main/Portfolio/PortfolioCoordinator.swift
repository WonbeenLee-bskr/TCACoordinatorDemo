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
        static let initialState = Self(routeIDs: [.root(.portfolioList, embedInNavigationView: false)])
        
        var portfolioListState = PortfolioList.State()
        var portfolioDetailState = PortfolioDetail.State()
        var step1State = Step1.State()
        var step2State = Step2.State()
        var step3State = Step3.State()
        var magazineDetailState = MagazineDetail.State()
        
        var routeIDs: IdentifiedArrayOf<Route<PortfolioScreen.State.ID>>
        
        var routes: IdentifiedArrayOf<Route<PortfolioScreen.State>> {
            get {
                let routes = routeIDs.map { route -> Route<PortfolioScreen.State> in
                    route.map { id in
                        switch id {
                        case .portfolioList:
                            return .portfolioList(portfolioListState)
                        case .portfolioDetail:
                            return .portfolioDetail(portfolioDetailState)
                        case .step1:
                            return .step1(step1State)
                        case .step2:
                            return .step2(step2State)
                        case .step3:
                            return .step3(step3State)
                        case .magazineDetail:
                            return .magazineDetail(magazineDetailState)
                        }
                    }
                }
                return IdentifiedArray(uniqueElements: routes)
            }
            set {
                let routeIDs = newValue.map { route -> Route<PortfolioScreen.State.ID> in
                    route.map { id in
                        switch id {
                        case .portfolioList(let portfolioListState):
                            self.portfolioListState = portfolioListState
                            return .portfolioList
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
                        case .magazineDetail(let magazineDetailState):
                            self.magazineDetailState = magazineDetailState
                            return .magazineDetail
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
            case .routeAction(_, action: .portfolioList(.portfolioRowTapped(let portfolioId))):
                state.portfolioDetailState.portfolioId = portfolioId
                state.routeIDs.push(.portfolioDetail)
                return .none
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
            case .routeAction(_, action: .step3(.goToMagazine4DetailButtonTapped)):
                state.magazineDetailState.magazineId = "magazine4"
                state.routeIDs.presentSheet(.magazineDetail)
                return .none
            case .routeAction(_, action: .magazineDetail(.backButtonTapped)):
                state.routeIDs.dismiss()
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
                case .portfolioList:
                    CaseLet(
                        /PortfolioScreen.State.portfolioList,
                         action: PortfolioScreen.Action.portfolioList,
                         then: PortfolioListView.init(store:))
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
                case .magazineDetail:
                    CaseLet(
                        /PortfolioScreen.State.magazineDetail,
                         action: PortfolioScreen.Action.magazineDetail,
                         then: MagazineDetailView.init(store:)
                    )
                }
            }
        }
    }
}

#Preview {
    PortfolioCoordinatorView(store: .init(initialState: PortfolioCoordinator.State.initialState, reducer: {
        PortfolioCoordinator()
    }))
}
