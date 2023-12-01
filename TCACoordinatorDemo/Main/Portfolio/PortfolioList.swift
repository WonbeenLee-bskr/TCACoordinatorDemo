//
//  PortfolioList.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/12/01.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct PortfolioList {
    struct State: Equatable {
        var selectedPortfolioId: String = ""
    }
    enum Action: Equatable {
        case portfolioRowTapped(portfolioId: String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .portfolioRowTapped(let portfolioId):
                state.selectedPortfolioId = portfolioId
                return .none
            }
        }
    }
}

struct PortfolioListView: View {
    let store: StoreOf<PortfolioList>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Button("portfolio1") {
                    viewStore.send(.portfolioRowTapped(portfolioId: "portfolio1"))
                }
                Button("portfolio2") {
                    viewStore.send(.portfolioRowTapped(portfolioId: "portfolio2"))
                }
                Button("portfolio3") {
                    viewStore.send(.portfolioRowTapped(portfolioId: "portfolio3"))
                }
                Button("portfolio4") {
                    viewStore.send(.portfolioRowTapped(portfolioId: "portfolio4"))
                }
            }
        }
    }
}
