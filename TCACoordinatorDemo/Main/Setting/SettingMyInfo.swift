//
//  SettingMyInfo.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SettingMyInfo {
    struct State: Equatable {}
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case logoutButtonTapped
    }
    var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct SettingMyInfoView: View {
    let store: StoreOf<SettingMyInfo>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Button("로그아웃") {
                    viewStore.send(.logoutButtonTapped)
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}
