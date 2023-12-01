//
//  Step2.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Step2 {
    struct State: Equatable {}
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
    }
    var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct Step2View: View {
    let store: StoreOf<Step2>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("Step2")
                    .font(.largeTitle)
                
                Button("Next") {
                    viewStore.send(.nextButtonTapped)
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}
