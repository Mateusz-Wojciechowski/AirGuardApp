// MapView.swift

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager // Dostęp do LocationManager

    var body: some View {
        Map(
            coordinateRegion: $locationManager.region,
            interactionModes: .all, // Umożliwia wszystkie interakcje
            showsUserLocation: false, // Nie pokazuje rzeczywistej lokalizacji użytkownika
            annotationItems: locationManager.userLocation != nil ? [locationManager.userLocation!] : []
        ) { location in
            MapMarker(coordinate: location.coordinate, tint: .blue)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(LocationManager()) // Przekazanie LocationManager do podglądu
    }
}
