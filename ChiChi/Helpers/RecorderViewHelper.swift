//
//  RecorderViewModel.swift
//  ChiChi
//
//  Created by Sameeh Ahmed on 07/11/20.
//

import Foundation
import AVFoundation


final class RecorderViewHelper {
    
    var getAudioFileURL: URL? {
        let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return docDirURL?.appendingPathComponent("\(Constants.AudioFile.name).\(Constants.AudioFile.fileExtension)", isDirectory: false)
    }
    
    func writeToAudioFile(_ audioFile: AVAudioFile?, audioBuffer: AVAudioPCMBuffer) throws {
        try audioFile?.write(from: audioBuffer)
    }
    
    
    let settings = [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMBitDepthKey: 16, AVLinearPCMIsFloatKey: true, AVSampleRateKey: Float64(44100), AVNumberOfChannelsKey: 1] as [String : Any]
    
    func format() -> AVAudioFormat? {
        let format = AVAudioFormat(settings: self.settings)
        return format
    }
    
    func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }
    

}



