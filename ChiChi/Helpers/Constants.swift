//
//  Constants.swift
//  ChiChi
//
//  Created by Sameeh Ahmed on 07/11/20.
//
import AVFoundation

struct Constants {
    
    struct AudioFile {
        static let name = "recording"
        static let fileExtension = "wav"
    }
    
    struct Audio {
        static let bufferSize = 4096
        static let commonFormat: AVAudioCommonFormat = .pcmFormatFloat32
    }
}
