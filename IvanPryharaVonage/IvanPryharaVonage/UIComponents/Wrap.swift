//
//  Wrap.swift
//  IvanPryharaVonage
//
//  Created by Ivan Pryhara on 23/04/2026.
//

import SwiftUI

struct Wrap: UIViewRepresentable {
    @State var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            self.view = uiView
        }
    }
}
