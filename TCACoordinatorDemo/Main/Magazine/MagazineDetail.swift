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
        var magazineId: String = ""
    }
    enum Action: Equatable {
        case backButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
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
                Text("magazineID = " + viewStore.magazineId)
                    .foregroundColor(.gray)
                Button("< 뒤로가기") {
                    viewStore.send(.backButtonTapped)
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}
