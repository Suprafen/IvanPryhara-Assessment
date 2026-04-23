//
//  VideoManager.swift
//  IvanPryharaVonage
//
//  Created by Ivan Pryhara on 23/04/2026.
//

import OpenTok
import SwiftUI

@Observable
class VideoManager: NSObject {
    // Replace with your Vonage Video APP ID
    private let kAppId = ""
    // Replace with your generated session ID
    private let kSessionId = ""
    // Replace with your generated token
    private let kToken = ""
    
    
    @ObservationIgnored private var session: OTSession?
    @ObservationIgnored private var publisher: OTPublisher?
    @ObservationIgnored private var subscriber: OTSubscriber?
    
    var pubView: UIView?
    var subView: UIView?
    
    var isVideoEnabled: Bool = true
    var isAudioEnabled: Bool = true
    var callState: CallState = .idle
    
    var isParticipantVideoEnabled: Bool = false
    
    public func setup(enableAudio: Bool, enableVideo: Bool) {
        // FIXME: Provide checks whether camera permissions are granted and update state, hence the UI appropriately
        callState = .connecting
        
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        settings.audioTrack = enableAudio
        settings.videoTrack = enableVideo
        
        isVideoEnabled = enableVideo
        isAudioEnabled = enableAudio
        
        self.publisher = OTPublisher(delegate: self, settings: settings)
        
        connectToNewSession()
    }
    
    private func connectToNewSession() {
        session = OTSession(applicationId: kAppId, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        
        if let error {
            callState = .error(error.localizedDescription)
        }
    }
    
    func toggleVideo() {
        publisher?.publishVideo.toggle()
        isVideoEnabled = publisher?.publishVideo ?? false
    }
    
    func toggleAudio() {
        publisher?.publishAudio.toggle()
        isAudioEnabled = publisher?.publishAudio ?? false
    }
    
    func disconnect() {
        var error: OTError?
        
        guard let publisher else { return }
        // FIXME: - Double error handling this way is incorrect
        session?.unpublish(publisher, error: &error)
        
        if let error {
            callState = .error(error.localizedDescription)
        }
        
        session?.disconnect(&error)
        
        guard let error else { return }
        
        callState = .error(error.localizedDescription)
    }
    
    func backToInitialState() {
        callState = .idle
        pubView = nil
        subView = nil
    }
}
// MARK: - OTSessionDelegate callbacks
extension VideoManager: OTSessionDelegate {
    func sessionDidBeginReconnecting(_ session: OTSession) {
        callState = .reconnecting
    }
    
    
    func sessionDidReconnect(_ session: OTSession) {
        callState = .connected
    }
    
    func sessionDidConnect(_ session: OTSession) {
        callState = .connected
        
        var error: OTError?
        guard let publisher else { return }
        
        
        session.publish(publisher, error: &error)
        
        
        if let error {
            callState = .error(error.localizedDescription)
        }
        // FIXME: We should not try to update view in case error was found
        if let view = publisher.view {
            DispatchQueue.main.async {
                self.pubView = view
            }
        }
    }

    func sessionDidDisconnect(_ session: OTSession) {
        callState = .disconnected
        
        publisher = nil
        pubView = nil
    }

    func session(_ session: OTSession, didFailWithError error: OTError) {
        callState = .error("Failed to connect to the session: \(error.localizedDescription)")
    }

    func session(_ session: OTSession, streamCreated stream: OTStream) {
        var error: OTError?
        
        let subscriber = OTSubscriber(stream: stream, delegate: self)
        self.subscriber = subscriber
        
        session.subscribe(subscriber!, error: &error)
        
        isParticipantVideoEnabled = stream.hasVideo
        
        if let error {
            callState = .error(error.localizedDescription)
        }
    }

    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        subView = nil
    }
}
// MARK: - OTPublisherDelegate callbacks
extension VideoManager: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        callState = .error(error.localizedDescription)
    }
}
// MARK: - OTPublisherKitDelegate callbacks
extension VideoManager: OTPublisherKitDelegate {
    func publisherVideoDisableWarning(_ publisher: OTPublisherKit) {
        publisher.videoBitratePreset = .extraBwSaver
    }
}
// MARK: - OTSubscriberDelegate callbacks
extension VideoManager: OTSubscriberDelegate {
    // The name of parameter is subscriber, in tutorial it is subscriberKit
    func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        if let view = self.subscriber?.view {
            DispatchQueue.main.async {
                withAnimation {
                    self.subView = view
                }
            }
        }
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
    // Is it correct to use these callbacks, in order to specify whether participant's video is enabled
    func subscriberVideoDisabled(_ subscriber: OTSubscriberKit, reason: OTSubscriberVideoEventReason) {
        isParticipantVideoEnabled = false
    }
    
    func subscriberVideoEnabled(_ subscriber: OTSubscriberKit, reason: OTSubscriberVideoEventReason) {
        isParticipantVideoEnabled = true
    }
    
    func subscriberDidDisconnect(fromStream subscriber: OTSubscriberKit) {
        self.subscriber = nil
        self.isParticipantVideoEnabled = false
    }
}
