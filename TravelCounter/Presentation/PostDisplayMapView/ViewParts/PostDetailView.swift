//
//  PostDetailView.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    let onDismiss: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ハンドル部分
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 4)
                .cornerRadius(2)
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    onDismiss()
                }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(post.userName)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    if let image = UIImage(named: post.image) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 180)
                            .cornerRadius(8)
                    }
                    
                    Text(post.comment)
                        .font(.body)
                        .padding(.vertical, 4)
                    
                    Text(dateFormatter.string(from: post.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 16)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.4)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(radius: 8)
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .updating($isDragging) { value, state, _ in
                    state = true
                }
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        onDismiss()
                    }
                    withAnimation(.spring()) {
                        dragOffset = 0
                    }
                }
        )
    }
}
