//
//  TCACoordinatorDemoApp.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

@main
struct TCACoordinatorDemoApp: App {
    var body: some Scene {
        WindowGroup {

            OnBoardingCoordinatorView(store: Store(initialState: .initialState, reducer: {
                OnBoardingCoordinator()
            }))
        }
    }
}


#Preview {

    OnBoardingCoordinatorView(store: Store(initialState: .initialState, reducer: {
        OnBoardingCoordinator()
    }))
}
