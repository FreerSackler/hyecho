//
//  TerrainMesh.swift
//  TerrainMesh3D
//
//  Created by Anders Boberg on 5/30/17.
//  Copyright © 2017 Matt Reagan. All rights reserved.
//

import Foundation
import SceneKit

class TerrainMesh: SCNNode {
    var verticesPerSide: Int = 0
    var sideLength: Double = 0
    private var vertexHeightComputationBlock: ((Int, Int) -> Double)?
    
    private var meshVertices: [SCNVector3] = []
    private var normals: [SCNVector3] = []
    private var triangleIndices: [Int32] = []
    private var textureCoordinates: [Float] = []
    
    convenience init(verticesPerSide: Int, sideLength: Double) {
        self.init(verticesPerSide: verticesPerSide, sideLength: sideLength, vertexHeight: nil)
    }
    
    init(verticesPerSide: Int, sideLength: Double, vertexHeight: ((Int, Int) -> Double)?) {
        self.verticesPerSide = verticesPerSide
        self.sideLength = sideLength
        self.vertexHeightComputationBlock = vertexHeight
        super.init()
        
        allocateDataBuffers()
        populateDataBuffersWithStartingValues()
        configureGeometry()
    }
    
    private func allocateDataBuffers() {
        let totalVertices = verticesPerSide * verticesPerSide
        let squaresPerSide = verticesPerSide - 1
        let totalSquares = squaresPerSide * squaresPerSide
        let totalTriangles = totalSquares * 2
        
        meshVertices = [SCNVector3](repeating: SCNVector3(0, 0, 0), count: totalVertices)
        normals = [SCNVector3](repeating: SCNVector3(0, 0, 0), count: totalVertices)
        triangleIndices = [Int32](repeating: 0, count: totalTriangles * 3)
        textureCoordinates = [Float](repeating: 0, count: totalVertices * 2)
    }
    
    private func populateDataBuffersWithStartingValues() {
        let totalVertices = verticesPerSide * verticesPerSide
        let squaresPerSide = verticesPerSide - 1
        let totalSquares = squaresPerSide * squaresPerSide
        let totalTriangles = totalSquares * 2
        
        for i in 0..<totalVertices {
            let ix = i % verticesPerSide
            let iy = i / verticesPerSide
            let ixf = Double(ix) / Double(verticesPerSide - 1)
            let iyf = Double(iy) / Double(verticesPerSide - 1)
            let x = ixf * sideLength
            let y = iyf * sideLength
            
            var vertexZDepth: Double = 0.0
            if let height = vertexHeightComputationBlock {
                vertexZDepth = height(ix, iy)
                if vertexZDepth.isNaN {
                    vertexZDepth = 0
                }
            }
            
            meshVertices[i] = SCNVector3(x, y, vertexZDepth)
            
            normals[i] = SCNVector3(0, 0, 1)
            
            let ti = i * 2
            textureCoordinates[ti] = Float(ixf)
            textureCoordinates[ti + 1] = Float(iyf)
        }
        
        for i in stride(from: 0, to: totalTriangles, by: 2) {
            let squareIndex = i / 2
            let squareX = squareIndex % squaresPerSide
            let squareY = squareIndex / squaresPerSide
            
            let vPerSide = verticesPerSide
            let topRightIndex = ((squareY + 1) * vPerSide) + squareX + 1
            let topLeftIndex = topRightIndex - 1
            let bottomLeftIndex = topRightIndex - vPerSide - 1
            let bottomRightIndex = topRightIndex - vPerSide
            
            let i1 = i * 3
            
            triangleIndices[i1] = Int32(topRightIndex)
            triangleIndices[i1 + 1] = Int32(topLeftIndex)
            triangleIndices[i1 + 2] = Int32(bottomLeftIndex)
            triangleIndices[i1 + 3] = Int32(topRightIndex)
            triangleIndices[i1 + 4] = Int32(bottomLeftIndex)
            triangleIndices[i1 + 5] = Int32(bottomRightIndex)
        }
    }
    
    private func configureGeometry() {
        let originalMaterials = self.geometry?.materials
        
        let totalVertices = verticesPerSide * verticesPerSide
        let squaresPerSide = verticesPerSide - 1
        let totalSquares = squaresPerSide * squaresPerSide
        let totalTriangles = totalSquares * 2
        
        let textureData = NSMutableData(bytes: &textureCoordinates, length: textureCoordinates.count * MemoryLayout<Float>.size)
        let textureSource = SCNGeometrySource(data: textureData as Data, semantic: .texcoord, vectorCount: totalVertices, usesFloatComponents: true, componentsPerVector: 2, bytesPerComponent: MemoryLayout<Float>.size, dataOffset: 0, dataStride: MemoryLayout<Float>.size * 2)
        let vertexSource = SCNGeometrySource(vertices: meshVertices)
        let normalSource = SCNGeometrySource(normals: normals)
        let indexData = NSData(bytes: triangleIndices, length: MemoryLayout<Int32>.size * totalTriangles * 3)
        let element = SCNGeometryElement(data: indexData as Data, primitiveType: .triangles, primitiveCount: totalTriangles, bytesPerIndex: 4)
        let geometry = SCNGeometry(sources: [vertexSource, normalSource, textureSource], elements: [element])
        if let materials = originalMaterials {
            geometry.materials = materials
        }
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func heightAt(point: CGPoint) -> Double {
        let vertexX = Int(round(Double(verticesPerSide) * Double(point.x)))
        let vertexY = Int(round(Double(verticesPerSide) * Double(point.y)))
        let index = vertexY * verticesPerSide + vertexX
        if index >= meshVertices.count {
            return 0
        }
        return Double(meshVertices[index].z)
    }
    
    func deformTerrain(atPoint point: CGPoint, brushRadius: Double, intensity: Double) {
        let radiusInIndices = brushRadius * Double(verticesPerSide)
        let vx = Double(verticesPerSide) * Double(point.x)
        let vy = Double(verticesPerSide) * Double(point.y)
        
        for y in 0..<verticesPerSide {
            for x in 0..<verticesPerSide {
                let xDelta = vx - Double(x)
                let yDelta = vy - Double(y)
                let dist = sqrt((xDelta * xDelta) + (yDelta * yDelta))
                
                if dist < radiusInIndices {
                    let index = y * verticesPerSide + x
                    
                    var relativeIntensity = 1 - dist / radiusInIndices
                    
                    relativeIntensity = sin(relativeIntensity * Double.pi/2)
                    relativeIntensity *= intensity
                    meshVertices[index].z += Float(relativeIntensity)
                }
            }
        }
        
        self.configureGeometry()
    }
    
    func updateGeometry(height: @escaping (Int, Int) -> Double) {
        self.vertexHeightComputationBlock = height
        populateDataBuffersWithStartingValues()
        configureGeometry()
    }
}
