//
//  FBVideoPlayerConstants.swift
//  FBVideoPlayer
//
//  Created by Vishal on 21/11/19.
//  Copyright © 2019 Vishal Deep Kanojia. All rights reserved.
//

import UIKit

public enum FBVideoPlayerOption {
    case allowFullscreen(fullscreen: Bool)
    case autoplay(autoplay: Bool)
    case playerWidth(width: CGFloat?)
}

public enum FBVideoPlayerEvent: String {
    case onReady
    case startedPlaying
    case paused
    case finishedPlaying
    case startedBuffering
    case finishedBuffering
    case currentTimeUpdated
    case error
}
