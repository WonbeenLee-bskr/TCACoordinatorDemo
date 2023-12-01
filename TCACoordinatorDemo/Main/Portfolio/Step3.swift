//
//  Step3.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Step3 {
    struct State: Equatable {}
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
        case goToSettingTabButtonTapped
        case goToMagazine4DetailButtonTapped
    }
    var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct Step3View: View {
    let store: StoreOf<Step3>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("Step3")
                    .font(.largeTitle)
                
                Button("Next") {
                    viewStore.send(.nextButtonTapped)
                }
                .padding(.bottom, 20)
                
                Button("SettingTab 으로") {
                    viewStore.send(.goToSettingTabButtonTapped)
                }
                
                Button("Magazine4 으로") {
                    viewStore.send(.goToMagazine4DetailButtonTapped)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
