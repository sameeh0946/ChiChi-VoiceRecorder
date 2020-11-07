//
//  Constants.swift
//  ChiChi
//
//  Created by Rishabh Karotiya on 07/11/20.
//
import AVFoundation

struct Constants {
    
//    struct Waveform {
//        static let numberOfMiniWaves = 5
//        static let defaultScale: Float = 0.4
//    }
    
    struct AudioFile {
        static let name = "recording"
        static let fileExtension = "wav"
    }
    
    struct Audio {
        static let bufferSize = 4096
        static let commonFormat: AVAudioCommonFormat = .pcmFormatFloat32
    }
}
