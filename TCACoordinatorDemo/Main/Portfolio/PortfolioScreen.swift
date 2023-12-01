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
        case portfolioList(PortfolioList.State)
        case portfolioDetail(PortfolioDetail.State)
        case step1(Step1.State)
        case step2(Step2.State)
        case step3(Step3.State)
        case magazineDetail(MagazineDetail.State)
        
        var id: ID {
            switch self {
            case .portfolioList:
                return .portfolioList
            case .portfolioDetail:
                return .portfolioDetail
            case .step1:
                return .step1
            case .step2:
                return .step2
            case .step3:
                return .step3
            case .magazineDetail:
                return .magazineDetail
            }
        }
        
        enum ID: Identifiable {
            case portfolioList
            case portfolioDetail
            case step1
            case step2
            case step3
            case magazineDetail
            
            var id: ID {
                self
            }
        }
    }
    
    enum Action: Equatable {
        case portfolioList(PortfolioList.Action)
        case portfolioDetail(PortfolioDetail.Action)
        case step1(Step1.Action)
        case step2(Step2.Action)
        case step3(Step3.Action)
        case magazineDetail(MagazineDetail.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.portfolioList, action: \.portfolioList) {
            PortfolioList()
        }
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
        Scope(state: \.magazineDetail, action: \.magazineDetail) {
            MagazineDetail()
        }
    }
}
