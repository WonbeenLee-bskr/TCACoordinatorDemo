//
//  PortfolioDetail.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct PortfolioDetail {
    struct State: Equatable {
        @BindingState var portfolioId: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

struct PortfolioDetailView: View {
    let store: StoreOf<PortfolioDetail>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("PortfolioDetail")
                    .font(.largeTitle)
                    .padding(.bottom, 100)
                Button("Next") {
                    viewStore.send(.nextButtonTapped)
                }
            }
        }
    }
}
