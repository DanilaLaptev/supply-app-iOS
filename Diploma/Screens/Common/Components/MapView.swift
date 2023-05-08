import SwiftUI
import MapKit
import CoreLocation


struct MapMarker: Equatable {
    let id = UUID().uuidString
    let name: String
    let location: CLLocationCoordinate2D
    
    static func ==(lhs: MapMarker, rhs: MapMarker) -> Bool {
        lhs.id == rhs.id
    }
}

final class LandmarkAnnotation: NSObject, MKAnnotation {
    let id: String
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(landmark: MapMarker) {
        self.id = landmark.id
        self.title = landmark.name
        self.coordinate = landmark.location
    }
}

struct MapView: UIViewRepresentable {
    @Binding var markers: [MapMarker]
    @Binding var selectedMarker: MapMarker?
    var showUserLocation = true
    var onTapDetailDisclosure: (() -> ())?
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = showUserLocation
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(from: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView

        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let coordinates = view.annotation?.coordinate else { return }
            let span = mapView.region.span
            let region = MKCoordinateRegion(center: coordinates, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? LandmarkAnnotation else { return nil }
            let identifier = "Annotation"
            var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                let detailButton = UIButton(type: .detailDisclosure)
                detailButton.addTarget(self, action: #selector(tapDetailDisclosure), for: .touchUpInside)
                
                annotationView?.rightCalloutAccessoryView = detailButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        
        @objc func tapDetailDisclosure(button: UIButton) {
            self.control.onTapDetailDisclosure?()
        }
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        let newAnnotations = markers.map { LandmarkAnnotation(landmark: $0) }
        mapView.addAnnotations(newAnnotations)
        if let selectedAnnotation = newAnnotations.filter({ $0.id == selectedMarker?.id }).first {
            mapView.selectAnnotation(selectedAnnotation, animated: true)
        }
    }
}
