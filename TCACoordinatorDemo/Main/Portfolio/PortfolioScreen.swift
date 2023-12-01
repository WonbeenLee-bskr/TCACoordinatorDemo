//
//  PortfolioScreen.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import Foundation

struct PortfolioScreenEnvironment {
    let portfolioId: () async -> String
    
    static let test = PortfolioScreenEnvironment {
        "portoflioId"
    }
}

@Reducer
struct PortfolioScreen {
    let environment: PortfolioScreenEnvironment
    
    enum State: Equatable, Identifiable {
        case portfolioDetail(PortfolioDetail.State)
        case step1(Step1.State)
        case step2(Step2.State)
        case step3(Step3.State)
        
        var id: ID {
            switch self {
            case .portfolioDetail:
                return .portfolioDetail
            case .step1:
                return .step1
            case .step2:
                return .step2
            case .step3:
                return .step3
            }
        }
        
        enum ID: Identifiable {
            case portfolioDetail
            case step1
            case step2
            case step3
            
            var id: ID {
                self
            }
        }
    }
    
    enum Action: Equatable {
        case portfolioDetail(PortfolioDetail.Action)
        case step1(Step1.Action)
        case step2(Step2.Action)
        case step3(Step3.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.portfolioDetail, action: \.portfolioDetail) {
            PortfolioDetail()
        }
        Scope(state: \.step1, action: \.step1) {
            Step1()
        }
        Scope(state: \.step2, action: \.step2) {
            Step2()
        }
        Scope(state: \.step3, action: \.step3) {
            Step3()
        }
    }
}
