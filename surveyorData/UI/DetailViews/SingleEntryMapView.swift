//
//  SingleEntryMapView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/12/21.
//

import SwiftUI
import MapKit
struct samplePin: Identifiable{
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
struct SingleEntryMapView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    @State private var pins: [samplePin] = []
    
    var body: some View {
        //$var is a binding, reference to the underlying value
        Map(coordinateRegion: $region, annotationItems: pins){ pin in
            MapPin(coordinate: pin.coordinate)
        }
            .onAppear {
                setPin()
                setRegion(coordinate)
            }
    }
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    private func setPin(){
        var pinToAdd = samplePin(coordinate: coordinate)
        pins.append(pinToAdd)
    }
}

struct SingleEntryMapView_Previews: PreviewProvider {
    static var previews: some View {
        //gives the preview a value to look at
        Text("you guessedit")
        //SingleEntryMapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
