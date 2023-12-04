//
//  MagazineDetail.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/30.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MagazineDetail {
    struct State: Equatable {
        var magazineId: Int = 0
        var description: String = ""
        var isLoading = false
    }
    enum Action: Equatable {
        case backButtonTapped
        /// 네트워킹 처리
        case onAppear
        case factResponse(String)
    }
    @Dependency(\.numberFact) var numberFact
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .onAppear:
                state.isLoading = true
                return .run(priority: .userInitiated) { [count = state.magazineId] send in
                    try await send(.factResponse(self.numberFact.fetch(count)))
                }
            case let .factResponse(fact):
                state.description = fact
                state.isLoading = false
                return .none
            }
        }
    }
}

struct MagazineDetailView: View {
    let store: StoreOf<MagazineDetail>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("Magazine Detail")
                    .font(.title)
                Text("magazineID = " + String(viewStore.magazineId))
                    .foregroundColor(.gray)
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    Text(viewStore.description)
                        .padding(20)
                        .font(.caption)
                }
                Button("< 뒤로가기") {
                    viewStore.send(.backButtonTapped)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
