//
//  ClusteringMarker.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation
import NMapsMap

final class ClusteringMarker: NMFMarker, Markable {
    
    let coordinate: Coordinate
    let coordinatesCount: Int
    let clusteringMarkerLayer: ClusteringMarkerLayer
    var markerLayer: CALayer {
        clusteringMarkerLayer
    }
    let boundingBox: BoundingBox
    let cluster: Cluster
    
    var naverMapView: NMFMapView? {
        mapView
    }

    required init(cluster: Cluster) {
        self.cluster = cluster
        self.coordinate = cluster.center
        self.coordinatesCount = cluster.coordinates.count
        self.clusteringMarkerLayer = ClusteringMarkerLayer(cluster: cluster)
        self.boundingBox = cluster.boundingBox
        super.init()
        position = NMGLatLng(lat: cluster.center.y, lng: cluster.center.x)
        
        let uiImage = imageFromLayer(layer: markerLayer)
        configure(image: uiImage)
    }
    
    func configure(image: UIImage) {
        iconImage = NMFOverlayImage(image: image)
        
        iconTintColor = ClusteringColor.getColor(count: coordinatesCount)
        
        anchor = CGPoint(x: 0.5, y: 0.5)
        alpha = 0.9
    }
    
    private func imageFromLayer(layer: CALayer) -> UIImage {
        let originalColor = layer.backgroundColor
        
        defer {
            layer.backgroundColor = originalColor
        }
        
        layer.backgroundColor = UIColor.black.cgColor
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        
        guard let uiGraphicsGetCurrentContext = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        layer.render(in: uiGraphicsGetCurrentContext)
        
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    func animate(position: CGPoint) {
        let animation = AnimationController.transformScale(option: .increase)
        markerLayer.position = position
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock { [weak self] in
            self?.markerLayer.removeFromSuperlayer()
            self?.hidden = false
        }
        markerLayer.add(animation, forKey: "markerAnimation")
        CATransaction.commit()
        
    }
    
}

extension ClusteringMarker: NMFOverlayImageDataSource {
    
    func view(with overlay: NMFOverlay) -> UIView {
        guard let marker = overlay as? NMFMarker else { return UIView() }
        
        let markerView = UIImageView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: marker.iconImage.imageWidth,
                                                   height: marker.iconImage.imageHeight))
        return markerView
    }
}
