import Foundation
import MapLibre
import MapLibreSwiftDSL
import SwiftUI

public extension MapView {
    /// Perform an action when the map view has loaded its style and all locally added style definitions.
    ///
    /// - Parameter perform: The action to perform with the loaded style.
    /// - Returns: The modified map view.
    func onStyleLoaded(_ perform: @escaping (MLNStyle) -> Void) -> MapView {
        var newMapView = self
        newMapView.onStyleLoaded = perform
        return newMapView
    }

    /// Allows you to set properties of the underlying MLNMapView directly
    /// in cases where these have not been ported to DSL yet.
    /// Use this function to modify various properties of the MLNMapView instance.
    /// For example, you can enable the display of the user's location on the map by setting `showUserLocation` to true.
    ///
    /// This is an 'escape hatch' back to the non-DSL world
    /// of MapLibre for features that have not been ported to DSL yet.
    /// Be careful not to use this to modify properties that are
    /// already ported to the DSL, like the camera for example, as your
    /// modifications here may break updates that occur with modifiers.
    /// In particular, this modifier is potentially dangerous as it runs on
    /// EVERY call to `updateUIView`.
    ///
    /// - Parameter modifier: A closure that provides you with an MLNMapView so you can set properties.
    /// - Returns: A MapView with the modifications applied.
    ///
    /// Example:
    /// ```swift
    ///  MapView()
    ///     .mapViewModifier { mapView in
    ///         mapView.showUserLocation = true
    ///     }
    /// ```
    ///
    func unsafeMapViewModifier(_ modifier: @escaping (MLNMapView) -> Void) -> MapView {
        var newMapView = self
        newMapView.unsafeMapViewModifier = modifier
        return newMapView
    }

    // MARK: Default Gestures

    /// Add an tap gesture handler to the MapView
    ///
    /// - Parameters:
    ///   - count: The number of taps required to run the gesture.
    ///   - onTapChanged: Emits the context whenever the gesture changes (e.g. began, ended, etc), that also contains
    /// information like the latitude and longitude of the tap.
    /// - Returns: The modified map view.
    func onTapMapGesture(count: Int = 1,
                         onTapChanged: @escaping (MapGestureContext) -> Void) -> MapView
    {
        var newMapView = self

        // Build the gesture and link it to the map view.
        let gesture = MapGesture(method: .tap(numberOfTaps: count),
                                 onChange: .context(onTapChanged))
        newMapView.gestures.append(gesture)

        return newMapView
    }

    /// Add an tap gesture handler to the MapView that returns any visible map features that were tapped.
    ///
    /// - Parameters:
    ///   - count: The number of taps required to run the gesture.
    ///   - on layers: The set of layer ids that you would like to check for visible features that were tapped. If no
    /// set is provided, all map layers are checked.
    ///   - onTapChanged: Emits the context whenever the gesture changes (e.g. began, ended, etc), that also contains
    /// information like the latitude and longitude of the tap. Also emits an array of map features that were tapped.
    /// Returns an empty array when nothing was tapped on the "on" layer ids that were provided.
    /// - Returns: The modified map view.
    func onTapMapGesture(count: Int = 1, on layers: Set<String>?,
                         onTapChanged: @escaping (MapGestureContext, [any MLNFeature]) -> Void) -> MapView
    {
        var newMapView = self

        // Build the gesture and link it to the map view.
        let gesture = MapGesture(method: .tap(numberOfTaps: count),
                                 onChange: .feature(onTapChanged, layers: layers))
        newMapView.gestures.append(gesture)

        return newMapView
    }

    /// Add a long press gesture handler ot the MapView
    ///
    /// - Parameters:
    ///   - minimumDuration: The minimum duration in seconds the user must press the screen to run the gesture.
    ///   - onPressChanged: Emits the context whenever the gesture changes (e.g. began, ended, etc).
    /// - Returns: The modified map view.
    func onLongPressMapGesture(minimumDuration: Double = 0.5,
                               onPressChanged: @escaping (MapGestureContext) -> Void) -> MapView
    {
        var newMapView = self

        // Build the gesture and link it to the map view.
        let gesture = MapGesture(method: .longPress(minimumDuration: minimumDuration),
                                 onChange: .context(onPressChanged))
        newMapView.gestures.append(gesture)

        return newMapView
    }

    func mapViewContentInset(_ inset: UIEdgeInsets) -> Self {
        var result = self

        result.mapViewContentInset = inset

        return result
    }

    func mapControls(@MapControlsBuilder _ buildControls: () -> [MapControl]) -> Self {
        var result = self

        result.controls = buildControls()

        return result
    }
}
