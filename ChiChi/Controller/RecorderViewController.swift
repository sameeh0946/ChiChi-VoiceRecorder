//
//  RecorderViewController.swift
//  ChiChi
//
//  Created by Sameeh Ahmed on 07/11/20.
//

import UIKit
import AVFoundation
import Accelerate

struct Recording {
    var name: String
    var path: URL
}

protocol RecordingsViewControllerDelegate: class {
    func didStartPlayback()
    func didFinishPlayback()
}

enum RecorderState {
    case recording
    case recordingStopped
    case denied
    case notInitiated
    case playing
    case playingStopped
}

protocol RecorderViewControllerDelegate: class {
    func didStartRecording()
    func didFinishRecording()
}


class RecorderViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    //MARK:- Properties
    var handleView = UIView()
    var playButton = UIButton()
    var recordButton = RecordButton()
    var timeLabel = UILabel()
    var audioPlayer = AVAudioPlayer()
    var recorder: AVAudioRecorder!
    var recorderState: RecorderState = .notInitiated
    weak var delegate: RecorderViewControllerDelegate?
    var delegatee: RecordingsViewControllerDelegate?
    var audioView = AudioVisualizerView()
    
    //MARK:- Outlets
    @IBOutlet weak var fadeView: UIView!

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHandelView()
        setupRecordingButton()
        setupPlayButton()
        setupTimeLabel()
        setupAudioView()
        audioView.amplitude = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
    //MARK:- UI Views Programatic Setup Methods
    fileprivate func setupHandelView() {
        handleView.layer.cornerRadius = 2.5
        handleView.backgroundColor = UIColor.black
        view.addSubview(handleView)
        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.widthAnchor.constraint(equalToConstant: 37.5).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        handleView.alpha = 0
    }
    
    fileprivate func setupRecordingButton() {
        recordButton.isRecording = false
        recordButton.addTarget(self, action: #selector(handleRecording(_:)), for: .touchUpInside)
        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 65 ).isActive = true
    }
    
    fileprivate func setupPlayButton() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(handlePlay(_:)), for: .touchUpInside)
        view.addSubview(playButton)
        playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 65 ).isActive = true
        playButton.setImage(UIImage(named:"record"),for: .normal)
        
    }
    
    fileprivate func setupTimeLabel() {
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -16).isActive = true
        timeLabel.text = "00.00"
        timeLabel.textColor = .gray
        timeLabel.alpha = 0
    }
    
    fileprivate func setupAudioView() {
        view.addSubview(audioView)
        audioView.translatesAutoresizingMaskIntoConstraints = false
        audioView.leadingAnchor.constraint(equalTo: fadeView.leadingAnchor).isActive = true
        audioView.trailingAnchor.constraint(equalTo: fadeView.trailingAnchor).isActive = true
        audioView.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -50).isActive = true
        audioView.topAnchor.constraint(equalTo: fadeView.topAnchor,constant: -30).isActive = true
        audioView.alpha = 0
        audioView.isHidden = true
    }
    
    //MARK:- Play / Record Tap functions
    @objc func handlePlay(_ sender: UIButton) {
        print("handlePlay")
        
    }
    
    @objc func handleRecording(_ sender: UIButton) {
        print("handleRecord")
        
        var defaultFrame: CGRect = CGRect(x: 0, y: 24, width: view.frame.width, height: 135)
        //stopAudioPlayer()
        if recordButton.isRecording {
            playButton.isEnabled = false
            defaultFrame = self.view.frame
            audioView.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.handleView.alpha = 1
                self.timeLabel.alpha = 1
                self.audioView.alpha = 1
                self.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: -300)
                self.view.layoutIfNeeded()
            }, completion: nil)
            //self.checkPermissionAndRecord()
        } else {
            
            playButton.isEnabled = true
            audioView.isHidden = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.handleView.alpha = 0
                self.timeLabel.alpha = 0
                self.audioView.alpha = 0
                self.view.frame = defaultFrame
                self.view.layoutIfNeeded()
            }, completion: nil)
            recorderState = .recordingStopped
            //self.stopRecording()
            //stopAudioRecorder()
        }
    }
    
    
    
}
