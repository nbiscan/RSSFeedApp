//
//  View+isLoading.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 16.10.2024..
//

import SwiftUI

extension View {
    func isLoading(_ isLoading: Bool) -> some View {
        overlay {
            if isLoading {
                ProgressView()
                    .padding(36)
                    .controlSize(.large)
                    .background(Material.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .allowsHitTesting(!isLoading)
        .animation(.easeInOut.speed(2), value: isLoading)
    }
}
