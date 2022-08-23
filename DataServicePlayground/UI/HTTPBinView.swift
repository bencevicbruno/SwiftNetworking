//
//  HTTPBinView.swift
//  DataServicePlayground
//
//  Created by Bruno Benčević on 23.08.2022..
//

import SwiftUI

struct HTTPBinView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("avatar")
                .resizable()
                .scaledToFit()
                .padding(50)
            
            Spacer()
            
            Button("Upload") {
                Task {
                    await uploadPicture()
                }
            }
            .padding()
            .buttonStyle(.borderless)
        }
    }
    
    @MainActor
    func uploadPicture() async {
        guard let dataToUpload = UploadableData(UIImage(named: "avatar")!, format: .png) else { return }
        let service = NetworkService(configuration: .init(baseURL: "https://httpbin.org", sessionName: "HTTPBin"))
        let resource = NetworkResource("/post", method: .POST, uploadableData: dataToUpload)
        
        do {
            let response: String = try await service.fetch(resource)
            print(response)
        } catch(let error) {
            print(error)
        }
    }
}

struct HTTPBinView_Previews: PreviewProvider {
    static var previews: some View {
        HTTPBinView()
    }
}
