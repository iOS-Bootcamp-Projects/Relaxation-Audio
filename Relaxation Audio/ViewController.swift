//
//  ViewController.swift
//  Relaxation Audio
//
//  Created by Aamer Essa on 13/12/2022.
//

import UIKit
import AVFoundation
import SCLAlertView

class ViewController: UIViewController {
    
    
    var audioPlayer: AVPlayer!
    var player: AVAudioPlayer?
    var isPlay = false
    var darkMode = false
    @IBOutlet weak var totalAudioTimer: UILabel!
    @IBOutlet weak var currentAudioTimer: UILabel!
    @IBOutlet weak var audioSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        audioSlider.thumbTintColor = UIColor(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.00)
        
        let doubleTapped = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapped.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapped)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(tripleTapped))
        tripleTap.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTap)
        
    }

    @objc func doubleTapped() {
        self.view.backgroundColor = .white
        self.totalAudioTimer.textColor = .black
        self.currentAudioTimer.textColor = .black
        if isPlay {
            audioPlayer.pause()
        }
        
        darkMode = false
        audioSlider.value = 0.0
        audioSlider.maximumValue = 22
        currentAudioTimer.text = "00:00"
        totalAudioTimer.text = "00:22"
    }
    @objc func tripleTapped() {
        self.view.backgroundColor = .black
        self.totalAudioTimer.textColor = .white
        self.currentAudioTimer.textColor = .white
        if isPlay {
            audioPlayer.pause()
        }
        darkMode = true
        audioSlider.value = 0.0
        audioSlider.maximumValue = 30
        currentAudioTimer.text = "00:00"
        totalAudioTimer.text = "00:30"
    }
    

    
    @IBAction func playSound(_ sender: Any) {

        if !isPlay {
            
            if darkMode {
                guard let url = URL(string: "https://www.soundjay.com/nature/rain-03.mp3") else {
                            print("error to get the mp3 file")
                            return
                        }
                audioPlayer = AVPlayer(url: url as URL)
                audioPlayer?.play()
                 isPlay = true
            }
            else {
                guard let url = URL(string: "https://www.soundjay.com/nature/ocean-wave-1.mp3") else {
                            print("error to get the mp3 file")
                            return
                        }
                audioPlayer = AVPlayer(url: url as URL)
                audioPlayer?.play()
                 isPlay = true
            }
            
            
           
       }
        else {
            audioPlayer.pause()
            isPlay = false
        }
        
        SCLAlertView().showWait("Please be patient",subTitle: "This will take a moment. \n \n Thanks... \n \n Note: if it doesn't work please click again ")
        
        //track player prograss
        let interval = CMTime(value: 1, timescale: 2)
        audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { time in
          let seconde = CMTimeGetSeconds(time)
            let secodeForamt = String(format: "%02d", Int(seconde))
            self.currentAudioTimer.text = "00:\(secodeForamt)"
            
            self.audioSlider.value = Float(seconde)
            
        } // track player prograss



    } // playSound()
    
    @IBAction func showInfo(_ sender: Any) {
        SCLAlertView().showInfo("Tap Screen" , subTitle: "double tap or triple tap on the screen for more! \n \n (double tap)\n - reslaxing ocean sound \n - light mode \n \n (triple tap) \n - reslaxing rain sound \n - dark mode \n  \n Obliviate as an app for parcticing breathing and relaxation \n \n © 2020 Terry Ledford, Ph.D")
      
    }
    
    @IBAction func scrubAudio(_ sender: UISlider) {
        
        let seekTime = CMTime(value: CMTimeValue(sender.value), timescale: 1)
        audioPlayer.seek(to: seekTime) { complation in
            let duration = self.audioPlayer.currentTime()
            
            let seconde = CMTimeGetSeconds(duration)
           let timer = Int(seconde) % 60
            self.currentAudioTimer.text = "00:\(timer)"
            
            
        }
    }
}

