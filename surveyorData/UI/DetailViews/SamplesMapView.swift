//
//  SamplesMapView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 5/8/21.
//
//it is impossible (as of 05/2020) to add text to a pin in swiftUI
//This will be implemented in the future
//yuck
import SwiftUI
import MapKit
//add annotation label maybe
struct singlePin: Identifiable{
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let title = "test"
    
}

struct sampleLocation: Identifiable {
    var id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct SamplesMapView: View {
    var coordinates:[CLLocationCoordinate2D] //all coordinates to add
    var locations = [CLLocationCoordinate2D]()
    @State private var region = MKCoordinateRegion()
    @State private var pins: [singlePin] = []
    @Environment(\.presentationMode) var presentationMode
    //https://medium.com/swlh/how-to-improve-your-swiftui-map-a323ccb47dfb
    //https://www.appcoda.com/swiftui-map/
    //https://www.hackingwithswift.com/books/ios-swiftui/communicating-with-a-mapkit-coordinator
    init(inputCoordinates: [CLLocationCoordinate2D]) {
        coordinates = inputCoordinates
        region = MKCoordinateRegion()
        
        }
    @ViewBuilder var body: some View {
        //$var is a binding, reference to the underlying value
        NavigationView{
            Map(coordinateRegion: $region, annotationItems: pins){ pin in
                MapPin(coordinate: pin.coordinate, tint: .red)
            }.mapStyle(.satellite)
            
            .onAppear {
                setPin()
                //set region to region of samples to make map view look ok
                if coordinates.count > 0 {
                    setRegion(coordinates[0]) //assumes region is consistent across samples
                }
            }
            //this forces the button to be inline
            .navigationBarTitle(Text("Sample Locations"), displayMode: .inline)
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
extension Map {
    func mapStyle(_ mapType: MKMapType) -> some View {
        MKMapView.appearance().mapType = mapType
        return self
    }
}
struct SamplesMapView_Previews: PreviewProvider {
    static var previews: some View {
        //gives the preview a value to look at
        Text("you guessedit")
        //SingleEntryMapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
