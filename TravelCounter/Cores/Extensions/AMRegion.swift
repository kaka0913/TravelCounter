//
//  AMRegion.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/03.
//

import AMJpnMap

extension AMRegion {
    var name: String {
        switch self {
        case .hokkaido: return "北海道"
        case .tohoku: return "東北"
        case .kanto: return "関東"
        case .chubu: return "中部"
        case .kinki: return "近畿"
        case .chugoku: return "中国"
        case .shikoku: return "四国"
        case .kyushu: return "九州"
        }
    }
}
