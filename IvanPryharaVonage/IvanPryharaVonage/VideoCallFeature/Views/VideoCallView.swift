//
//  ContentView.swift
//  IvanPryharaVonage
//
//  Created by Ivan Pryhara on 21/04/2026.
//

import SwiftUI

struct VideoCallView: View {
    let manager: VideoManager
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    // MARK: - Participant view
                    // The check for whether view is nil is not ideal
                    // and has room for improvement
                    if manager.subView != nil {
                        if manager.isParticipantVideoEnabled == false {
                            ParticipantPlaceholderView(baseColor: .orange)
                        } else {
                            manager.subView.flatMap { view in
                                Wrap(view: view)
                                    .cornerRadius(10)
                                    .aspectRatio(1.0, contentMode: .fit)
                            }
                        }
                    }
                    // MARK: - Your view
                    if manager.pubView != nil {
                        if manager.isVideoEnabled == false {
                            ParticipantPlaceholderView(baseColor: .gray)
                        } else {
                            manager.pubView.flatMap { view in
                                Wrap(view: view)
                                    .cornerRadius(10)
                                    .aspectRatio(1.0, contentMode: .fit)
                            }
                        }
                    }
                }
                
                Spacer()
                // MARK: - Control buttons
                HStack(spacing: 32) {
                    CircularButton(imageName: "video.fill",
                                   imageColor: manager.isVideoEnabled ? .black : .white,
                                   color: manager.isVideoEnabled ? .white : .gray.opacity(0.4)) {
                        manager.toggleVideo()
                    }
                    CircularButton(imageName: "microphone.slash.fill",
                                   imageColor: manager.isAudioEnabled ? .white : .black,
                                   color: manager.isAudioEnabled ? .gray.opacity(0.4) : .white) {
                        manager.toggleAudio()
                    }
                    CircularButton(imageName: "phone.fill",
                                   imageColor: .white,
                                   color: .red) {
                        manager.disconnect()
                    }
                }
                .frame(height: 70)
            }
            .padding(.horizontal, 16)
        }
    }
}
