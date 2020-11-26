//
//  ErrorMessages.swift
//  ChiChi
//
//  Created by Sameeh Ahmed on 07/11/20.
//

import Foundation

enum Message: String {
    case alertTitleMessage = "Attention"
    case noRecordingPlayTapped = "Please record an audio before playing"
    case storageFileUrl = "Sorry there was a problem creating placeholder in the file system"
    case audioFileNotCreated = "Sorry there was a problem creating audio file"
    case writingAudioToFileFail = "Audio couldn't be written into the file"
    case audioEngineNotStarted = "Sorry there was a problem starting the Audio Engine"
    case audioPlayerError = "Audio Player Error"
    case audioFormatFail = "Sorry there was a problem converting to audio format"
}
