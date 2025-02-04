//
//  PostAnnotation.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
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
            
            Image(systemName: "photo")
                .foregroundColor(.blue)
                .imageScale(.medium)
        }
    }
}
