//
//  DisplayVideoCell.swift
//  TictokLoader
//
//  Created by Darren Nguyen on 22/09/2022.
//

import UIKit
import AVFoundation
import GSPlayer
class DisplayVideoCell: UICollectionViewCell {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var displaycontent: UIImageView!
    lazy var player: GSPlayer.VideoPlayerView = {
        let playerView = GSPlayer.VideoPlayerView()

        return playerView
    }()
    
    // MARK: - Variables
    private(set) var isPlaying = false
    private(set) var liked = false
    
    // MARK: LIfecycles
    override func prepareForReuse() {
        player.pause()
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        player.frame = self.bounds
        pauseButton.frame = self.bounds
        pauseButton.tintColor = .white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displaycontent.addSubview(player)
    }
    
    
    func configure(url: String) {
        player.play(for: URL(string: url)!)
        player.pause()

    }
    
    
    func replay(){
        player.resume()
        player.seek(to: .zero)
    }
    
    func pause(){
        player.pause(reason: .userInteraction)
    }
    
    @objc func handlePause(){
        if player.state == .playing {
            // Pause video and show pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                guard let self = self else { return }
                self.pauseButton.setImage(UIImage(named: "icon-play")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }, completion: { [weak self] _ in
                self?.pause()
            })
        } else {
            // Start video and remove pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.pauseButton.setImage(UIImage(named: "")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }, completion: { [weak self] _ in
                self?.player.resume()
            })
        }
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        handlePause()
    }
    func resetViewsForReuse(){
    }
    
    
    // MARK: - Actions
    // Like Video Actions
    @IBAction func like(_ sender: Any) {
        if !liked {
            likeVideo()
        } else {
            liked = false
        }
        
    }
    
    @objc func likeVideo(){
        if !liked {
            liked = true
        }
    }
    
}
