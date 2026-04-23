//
//  CallState.swift
//  IvanPryharaVonage
//
//  Created by Ivan Pryhara on 23/04/2026.
//

enum CallState {
    case idle
    case connecting
    case connected
    case reconnecting
    case disconnected
    case error(String)
}

