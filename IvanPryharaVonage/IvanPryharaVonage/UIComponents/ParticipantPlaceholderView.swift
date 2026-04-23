//
//  ParticipantPlaceholderView.swift
//  IvanPryharaVonage
//
//  Created by Ivan Pryhara on 23/04/2026.
//

import SwiftUI

struct ParticipantPlaceholderView: View {
    let baseColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(baseColor.opacity(0.4))
            Image(systemName: "person.fill")
                .resizable()
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .padding()
                .background {
                    Circle()
                        .foregroundStyle(baseColor.opacity(0.2))
                }
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}
