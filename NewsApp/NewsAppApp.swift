//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Adrian Gabriel Chiper on 27.04.2023.
//

import SwiftUI
import Firebase

@main
struct NewsAppApp: App {
    init() {
      FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
