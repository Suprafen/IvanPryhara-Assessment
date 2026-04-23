//
//  StartScreen.swift
//  IvanPryharaVonage
//
//  Created by Ivan Pryhara on 23/04/2026.
//

import SwiftUI

struct StartScreen: View {
    @State private var manager = VideoManager()
    @State private var isSheetPresented: Bool = false
    
    @State private var enableAudio: Bool = true
    @State private var enableVideo: Bool = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Group {
                // UI responds to different states
                // that are changed within manager's implementation
                switch manager.callState {
                case .idle:
                    VStack(spacing: 16) {
                        VStack {
                            Toggle(isOn: $enableAudio, label: { Text("Audio") })
                            Toggle(isOn: $enableVideo, label: { Text("Video") })
                        }
                        .foregroundStyle(.white)
                        
                        Button("Start a call") {
                            manager.setup(enableAudio: enableAudio,
                                          enableVideo: enableVideo)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                case .reconnecting:
                    ProgressView("Reconnecting to Session...")
                        .tint(.white)
                        .foregroundStyle(.white)
                case .connecting:
                    ProgressView("Connecting to Session...")
                        .tint(.white)
                        .foregroundStyle(.white)
                case .connected:
                    VideoCallView(manager: manager)
                case .disconnected:
                    VStack {
                        Text("Call ended")
                            .foregroundStyle(.white)
                        Button("Finalize state") {
                            manager.backToInitialState()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                case .error(let string):
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        Text(string)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            manager.setup(enableAudio: enableAudio,
                                          enableVideo: enableVideo)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Terminate session") {
                            manager.backToInitialState()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        .padding()
                    }
                }
            }.padding(.horizontal, 16)
        }
    }
}
