//
//  BgVideoPlay.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 08/06/24.
//

import AVFoundation
import UIKit

// MARK: - BgVideoPlay Class
final class BgVideoPlay {
    // Singleton instance of BgVideoPlay
    static let shared = BgVideoPlay()
    
    private var videoPlayer: AVPlayer?
    private var videoPlayerLayer: AVPlayerLayer?
    
    // Private initializer to ensure the singleton pattern
    private init() {}
    
    // Method to set up and play the video on a given view
    func setUpVideo(on view: UIView) {
        // Get the path to the video resource in the bundle
        guard let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4") else {
            print("Video not found") // Print error message if the video is not found
            return
        }
        
        // Create a URL from the bundle path
        let url = URL(fileURLWithPath: bundlePath)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the video player with the item
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the player layer for the video player
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        // Adjust the size and frame of the player layer
        videoPlayerLayer?.frame = CGRect(x: -view.frame.size.width * 1.5, y: 0, width: view.frame.size.width * 4, height: view.frame.size.height)
        
        // Insert the player layer into the view's layer at the bottom
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add an observer to loop the video when it reaches the end
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: item)
        
        // Play the video immediately at a specified rate
        videoPlayer?.playImmediately(atRate: 0.3)
    }
    
    // Method called when the video reaches the end to loop it
    @objc private func videoDidReachEnd(_ notification: Notification) {
        videoPlayer?.seek(to: .zero) // Seek to the start of the video
        videoPlayer?.playImmediately(atRate: 0.3) // Play the video again at the specified rate
    }
    
    // Method to stop the video and clean up
    func stopVideo() {
        videoPlayer?.pause() // Pause the video player
        videoPlayerLayer?.removeFromSuperlayer() // Remove the player layer from the view
        // Remove the observer for the video end notification
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
