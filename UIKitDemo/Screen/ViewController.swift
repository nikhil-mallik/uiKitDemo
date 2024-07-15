//
//  ViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    // MARK: - Outlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide back button in navigation bar
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up the background video
        BgVideoPlay.shared.setUpVideo(on: self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the video when the view disappears
        BgVideoPlay.shared.stopVideo()
    }
}

// MARK: - Extension
extension ViewController {
    // Create an instance of ViewController from storyboard
    static func sharedIntance() -> ViewController {
        return ViewController.instantiateFromStoryboard("ViewController")
    }
}
