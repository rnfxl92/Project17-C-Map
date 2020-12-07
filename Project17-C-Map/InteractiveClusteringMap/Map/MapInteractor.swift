//
//  MapInteractor.swift
//  InteractiveClusteringMap
//
//  Created by eunjeong lee on 2020/11/29.
//

import Foundation

protocol ClusterBusinessLogic: class {
    
    func fetch(boundingBoxes: [CLong: BoundingBox], zoomLevel: Double)
    func remove(tileIds: [CLong])
//    func add(coordinate: Coordinate)
    func delete(coordinate: Coordinate)
    
}

final class MapInteractor: ClusterBusinessLogic {
    
    private let presenter: ClusterPresentationLogic
    private let quadTreeClusteringService: ClusteringServicing
    
    init(poiService: POIServicing, presenter: ClusterPresentationLogic) {
        self.presenter = presenter
        self.quadTreeClusteringService = QuadTreeClusteringService(poiService: poiService)
    }
    
    func fetch(boundingBoxes: [CLong: BoundingBox], zoomLevel: Double) {
        boundingBoxes.forEach { tileId, boundingBox in
            self.clustering(
                tileId: tileId,
                boundingBox: boundingBox,
                zoomLevel: zoomLevel)
        }
    }
    
    func remove(tileIds: [CLong]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presenter.removePresentMarkers(tileIds: tileIds)
        }
    }
    
    private func clustering(tileId: CLong,
                            boundingBox: BoundingBox,
                            zoomLevel: Double) {
        
        quadTreeClusteringService.execute(coordinates: nil,
                                   boundingBox: boundingBox,
                                   zoomLevel: zoomLevel) { [weak self] clusters in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.presenter.clustersToMarkers(tileId: tileId, clusters: clusters)
            }
        }
    }
    
//    func add(coordinate: Coordinate) {
//        presenter.add(poi: POI(x: coordinate.x, y: coordinate.y, id: coordinate.id, name: "", imageUrl: "", category: ""))
//    }
//
    func delete(coordinate: Coordinate) {
        quadTreeClusteringService.delete(coordinate: coordinate)
        presenter.delete(coordinate: coordinate)
    }
    
}
