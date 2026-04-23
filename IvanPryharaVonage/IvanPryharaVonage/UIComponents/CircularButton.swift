//
//  CircularButton.swift
//  IvanPryharaVonage
//
//  Created by Ivan Pryhara on 23/04/2026.
//

import SwiftUI

struct CircularButton: View {
    let imageName: String
    let imageColor: Color
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(imageColor)
        }
        .buttonStyle(CircularButtonStyle(color: color))
    }
}

fileprivate struct CircularButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 60)
            .background(color)
            .clipShape(Circle())
            .overlay(Circle().fill(.black).opacity(configuration.isPressed ? 0.3 : 0.0))
    }
}
