//
//  SamplesMapView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 5/8/21.
//

import SwiftUI
import MapKit
//add annotation label maybe
struct singlePin: Identifiable{
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
struct SamplesMapView: View {
    var coordinates:[CLLocationCoordinate2D] //all coordinates to add
    @State private var region = MKCoordinateRegion()
    @State private var pins: [singlePin] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        //$var is a binding, reference to the underlying value
        NavigationView{
            Map(coordinateRegion: $region, annotationItems: pins){ pin in
                MapPin(coordinate: pin.coordinate)
            }
            .onAppear {
                setPin()
                //set region to region of samples to make map view look ok
                if coordinates.count > 0 {
                    setRegion(coordinates[0]) //assumes region is consistent across samples
                }
            }
            //this forces the button to be inline
            .navigationBarTitle(Text("Sample Locations"), displayMode: .inline)
//            .toolbar {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Text("Done").bold()
//                }
//            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Done").bold()
                                    })
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }
    private func setPin(){
        //setup array of all pins to add
        for i in 0..<coordinates.count{
            pins.append(singlePin(coordinate: coordinates[i]))
        }
    }
}

struct SamplesMapView_Previews: PreviewProvider {
    static var previews: some View {
        //gives the preview a value to look at
        Text("you guessedit")
        //SingleEntryMapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
