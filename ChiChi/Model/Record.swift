//
//  Record.swift
//  ChiChi
//
//  Created by Rishabh Karotiya on 07/11/20.
//

import Foundation


struct Recording {
    var name: String
    var path: URL
}

enum RecorderState {
    case recording
    case recordingStopped
    case denied
    case notInitiated
    case playing
    case playingStopped
}
