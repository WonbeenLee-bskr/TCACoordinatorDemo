//
//  SettingDetail.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SettingDetail {
    struct State: Equatable {}
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case myInfoButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

struct SettingDetailView: View {
    let store: StoreOf<SettingDetail>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("SettingDetail")
                    .font(.largeTitle)
                    .padding(.bottom, 100)
                Button("내 정보") {
                    viewStore.send(.myInfoButtonTapped)
                }
            }
        }
    }
}
