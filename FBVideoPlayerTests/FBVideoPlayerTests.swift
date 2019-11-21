//
//  FBVideoPlayerTests.swift
//  FBVideoPlayerTests
//
//  Created by Vishal on 21/11/19.
//  Copyright © 2019 Vishal Deep Kanojia. All rights reserved.
//

import XCTest
@testable import FBVideoPlayer

class FBVideoPlayerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitWithDefaultParameters() {
        let href: String = "https://www.facebook.com/facebook/videos/10153231379946729/"
        let player = FBVideoPlayer(appID: "1234", href: href)

        player.loadPlayer()

        XCTAssert(player.appID == "1234")
        XCTAssert(player.allowFullscreen == false)
        XCTAssert(player.autoplay == false)
        XCTAssert(player.href == href)
        XCTAssert(player.playerWidth == nil)
    }

    func testInitWithPlayerOptions() {
        let href: String = "https://www.facebook.com/facebook/videos/10153231379946729/"
        let player = FBVideoPlayer(
            appID: "1234",
            href: href,
            options: [
                .allowFullscreen(fullscreen: true),
                .autoplay(autoplay: true),
                .playerWidth(width: 414)
        ])

        player.loadPlayer()

        XCTAssert(player.appID == "1234")
        XCTAssert(player.allowFullscreen == true)
        XCTAssert(player.autoplay == true)
        XCTAssert(player.href == href)
        XCTAssert(player.playerWidth == 414)
    }

    func testHTML() {
        let href: String = "https://www.facebook.com/facebook/"
        let player = FBVideoPlayer(
            appID: "1234",
            href: href,
            options: [
                .allowFullscreen(fullscreen: true),
                .autoplay(autoplay: true),
                .playerWidth(width: 414)
        ])

        player.loadPlayer()
    }

}
