//
//  FBVideoPlayer.swift
//  FBVideoPlayer
//
//  Created by Vishal on 21/11/19.
//  Copyright © 2019 Vishal Deep Kanojia. All rights reserved.
//

import UIKit
import WebKit

open class FBVideoPlayer: WKWebView {
    public let appID: String
    open private(set) var allowFullscreen: Bool = false
    open private(set) var autoplay: Bool = false
    open private(set) var href: String
    open private(set) var playerWidth: CGFloat?
    open private(set) var isMuted: Bool = false
    open private(set) var duration: Double?
    open private(set) var currentTime: Double?
    open private(set) var state: FBVideoPlayerState = .unstarted
    private var playerOptions: [FBVideoPlayerOption]?

    open weak var delegate: FBVideoPlayerDelegate?

    static private var defaultConfiguration: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = true
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .audio
        return config
    }

    private let callbackHandlers: [FBVideoPlayerEvent] = [
    .onReady,
    .startedPlaying,
    .paused,
    .finishedPlaying,
    .startedBuffering,
    .finishedBuffering,
    .currentTimeUpdated,
    .error
    ]

    public init(frame: CGRect = .zero, appID: String, href: String, options: [FBVideoPlayerOption]? = nil) {
        self.appID = appID
        self.href = href
        self.playerOptions = options

        let config = FBVideoPlayer.defaultConfiguration
        let userContentController = WKUserContentController()
        config.userContentController = userContentController

        super.init(frame: frame, configuration: config)

        callbackHandlers.forEach {
            userContentController.add(self, name: $0.rawValue)
        }

        commonInit()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Private methods

    private func commonInit() {
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
        isUserInteractionEnabled = true
    }

    public func loadPlayer() {
        if let options = playerOptions {
            for option in options {
                switch option {
                case .allowFullscreen(let fullscreen):
                    self.allowFullscreen = fullscreen
                case .autoplay(let autoplay):
                    self.autoplay = autoplay
                case .playerWidth(let width):
                    self.playerWidth = width
                }
            }
        }

        guard let html = getHtml() else { return }
        let baseURL = URL(string: "https://www.facebook.com")
        loadHTMLString(html, baseURL: baseURL)
    }

    private func getAttributes() -> [String: String] {
        return [
            "data-href": href,
            "data-width": playerWidth != nil ? "\(Int(playerWidth!))px" : "auto",
            "data-autoplay": autoplay ? "true" : "false",
            "data-allowfullscreen": allowFullscreen ? "true" : "false"
        ]
    }

    private func getHtml() -> String? {
        let bundle = Bundle(for: FBVideoPlayer.self)
        guard let path = bundle.path(forResource: "player", ofType: "html") else { return nil }
        guard let htmlString = try? String.init(contentsOfFile: path, encoding: String.Encoding.utf8) else { return nil }

        let attributeString = getAttributes().map({ return "\($0)=\"\($1)\"" }).joined(separator: " ")

        return htmlString
            .replacingOccurrences(of: "{{app_id}}", with: appID)
            .replacingOccurrences(of: "{{attributes}}", with: attributeString)
    }

    // Evaluate javascript command and convert to simple error(nil) if an error is occurred.
    private func evaluatePlayerCommand(_ commandName: String, callbackHandler: ((Any?) -> ())? = nil) {
        let command = "player.\(commandName);"
        evaluateJavaScript(command) { (result, error) in
            if error != nil {
                callbackHandler?(nil)
                return
            }
            callbackHandler?(result)
        }
    }

    // MARK: - setters

    public func setOptions(_ options: [FBVideoPlayerOption]) {
        self.playerOptions = options
    }

    // MARK: - Public methods

    public func play() {
        evaluatePlayerCommand("play()")
    }

    public func pause() {
        evaluatePlayerCommand("pause()")
    }

    public func seek(to seconds: Int) {
        evaluatePlayerCommand("seek(\(seconds))")
    }

    public func mute() {
        evaluatePlayerCommand("mute()")
    }

    public func unmute() {
        evaluatePlayerCommand("unmute()")
    }

}

// MARK: - WKScriptMessageHandler
extension FBVideoPlayer: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = FBVideoPlayerEvent(rawValue: message.name) else { return }

        switch event {
        case .onReady:
            delegate?.playerReady(self)
            if (autoplay) {
                play()
            }
            updateInfo()
        case .startedPlaying:
            updateInfo()
            state = .playing
            delegate?.player(self, didChangeState: state)
        case .paused:
            state = .paused
            delegate?.player(self, didChangeState: state)
        case .finishedPlaying:
            state = .ended
            delegate?.player(self, didChangeState: state)
        case .startedBuffering: ()
        case .finishedBuffering: ()
        case .currentTimeUpdated:
            updateInfo()
            if let currentTime = message.body as? Double {
                self.currentTime = currentTime
                delegate?.player(self, didUpdateCurrentTime: currentTime)
            }
        case .error:
            delegate?.player(self, didReceiveError: FBVideoPlayerError(body: message.body))
        }
    }

    // MARK: - Private Methods

    private func updateInfo() {
        updateMute()
        updateDuration()
    }

    private func updateMute() {
        evaluatePlayerCommand("isMuted()") { [weak self] result in
            guard let me = self,
                let isMuted = result as? Bool else { return }
            me.isMuted = isMuted
        }
    }

    private func updateDuration() {
        evaluatePlayerCommand("getDuration()") { [weak self] result in
            guard let me = self,
                let duration = result as? Double else { return }
            me.duration = duration
        }
    }

}
