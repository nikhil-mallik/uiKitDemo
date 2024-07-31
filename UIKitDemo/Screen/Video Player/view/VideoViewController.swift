//
//  VideoViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 31/07/24.
//

import UIKit
import WebKit
import AVKit

class VideoViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let videoURLs: [String] = [
        "https://vimeo.com/580298409",
        "https://vimeo.com/336812686",
        "loginbg.mp4"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register the cell XIB file
        let nib = UINib(nibName: "VideoPlayerCellView", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "VideoCell")
    
        collectionView.decelerationRate = .fast
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoPlayerCellView
        let videoURL = videoURLs[indexPath.row]
        
        if videoURL.hasPrefix("http") {
            // Web-based videos (YouTube, Vimeo)
            //            let embedURL = getEmbedURL(from: videoURL)
            //            if let url = URL(string: embedURL) {
            //                let request = URLRequest(url: url)
            //                cell.webView.isHidden = false
            //                cell.webView.load(request)
            //                cell.avPlayerLayer?.removeFromSuperlayer()
            //            }
            // Web-based videos (YouTube, Vimeo)
            let embedHTML = getEmbedHTML(from: videoURL)
            cell.loadWebViewWithHTML(embedHTML)
        } else {
            // Local MP4 video
            if let path = Bundle.main.path(forResource: videoURL, ofType: nil) {
                let url = URL(fileURLWithPath: path)
                let player = AVPlayer(url: url)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = cell.contentView.bounds
                cell.contentView.layer.addSublayer(playerLayer)
                player.play()
                
                cell.webView.isHidden = true
                cell.avPlayerLayer = playerLayer
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 9 / 16)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // MARK: - Helper Methods
    
    //    private func getEmbedURL(from videoURL: String) -> String {
    //        if videoURL.contains("youtube.com") || videoURL.contains("youtu.be") {
    //            return videoURL.replacingOccurrences(of: "watch?v=", with: "embed/")
    //        } else if videoURL.contains("vimeo.com") {
    //            let components = videoURL.split(separator: "/")
    //            if let videoID = components.last {
    //                return "https://player.vimeo.com/video/\(videoID)"
    //            }
    //        }
    //        return videoURL
    //    }
    
    private func getEmbedHTML(from videoURL: String) -> String {
        let embedURL: String
        if videoURL.contains("youtube.com") || videoURL.contains("youtu.be") {
            embedURL = videoURL.replacingOccurrences(of: "watch?v=", with: "embed/")
        } else if videoURL.contains("vimeo.com") {
            let components = videoURL.split(separator: "/")
            if let videoID = components.last {
                embedURL = "https://player.vimeo.com/video/\(videoID)"
            } else {
                embedURL = videoURL
            }
        } else {
            embedURL = videoURL
        }
        return """
        <html>
        <body style="margin:0px;padding:0px;">
        <iframe width="100%" height="100%" src="\(embedURL)?autoplay=1" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
        </body>
        </html>
        """
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handlePlayback(for: collectionView.visibleCells as! [VideoPlayerCellView], play: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        handlePlayback(for: collectionView.visibleCells as! [VideoPlayerCellView], play: false)
    }
    
    // MARK: - Playback Control
    private func handlePlayback(for cells: [VideoPlayerCellView], play: Bool) {
        for cell in cells {
            if play {
                cell.playVideo()
            } else {
                cell.pauseVideo()
            }
        }
    }
}

// MARK: - Extension
extension VideoViewController {
    // Create an instance of ViewController from storyboard
    static func sharedIntance() -> VideoViewController {
        return VideoViewController.instantiateFromStoryboard("VideoViewController")
    }
}
