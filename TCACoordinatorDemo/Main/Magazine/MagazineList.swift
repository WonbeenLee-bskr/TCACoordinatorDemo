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
        var selectedMagazineId: String = ""
    }
    
    enum Action: Equatable {
        case magazineRowTapped(magazineId: String)
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
                    viewStore.send(.magazineRowTapped(magazineId: "magazine1"))
                }
                Button("magazine2") {
                    viewStore.send(.magazineRowTapped(magazineId: "magazine2"))
                }
                Button("magazine3") {
                    viewStore.send(.magazineRowTapped(magazineId: "magazine3"))
                }
                Button("magazine4") {
                    viewStore.send(.magazineRowTapped(magazineId: "magazine4"))
                }
            }
        }
    }
}
