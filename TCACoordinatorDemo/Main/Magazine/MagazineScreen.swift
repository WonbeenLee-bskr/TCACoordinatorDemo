//
//  MagazineScreen.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/30.
//

import ComposableArchitecture
import Foundation

struct MagazineScreenEnvironment {
    
}

@Reducer
struct MagazineScreen {
    let environment: MagazineScreenEnvironment
    
    enum State: Equatable, Identifiable {
        case magazineList(MagazineList.State)
        case magazineDetail(MagazineDetail.State)
        
        var id: ID {
            switch self {
            case .magazineList:
                return .magazineList
            case .magazineDetail:
                return .magazineDetail
            }
        }
        
        enum ID: Identifiable {
            case magazineList
            case magazineDetail
            
            var id: ID {
                self
            }
        }
    }
    
    enum Action: Equatable {
        case magazineList(MagazineList.Action)
        case magazineDetail(MagazineDetail.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.magazineList, action: \.magazineList) {
            MagazineList()
        }
        Scope(state: \.magazineDetail, action: \.magazineDetail) {
            MagazineDetail()
        }
    }
}
