import SwiftUI
import MapKit

struct LocationDataView: View {
    @EnvironmentObject var locationManager: LocationManager // Dostęp do LocationManager
    
    // Dwa stany sterujące wyświetlaniem popupów z informacją
    @State private var showPM10Info = false
    @State private var showPM25Info = false
    
    @State private var navigateToMap = false // Stan nawigacji do MapView
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.85, green: 0.93, blue: 1.0),
                    Color(red: 0.75, green: 0.85, blue: 0.95)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Location Data")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 16)
                    
                    // Kafelek z AQI
                    VStack(spacing: 8) {
                        Image(systemName: "face.smiling")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                        
                        if let userLocation = locationManager.userLocation {
                            Text("\(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("AQI: 30") // Możesz zastąpić to dynamicznymi danymi AQI
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        } else {
                            Text("AQI: -")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {
                            // Akcja dla "Plots for this location"
                        }) {
                            Text("Plots for this location")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.9))
                    )
                    .shadow(radius: 4)
                    .padding(.horizontal, 16)
                    
                    // Sekcja "More details"
                    VStack(alignment: .leading, spacing: 8) {
                        Text("More details")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        HStack(alignment: .center, spacing: 20) {
                            // --- PM10 ---
                            Button {
                                showPM10Info = true
                            } label: {
                                VStack {
                                    Text("PM10")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("21 µg/m³")
                                        .font(.callout)
                                    Text("53%")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Divider()
                                .frame(height: 40)
                            
                            // --- PM2.5 ---
                            Button {
                                showPM25Info = true
                            } label: {
                                VStack {
                                    Text("PM2.5")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("19 µg/m³")
                                        .font(.callout)
                                    Text("52%")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.9))
                    )
                    .shadow(radius: 4)
                    .padding(.horizontal, 16)
                    
                    // Sekcja "Closest stations" + mapa
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Closest stations")
                            .font(.headline)
                        
                        Map(
                            coordinateRegion: $locationManager.region,
                            interactionModes: .all,
                            showsUserLocation: false,
                            annotationItems: locationManager.userLocation != nil ? [locationManager.userLocation!] : []
                        ) { location in
                            MapMarker(coordinate: location.coordinate, tint: .blue)
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        
                        Button(action: {
                            navigateToMap = true
                        }) {
                            Text("View on Map")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        
                        // NavigationLink do MapView
                        NavigationLink(destination: MapView(), isActive: $navigateToMap) {
                            EmptyView()
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.9))
                    )
                    .shadow(radius: 4)
                    .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 40)
                }
            }
            
            // Overlay'e z popupami
            if showPM10Info {
                InfoPopupView(
                    title: "PM 10",
                    description: """
Particulate Matter 10 (PM10) refers to airborne particles with a diameter of 10 micrometers or smaller. These particles can penetrate the respiratory system and cause health issues, especially for people with respiratory conditions.
""",
                    onClose: { showPM10Info = false }
                )
            }
            
            if showPM25Info {
                InfoPopupView(
                    title: "PM 2.5",
                    description: """
PM2.5 is a measure of the concentration of fine particulate matter in the air with diameters of 2.5 micrometers or smaller. It is used to assess air quality because these tiny particles can penetrate deep into the lungs and bloodstream, posing significant health risks.
""",
                    onClose: { showPM25Info = false }
                )
            }
        }
    }
}

struct LocationDataView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDataView()
            .environmentObject(LocationManager())
    }
}

// MARK: - Popup widoczek
struct InfoPopupView: View {
    let title: String
    let description: String
    let onClose: () -> Void
    
    var body: some View {
        // Półprzezroczyste tło całego ekranu
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // Gdy użytkownik tapnie w tło, też zamykamy popup
                    onClose()
                }
            
            // Białe okienko z informacją
            VStack(spacing: 16) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("OK") {
                    onClose()
                }
                .padding(.top, 10)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .padding(40)
        }
    }
}
