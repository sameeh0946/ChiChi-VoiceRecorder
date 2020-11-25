//
//  RecorderViewController.swift
//  ChiChi
//
//  Created by Sameeh Ahmed on 07/11/20.
//

import UIKit
import AVFoundation
import Accelerate


class RecorderViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    //MARK:- Properties
    //MARK:- View Properties
    var handleView = UIView()
    var playButton = UIButton()
    var recordButton = RecordButton()
    var timeLabel = UILabel()
    var audioPlayer = AVAudioPlayer()
    var recorder: AVAudioRecorder!
    var recorderState: RecorderState = .notInitiated
    var audioView = AudioVisualizerView()
    var timer: Timer?
    private var recorderViewHelper = RecorderViewHelper()
    
    var delegatee: RecordingsViewControllerDelegate?
    //MARK:- Audio Properties
    private lazy var audioEngine = AVAudioEngine()
    private lazy var audioMixerNode: AVAudioMixerNode = {
        let node = AVAudioMixerNode()
        node.volume = 0
        return node
    }()
    var audioBuffer = Data()
    var recordingTs: Double = 0
    
    //MARK:- Outlets
    @IBOutlet weak var fadeView: UIView!

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Audio engine initialization
        initAudioEngine()

        //Programatic Views Setup
        setupHandelView()
        setupRecordingButton()
        setupPlayButton()
        setupTimeLabel()
        setupAudioView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationName = AVAudioSession.interruptionNotification
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecording(_:)), name: notificationName, object: nil)
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    func initAudioEngine(){
        audioEngine.attach(audioMixerNode)
        makeConnections()
        audioEngine.prepare()
    }
    
    func makeConnections() {
        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        audioEngine.connect(inputNode,
                            to: audioMixerNode,
                            format: inputFormat)
        
        let mainMixerNode = audioEngine.mainMixerNode
        let mixerFormat = AVAudioFormat(commonFormat: Constants.Audio.commonFormat,
                                        sampleRate: inputFormat.sampleRate,
                                        channels: inputFormat.channelCount,
                                        interleaved: false)
        audioEngine.connect(audioMixerNode, to: mainMixerNode, format: mixerFormat)
    }
    
    private func updateUI(_ recorderState: RecorderState) {
        switch recorderState {
        case .recording:
            UIApplication.shared.isIdleTimerDisabled = true
            self.audioView.isHidden = false
            self.timeLabel.isHidden = false
            break
        case .recordingStopped:
            UIApplication.shared.isIdleTimerDisabled = false
            self.audioView.isHidden = true
            break
        case .denied:
            UIApplication.shared.isIdleTimerDisabled = false
            self.recordButton.isHidden = true
            self.audioView.isHidden = true
            self.timeLabel.isHidden = true
            break
        case .notInitiated:
            break
        case .playing:
            break
        case .playingStopped:
            
            break
        }
    }
    
    //MARK:- Play / Record Tap functions
    @objc func handlePlay(_ sender: UIButton) {
        print("handlePlay")
        switch recorderState {
         case .notInitiated:
             break
         //showAlert(message: .noRecordingPlayTapped)
         case .recording:
             break
         //showAlert(message: .inRecordingPlayTapped)
         case .recordingStopped:
            
             //Write only if user has recorded a sound and after that play the recording
             guard let audioFileURL = writeToFile() else {
                 //showAlert(message: .writingAudioToFileFail)
                 return
             }
             
             do {
                 audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                 startAudioPlayer()
             } catch {
                 //showAlert(message: .audioPlayerError)
             }
     
         case .playing:
            startAudioPlayer()
             break
             
         case .denied:
             break
         case .playingStopped:
             startAudioPlayer()
         }

    }
    
    @objc func handleRecording(_ sender: UIButton) {
        print("handleRecord")
        
        var defaultFrame: CGRect = CGRect(x: 0, y: 24, width: view.frame.width, height: 135)

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
            self.checkPermissionAndRecord()
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
            self.stopAudioRecorder()
        }
    }
    
    //MARK:-  Recording Permissions
    private func checkPermissionAndRecord() {
        let permission = AVAudioSession.sharedInstance().recordPermission
        switch permission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
                DispatchQueue.main.async {
                    if result {
                        self.audioBuffer.removeAll()
                        self.startAudioRecorder()
                        self.startRecording()
                    }
                    else {
                        self.recorderState = .denied
                        self.updateUI(.denied)
                    }
                }
            })
            break
        case .granted:
            
            self.audioBuffer.removeAll()
            self.startAudioRecorder()
            self.startRecording()
            break
        case .denied:
            
            self.updateUI(.denied)
            break
        @unknown default:
            break
        }
    }
    
    //MARK:-  Recording Functions
    //MARK:-  Audio record for Time Label and audio record for playblack
    func startAudioRecorder() {
        let tapNode: AVAudioNode = audioMixerNode
        let format = tapNode.outputFormat(forBus: 0)
        self.recordingTs = NSDate().timeIntervalSince1970
        
        tapNode.installTap(onBus: 0,
                           bufferSize: AVAudioFrameCount(4096),
                           format: format) { (buffer, time) in
            let ts = NSDate().timeIntervalSince1970
            DispatchQueue.main.async {
                
                let seconds = (ts - self.recordingTs)
                print("2seconds \(seconds)")
                self.timeLabel.text = seconds.toTimeString
            }
            //MARK:-  Appending audio data to buffer in pcm format
            //init Data as a PCMBuffer (Data extention found in CommonUtils)
            let data = Data(buffer: buffer)
            self.audioBuffer.append(data)
        }
        
        do {
            try audioEngine.start()
            recorderState = .recording
        } catch {
            //SHOWALERT MISSING showAlert(message: .audioEngineNotStarted)
        }
    }
    //MARK:-  Audio record for audio buffer for waveform
    private func startRecording() {
    
        self.audioView.density = 1.0
        self.audioView.waveColor = UIColor.blue
        
        if self.recorder != nil {
            return
        }
        
        let url: NSURL = NSURL(fileURLWithPath: "/dev/null")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.recorder = try AVAudioRecorder(url: url as URL, settings: settings )
            self.recorder.delegate = self
            self.recorder.isMeteringEnabled = true
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: recorderViewHelper.convertFromAVAudioSessionCategory(AVAudioSession.Category.record)))
            self.recorder.record()
            
            timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
        }
        catch {
            print("Fail to record.")
        }
        
        self.updateUI(.recording)
    }
    
    
    //MARK:-  Stop Both Time Label and audio record for playblack and audio buffer for waveform
    private func stopAudioRecorder() {
                
        //Voice Recorder
        audioMixerNode.removeTap(onBus: 0)
        audioEngine.stop()
        recorderState = .recordingStopped
        self.audioEngine.inputNode.removeTap(onBus: 0)

        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
        self.updateUI(.recordingStopped)

    }
    

    //MARK:-  Calculating amplitude of the maveform
    @objc internal func refreshAudioView(_: Timer) {
        // Set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude = 0.5
        recorder.updateMeters()
        let normalizedValue:CGFloat = pow(10, CGFloat(recorder.averagePower(forChannel: 0))/20)
        self.audioView.amplitude = normalizedValue
        print("refreshAudioView normalizedValue : \(normalizedValue)")
    }

    func writeToFile() -> URL? {
        
        guard let audioFileURL = recorderViewHelper.getAudioFileURL else {
           // showAlert(message: .storageFileUrl)
            return nil
        }
    // byte array is converted which will be used to get the wav file
    let inputFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        
    guard let format = AVAudioFormat(commonFormat: Constants.Audio.commonFormat,
                                     sampleRate: inputFormat.sampleRate,
                                     channels: inputFormat.channelCount,
                                     interleaved: false),
          let buffer = audioBuffer.toPCMBuffer(format: format)
    //buffer is a AVAudio PCM Buffer
    
    else {
        //MissingshowAlert(message: .audioFormatFail)
        return nil
    }
    //Chunk file in PCM format
    var audioFile: AVAudioFile?
    do {
        audioFile = try getAudioFile(audioFileURL: audioFileURL, settings: format.settings)
    } catch {
        //MissingshowAlert(message: .audioFileNotCreated)
        return nil
    }
    do {
        // write from buffer (pcm) into audio file wav format
        try recorderViewHelper.writeToAudioFile(audioFile, audioBuffer: buffer)
    } catch {
        print(error)
    }
    // audioFileURL contains the path of the wav file
    return audioFileURL
}
    
    private func startAudioPlayer() {
        recorderState = .playing
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.isMeteringEnabled = true
        audioPlayer.play()
    }

    func getAudioFile(audioFileURL: URL, settings: [String: Any]) throws -> AVAudioFile? {
        return try AVAudioFile(forWriting: audioFileURL,
                               settings: settings,
                               commonFormat: .pcmFormatFloat32,
                               interleaved: false)
    }

    
}
