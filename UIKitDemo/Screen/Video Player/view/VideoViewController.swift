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
        "https://vimeo.com/user196125621/review/1014363323/3e86fd80e1",
        "https://vimeo.com/580298409",
        "https://vimeo.com/336812686"
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
            cell.loadMedia(videoURL: videoURL)
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
    private func getEmbedHTML(from videoURL: String) -> String {
        let embedURL: String = "https://vimeo.com/user196125621/review/1014363323/3e86fd80e1"
        
        // Return HTML string for embedding the video
        return """
        <html>
        <body style="margin:0px;padding:0px;">
        <iframe width="100%" height="100%" src="\(embedURL)?muted=0&controls=1&autoplay=1&background=0&loop=1" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
        </body>
        </html>
        """
    }


    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check visibility of cells during scroll
        handlePlaybackForVisibleCells()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Play videos in fully visible cells after scrolling ends
        handlePlaybackForVisibleCells(play: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Pause videos when user starts dragging
        handlePlaybackForVisibleCells(play: false)
    }
    
    // MARK: - Playback Control
    
    private func handlePlaybackForVisibleCells(play: Bool = false) {
        for cell in collectionView.visibleCells {
            guard let videoCell = cell as? VideoPlayerCellView else { continue }
            
            let cellFrameInSuperview = collectionView.convert(videoCell.frame, to: collectionView.superview)
            let isFullyVisible = collectionView.bounds.contains(cellFrameInSuperview)
            
            if isFullyVisible {
                if play {
                    videoCell.playVideo()
                } else {
                    videoCell.pauseVideo()
                }
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
