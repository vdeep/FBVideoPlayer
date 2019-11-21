//
//  FBVideoPlayerState.swift
//  FBVideoPlayer
//
//  Created by Vishal on 21/11/19.
//  Copyright © 2019 Vishal Deep Kanojia. All rights reserved.
//

import Foundation

public enum FBVideoPlayerState: Int {
    case unstarted  = -1
    case ended      = 0
    case playing    = 1
    case paused     = 2
    case buffering  = 3
    case cued       = 4
}
