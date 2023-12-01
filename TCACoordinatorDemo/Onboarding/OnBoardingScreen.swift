//
//  OnBoardingScreen.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import Foundation

struct OnBoardingScreenEnvironment {
    let loginInfo: () -> String
    
    static let test = OnBoardingScreenEnvironment {
        "loginInfo"
    }
}

@Reducer
struct OnBoardingScreen {
    let environment: OnBoardingScreenEnvironment
    
    enum State: Equatable, Identifiable {
        case onboarding(OnBoarding.State)
        case mainTabCoordinator(MainTabCoordinator.State)
        
        var id: ID {
            switch self {
            case .onboarding:
                return .onboading
            case .mainTabCoordinator:
                return .mainTabCoordinator
            }
        }
        
        enum ID: Identifiable {
            case onboading
            case mainTabCoordinator
            
            var id: ID {
                self
            }
        }
    }
    
    enum Action {
        case onboarding(OnBoarding.Action)
        case mainTabCoordinator(MainTabCoordinator.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.onboarding, action: \.onboarding) {
            OnBoarding()
        }
        Scope(state: \.mainTabCoordinator, action: \.mainTabCoordinator) {
            MainTabCoordinator()
        }
    }
}

/// 하위 Reducer 들을 사용하기 위해 한번 상위레벨로 감싼 Wrapper 형태의 Screen Reducer
/// 그래서 body 에서 Scope 로 if 처럼 분기처리를 하여 사용하는 것 같다. Composable 한 특징
/// Screen 내부에 Coordinator 가 관장하는 화면의 Reducer 들이 선언되어있다.

