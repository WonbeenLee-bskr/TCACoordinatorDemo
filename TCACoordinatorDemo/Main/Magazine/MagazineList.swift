//
//  MagazineList.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/30.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MagazineList {
    struct State: Equatable {
        var selectedMagazineId: Int = 0
    }
    
    enum Action: Equatable {
        case magazineRowTapped(magazineId: Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .magazineRowTapped(let magazineId):
                state.selectedMagazineId = magazineId
                return .none
            }
        }
    }
}

struct MagazineListView: View {
    let store: StoreOf<MagazineList>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Button("magazine1") {
                    viewStore.send(.magazineRowTapped(magazineId: 1))
                }
                Button("magazine2") {
                    viewStore.send(.magazineRowTapped(magazineId: 2))
                }
                Button("magazine3") {
                    viewStore.send(.magazineRowTapped(magazineId: 3))
                }
                Button("magazine4") {
                    viewStore.send(.magazineRowTapped(magazineId: 4))
                }
            }
        }
    }
}
