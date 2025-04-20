//
//  PostAnnotation.swift
//  TravelCounter
//
//  Created by 仲野将馬 on 2025/02/05.
//

import SwiftUI

struct PostAnnotation: View {
    let post: Post
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 36, height: 36)
                .shadow(radius: 2)
            
            if let image = UIImage(named: post.image) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.blue)
                    .imageScale(.medium)
            }
        }
    }
}
