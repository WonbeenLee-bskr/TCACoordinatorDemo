//
//  OnBoarding.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct OnBoarding {
    struct State: Equatable {}
    
    enum Action {
        case loginButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                return .none // 네비게이션은 여기서 처리하지 않음.
            }
        }
    }
}

struct OnBoardingView: View {
    let store: StoreOf<OnBoarding>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("OnboardingView").font(.title)
                    .padding(.bottom, 50)
                
                Button("로그인 하기") {
                    viewStore.send(.loginButtonTapped)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
