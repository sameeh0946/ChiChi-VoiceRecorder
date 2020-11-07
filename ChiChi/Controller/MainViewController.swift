//
//  MainViewController.swift
//  VoiceMemosClone
//
//  Created by Sameeh Ahmed on 6/11/20.


import UIKit


class MainViewController: UIViewController {

    //MARK:- Properties
    
    private var recorderViewController: RecorderViewController? {
        get {
            return children.compactMap({ $0 as? RecorderViewController }).first
        }
    }
    
    //MARK:- Outlets
//    @IBOutlet weak var recordingsView: UIView!
    @IBOutlet weak var recorderView: UIView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

}


extension MainViewController: RecordingsViewControllerDelegate {
    func didStartPlayback() {
        if let recorder = self.recorderViewController {
            recorder.fadeView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                recorder.fadeView.alpha = 1
            })
        }
    }
    
    func didFinishPlayback() {
        if let recorder = self.recorderViewController {
            recorder.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                recorder.fadeView.alpha = 0
            }, completion: { (finished) in
                if finished {
                    recorder.fadeView.isHidden = true
                }
            })
        }
    }
}
