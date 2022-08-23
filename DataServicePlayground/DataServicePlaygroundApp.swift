//
//  DataServicePlaygroundApp.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 12.08.2022..
//

import SwiftUI

@main
struct DataServicePlaygroundApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HTTPBinView()
                    .tabItem {
                        Image(systemName: "icloud.and.arrow.up")
                        Text("HTTPBin")
                    }
                
                GeonamesView()
                    .tabItem {
                        Image(systemName: "globe")
                        Text("Geonames")
                    }
            }
            .preferredColorScheme(.light)
        }
    }
}
