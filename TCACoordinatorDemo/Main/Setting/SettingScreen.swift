//
//  SettingScreen.swift
//  TCACoordinatorDemo
//
//  Created by 이원빈 on 2023/11/29.
//

import ComposableArchitecture
import Foundation

struct SettingScreenEnvironment {
    let myInfo: () async -> String
    
    static let test = SettingScreenEnvironment {
        "myInfo"
    }
}

@Reducer
struct SettingScreen {
    let environment: SettingScreenEnvironment
    
    enum State: Equatable, Identifiable {
        case settingDetail(SettingDetail.State)
        case settingMyInfo(SettingMyInfo.State)
        
        var id: ID {
            switch self {
            case .settingDetail:
                return .settingDetail
            case .settingMyInfo:
                return .settingMyInfo
            }
        }
        
        enum ID: Identifiable {
            case settingDetail
            case settingMyInfo
            
            var id: ID {
                self
            }
        }
    }
    
    enum Action: Equatable {
        case settingDetail(SettingDetail.Action)
        case settingMyInfo(SettingMyInfo.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.settingDetail, action: \.settingDetail) {
            SettingDetail()
        }
        Scope(state: \.settingMyInfo, action: \.settingMyInfo) {
            SettingMyInfo()
        }
    }
}
