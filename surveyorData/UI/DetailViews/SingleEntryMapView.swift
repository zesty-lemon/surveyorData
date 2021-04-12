//
//  SingleEntryMapView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/12/21.
//

import SwiftUI
import MapKit

struct SingleEntryMapView: View {
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()

    var body: some View {
        //$var is a binding, reference to the underlying value
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(coordinate)
            }
    }
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
        }
}

struct SingleEntryMapView_Previews: PreviewProvider {
    static var previews: some View {
        //gives the preview a value to look at
        SingleEntryMapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
