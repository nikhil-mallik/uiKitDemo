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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupWebView()
        setupActivityIndicator()
    }
    
    private func setupWebView() {
        // Create WKWebView with configuration
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.allowsInlineMediaPlayback = true
        webViewConfig.mediaTypesRequiringUserActionForPlayback = []
        webView = WKWebView(frame: contentView.bounds, configuration: webViewConfig)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        contentView.addSubview(webView)
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
    
    func loadWebViewWithHTML(_ html: String) {
        activityIndicator.startAnimating()
        webView.loadHTMLString(html, baseURL: nil)
        webView.isHidden = false
        avPlayerLayer?.removeFromSuperlayer()
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
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
