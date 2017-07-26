// 
//  GridLoadingError.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

public enum GridLoadingError: Error {
    case invalidSceneName(String)
    
    case missingGridNode(String)
    case missingFloor(String)
    case missingCameraNode(String)
    
    case invalidDimensions(Int, Int)
}
