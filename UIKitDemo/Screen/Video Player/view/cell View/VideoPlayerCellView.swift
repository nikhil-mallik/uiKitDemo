//
//  VideoPlayerCellView.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 31/07/24.
//

import UIKit
import WebKit
import AVKit

class VideoPlayerCellView: UICollectionViewCell, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    var avPlayerLayer: AVPlayerLayer?
    var activityIndicator: UIActivityIndicatorView!
    
    var videoURLStr: String = ""
    var youtubeVideoID: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
        
        // Center the activity indicator in the cell
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func loadMedia(videoURL: String) {
        videoURLStr = videoURL
        
        if videoURLStr.contains("youtu.be") || videoURLStr.contains("youtube.com") {
            let getId = videoURLStr.youtubeID
            youtubeVideoID = getId ?? ""
            loadYoutubeVideo(videoID: youtubeVideoID)
        } else {
            loadOtherMediaTypeVideo(videoURL: videoURLStr)
        }
    }
    
    private func loadYoutubeVideo(videoID: String) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?autoplay=1") else {
            return
        }
        webView.isHidden = false
        activityIndicator.startAnimating()
        webView.load(URLRequest(url: youtubeURL))
    }
    
    private func loadOtherMediaTypeVideo(videoURL: String) {
           
        guard let mediaURL = URL(string: videoURL) else {
            return
        }
        print("videoURL ", mediaURL)
      
        // Check if the URL is from Vimeo
           if videoURL.contains("vimeo.com") {
        
               webView.isHidden = false
               activityIndicator.startAnimating()
               webView.load(URLRequest(url: mediaURL))

           } else {
               print("videoURL ", mediaURL)
               webView.isHidden = false
               activityIndicator.startAnimating()
               webView.load(URLRequest(url: mediaURL))
           }
        webView.navigationDelegate = self
    }
    
    func playVideo() {
        avPlayerLayer?.player?.play()
    }
    
    func pauseVideo() {
        avPlayerLayer?.player?.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        webView.stopLoading()
        webView.isHidden = false
        avPlayerLayer?.removeFromSuperlayer()
        activityIndicator.stopAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the webView and avPlayerLayer have the same frame
        webView.frame = contentView.bounds
        avPlayerLayer?.frame = contentView.bounds
    }
    
    // WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        let js = """
        (function checkPlayButton() {
            var playButton = document.querySelectorAll('[class^="PlayButton_module_playButton"]')[0];
            if (playButton && playButton.firstElementChild) {
                playButton.firstElementChild.click();
                console.log("Play button clicked");
            } else {
                console.log("Play button not found, retrying...");
                setTimeout(checkPlayButton, 1000); // Retry after 1 second
            }
        })();
        """
        
        webView.evaluateJavaScript(js) { (result, error) in
            if let error = error {
                print("JavaScript error: \(error.localizedDescription)")
            } else {
                print("JavaScript executed successfully")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Webview error: \(error.localizedDescription)")
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load video: \(error.localizedDescription)")
        activityIndicator.stopAnimating()
    }
}

// MARK: - String Extension for YouTube ID Extraction
extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}
