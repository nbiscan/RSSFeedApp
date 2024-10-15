//
//  ContentView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RSSFeedListView()
                .tabItem {
                    Label("Feeds", systemImage: "list.bullet")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            Text("Favorites")
                .navigationTitle("Favorites")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("Settings")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
