import SwiftUI
import MapKit

class LocationSearchCompleter: NSObject, ObservableObject {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private let completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .query
    }
    
    func search(query: String) {
        completer.queryFragment = query
    }
}

extension LocationSearchCompleter: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

struct LocationSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var searchCompleter = LocationSearchCompleter()
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var selectedPin: (coordinate: CLLocationCoordinate2D, name: String)?
    let onLocationSelected: (CLLocationCoordinate2D, String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 検索バー
                TextField("場所を検索", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) { oldValue, newValue in
                        searchCompleter.search(query: newValue)
                    }
                
                // 検索結果リスト
                if !searchCompleter.searchResults.isEmpty && !searchText.isEmpty {
                    List(searchCompleter.searchResults, id: \.self) { result in
                        Button(action: {
                            searchLocation(result)
                        }) {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                Text(result.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    // 地図表示
                    Map(coordinateRegion: $region,
                        interactionModes: .all,
                        showsUserLocation: true,
                        annotationItems: selectedPin.map { [MapPin(coordinate: $0.coordinate)] } ?? []) { pin in
                        MapMarker(coordinate: pin.coordinate, tint: .red)
                    }
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                // タップした位置の地点名を取得
                                let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
                                let geocoder = CLGeocoder()
                                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                                    if let placemark = placemarks?.first {
                                        let name = [
                                            placemark.name,
                                            placemark.locality,
                                            placemark.administrativeArea
                                        ].compactMap { $0 }.joined(separator: ", ")
                                        selectedPin = (region.center, name)
                                    }
                                }
                            }
                    )
                }
            }
            .navigationTitle("位置情報を選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("選択") {
                        if let selected = selectedPin {
                            onLocationSelected(selected.coordinate, selected.name)
                            dismiss()
                        }
                    }
                    .disabled(selectedPin == nil)
                }
            }
        }
    }
    
    private func searchLocation(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = result.title + ", " + result.subtitle
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            let name = [
                item.name,
                item.placemark.locality,
                item.placemark.administrativeArea
            ].compactMap { $0 }.joined(separator: ", ")
            
            selectedPin = (coordinate, name)
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            searchText = ""
        }
    }
}

private struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
} 