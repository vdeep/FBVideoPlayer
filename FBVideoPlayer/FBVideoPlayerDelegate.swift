//
//  FBVideoPlayerDelegate.swift
//  FBVideoPlayer
//
//  Created by Vishal on 21/11/19.
//  Copyright © 2019 Vishal Deep Kanojia. All rights reserved.
//

import UIKit

public protocol FBVideoPlayerDelegate: class {
    /**
     - parameters:
         - player: The current active player instance
         - state: The updated player state
     */
    func player(_ player: FBVideoPlayer, didChangeState state: FBVideoPlayerState)

    /**
     - parameters:
         - player: The current active player instance
         - error: The received error
     */
    func player(_ player: FBVideoPlayer, didReceiveError error: Error)

    /**
     - parameters:
         - player: The current active player instance
         - currentTime: The updated current time of video duration
     */
    func player(_ player: FBVideoPlayer, didUpdateCurrentTime currentTime: Double)

    /**
     Notify that the player can play video

     - parameters:
        - player: The current active player instance
     */
    func playerReady(_ player: FBVideoPlayer)

}

public extension FBVideoPlayerDelegate {
    /**
     Invoked when player state has changed

     - parameters:
         - player: The player instance that is reflected latest state.
         - state: The current player state
     */
    func player(_ player: FBVideoPlayer, didChangeState state: FBVideoPlayerState) {}

    /**
     Invoked when an error has occured

     - parameters:
     - player: The current active player instance
     - error: The received error
     */
    func player(_ player: FBVideoPlayer, didReceiveError error: Error) {}

    /**
     Invoked when the current time is updated

     - parameters:
        - player: The current active player instance
        - currentTime: The updated current time of video duration
     */
    func player(_ player: FBVideoPlayer, didUpdateCurrentTime currentTime: Double) {}

    /**
     Invoked when the player is ready

     - parameters:
        - player: The current active player instance
     */
    func playerReady(_ player: FBVideoPlayer) {}
}
