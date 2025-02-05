import Foundation
import MapKit
import AMJpnMap

extension AMPrefecture {
    struct Location {
        let coordinate: CLLocationCoordinate2D
        let zoomLevel: CLLocationDegrees
        let cityName: String
    }
    
    var location: Location {
        switch self {
        case .hokkaido:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 43.064301, longitude: 141.346874), zoomLevel: 0.7, cityName: "札幌")
        case .aomori:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 40.824622, longitude: 140.740598), zoomLevel: 0.5, cityName: "青森")
        case .iwate:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 39.703531, longitude: 141.152667), zoomLevel: 0.5, cityName: "盛岡")
        case .miyagi:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 38.268839, longitude: 140.872103), zoomLevel: 0.4, cityName: "仙台")
        case .akita:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 39.718600, longitude: 140.102334), zoomLevel: 0.5, cityName: "秋田")
        case .yamagata:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 38.240437, longitude: 140.363634), zoomLevel: 0.4, cityName: "山形")
        case .fukushima:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 37.750299, longitude: 140.467551), zoomLevel: 0.5, cityName: "福島")
        case .ibaraki:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 36.341811, longitude: 140.446793), zoomLevel: 0.4, cityName: "水戸")
        case .tochigi:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 36.565725, longitude: 139.883565), zoomLevel: 0.4, cityName: "宇都宮")
        case .gunma:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 36.391208, longitude: 139.065933), zoomLevel: 0.4, cityName: "前橋")
        case .saitama:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.857428, longitude: 139.648933), zoomLevel: 0.3, cityName: "さいたま")
        case .chiba:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.605058, longitude: 140.123308), zoomLevel: 0.4, cityName: "千葉")
        case .tokyo:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.689487, longitude: 139.691706), zoomLevel: 0.3, cityName: "東京")
        case .kanagawa:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.447507, longitude: 139.642345), zoomLevel: 0.3, cityName: "横浜")
        case .niigata:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 37.902418, longitude: 139.023221), zoomLevel: 0.5, cityName: "新潟")
        case .toyama:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 36.695290, longitude: 137.211338), zoomLevel: 0.4, cityName: "富山")
        case .ishikawa:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 36.594682, longitude: 136.625573), zoomLevel: 0.4, cityName: "金沢")
        case .fukui:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 36.065178, longitude: 136.221527), zoomLevel: 0.4, cityName: "福井")
        case .yamanashi:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.664158, longitude: 138.568449), zoomLevel: 0.4, cityName: "甲府")
        case .nagano:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 36.651289, longitude: 138.181224), zoomLevel: 0.5, cityName: "長野")
        case .gifu:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.391227, longitude: 136.722291), zoomLevel: 0.4, cityName: "岐阜")
        case .shizuoka:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.976032, longitude: 138.382695), zoomLevel: 0.4, cityName: "静岡")
        case .aichi:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.180188, longitude: 136.906565), zoomLevel: 0.4, cityName: "名古屋")
        case .mie:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.730283, longitude: 136.508588), zoomLevel: 0.4, cityName: "津")
        case .shiga:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.004531, longitude: 135.868665), zoomLevel: 0.3, cityName: "大津")
        case .kyoto:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.021247, longitude: 135.755597), zoomLevel: 0.3, cityName: "京都")
        case .osaka:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.686316, longitude: 135.519711), zoomLevel: 0.3, cityName: "大阪")
        case .hyogo:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.691269, longitude: 135.183071), zoomLevel: 0.4, cityName: "神戸")
        case .nara:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.685334, longitude: 135.832742), zoomLevel: 0.3, cityName: "奈良")
        case .wakayama:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.226034, longitude: 135.167470), zoomLevel: 0.4, cityName: "和歌山")
        case .tottori:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.503891, longitude: 134.237736), zoomLevel: 0.4, cityName: "鳥取")
        case .shimane:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 35.472297, longitude: 133.050499), zoomLevel: 0.4, cityName: "松江")
        case .okayama:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.661772, longitude: 133.934675), zoomLevel: 0.4, cityName: "岡山")
        case .hiroshima:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.396601, longitude: 132.459595), zoomLevel: 0.4, cityName: "広島")
        case .yamaguchi:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.185956, longitude: 131.470649), zoomLevel: 0.4, cityName: "山口")
        case .tokushima:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.065718, longitude: 134.559294), zoomLevel: 0.4, cityName: "徳島")
        case .kagawa:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 34.340149, longitude: 134.043444), zoomLevel: 0.4, cityName: "高松")
        case .ehime:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 33.841660, longitude: 132.765362), zoomLevel: 0.4, cityName: "松山")
        case .kochi:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 33.559706, longitude: 133.531079), zoomLevel: 0.4, cityName: "高知")
        case .fukuoka:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 33.606785, longitude: 130.418314), zoomLevel: 0.4, cityName: "福岡")
        case .saga:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 33.249442, longitude: 130.299794), zoomLevel: 0.3, cityName: "佐賀")
        case .nagasaki:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 32.744839, longitude: 129.873756), zoomLevel: 0.4, cityName: "長崎")
        case .kumamoto:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 32.789827, longitude: 130.741667), zoomLevel: 0.4, cityName: "熊本")
        case .oita:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 33.238172, longitude: 131.612619), zoomLevel: 0.4, cityName: "大分")
        case .miyazaki:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 31.911090, longitude: 131.423855), zoomLevel: 0.4, cityName: "宮崎")
        case .kagoshima:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 31.560146, longitude: 130.557978), zoomLevel: 0.4, cityName: "鹿児島")
        case .okinawa:
            return Location(coordinate: CLLocationCoordinate2D(latitude: 26.212401, longitude: 127.680932), zoomLevel: 0.4, cityName: "那覇")
        }
    }
} 