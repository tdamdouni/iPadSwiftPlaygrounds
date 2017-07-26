// 
//  GridLoadingError.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

public enum GridLoadingError: ErrorProtocol {
    case invalidSceneName(String)
    
    case missingGridNode(String)
    case missingFloor(String)
    case missingCameraNode(String)
    
    case invalidDimensions(Int, Int)
}
