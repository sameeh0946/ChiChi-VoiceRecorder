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
    case storageFileUrl = "Couldn't create a placeholder in the file system"
    case audioFileNotCreated = "Couldn't create audio file"
    case writingAudioToFileFail = "Audio couldn't be written into the file"
    case audioEngineNotStarted = "Couldn't start the Audio Engine"
    case audioPlayerError = "Audio Player Error"
    case inRecordingPlayTapped = "Stop the recording first"
    case audioFormatFail = "Can't convert to audio format"
    case permissionDenied = "Permission Denied"
}
