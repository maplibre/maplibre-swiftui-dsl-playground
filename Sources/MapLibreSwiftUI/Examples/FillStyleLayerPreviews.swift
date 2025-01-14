import MapLibre
import MapLibreSwiftDSL
import SwiftUI

@available(iOS 17.0, *)
#Preview {
    @Previewable let source = ShapeSource(identifier: "fillSource") {
        MLNPolygonFeature(coordinates: austriaPolygon, count: UInt(austriaPolygon.count))
    }
    MapView(styleURL: demoTilesURL, camera: .constant(.center(austriaPolygon.first!, zoom: 4))) {
        FillStyleLayer(identifier: "fillLayer", source: source)
            .fillColor(.red)
            .fillOpacity(0.5)
            .fillOutlineColor(.blue)
    }

    .ignoresSafeArea(.all)
}
