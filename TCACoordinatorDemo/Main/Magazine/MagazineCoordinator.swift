//
//  MagazineCoordinator.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/30.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

@Reducer
struct MagazineCoordinator {
    struct State: IdentifiedRouterState, Equatable {
        static let initialState = Self(routeIDs: [.root(.magazineList, embedInNavigationView: false)])
        var magazineListState = MagazineList.State()
        var magazineDetailState = MagazineDetail.State()
        
        var routeIDs: IdentifiedArrayOf<Route<MagazineScreen.State.ID>>
        
        var routes: IdentifiedArrayOf<Route<MagazineScreen.State>> {
            get {
                let routers = routeIDs.map { route -> Route<MagazineScreen.State> in
                    route.map { id in
                        switch id {
                        case .magazineList:
                            return .magazineList(magazineListState)
                        case .magazineDetail:
                            return .magazineDetail(magazineDetailState)
                        }
                    }
                }
                return IdentifiedArray(uniqueElements: routers)
            }
            set {
                let routeIDs = newValue.map { route -> Route<MagazineScreen.State.ID> in
                    route.map { id in
                        switch id {
                        case .magazineList(let magazineListState):
                            self.magazineListState = magazineListState
                            return .magazineList
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
        case updateRoutes(IdentifiedArrayOf<Route<MagazineScreen.State>>)
        case routeAction(MagazineScreen.State.ID, action: MagazineScreen.Action)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .routeAction(_, action: .magazineList(.magazineRowTapped(let magazineId))):
                state.magazineDetailState.magazineId = magazineId
                state.routeIDs.push(.magazineDetail) /// magazineId 를 어떻게 전달 ? 이렇게 전달해도 효율적인가.
                return .none
            case .routeAction(_, action: .magazineDetail(.backButtonTapped)):
                state.routeIDs.popToRoot()
                return .none
            default:
                return .none
            }
        }.forEachRoute {
            MagazineScreen(environment: .init()) // TODO: 왜 있는지 아직 모름
        }
    }
}

struct MagazineCoordinatorView: View {
    let store: StoreOf<MagazineCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .magazineList:
                    CaseLet(
                        /MagazineScreen.State.magazineList,
                         action: MagazineScreen.Action.magazineList,
                         then: MagazineListView.init(store:))
                case .magazineDetail:
                    CaseLet(
                        /MagazineScreen.State.magazineDetail,
                         action: MagazineScreen.Action.magazineDetail,
                         then: MagazineDetailView.init(store:))
                }
            }
        }
    }
}
