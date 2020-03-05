//
//  ViewController.swift
//  FBVideoPlayerExample
//
//  Created by Vishal on 21/11/19.
//  Copyright © 2019 Vishal Deep Kanojia. All rights reserved.
//

import UIKit
import FBVideoPlayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let player = FBVideoPlayer(
            frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 300),
            appID: "1621582677958931",
            href: "https://www.facebook.com/punjabkesariyum/videos/759693904532359",
            options: [
                .allowFullscreen(fullscreen: true),
                .autoplay(autoplay: true),
                .playerWidth(width: UIScreen.main.bounds.width)
        ])
        player.delegate = self
        player.loadPlayer()
        view.addSubview(player)
    }

}

// MARK: - FBVideoPlayerDelegate
extension ViewController: FBVideoPlayerDelegate {

    func player(_ player: FBVideoPlayer, didChangeState state: FBVideoPlayerState) {
        print(state)
    }

    func player(_ player: FBVideoPlayer, didReceiveError error: Error) {
        print(error)
    }

    func player(_ player: FBVideoPlayer, didUpdateCurrentTime currentTime: Double) {
        print("\(currentTime) of \(player.duration ?? 0)")
    }

    func playerReady(_ player: FBVideoPlayer) {
        print("Ready!")
    }

}
