import SwiftUI

struct DrawerView: View {
    let width: CGFloat
    let isOpen: Bool
    let onClose: () -> Void
    let currentUser: UserProfile?
    let userGroups: [UserGroup]
    let onUserSelect: (UserProfile) -> Void
    
    @State private var expandedGroupIds: Set<Int> = []
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Color.white
                
                VStack(alignment: .leading, spacing: 24) {
                    if let currentUser = currentUser {
                        VStack(alignment: .leading, spacing: 8) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 30))
                                )
                            
                            Text(currentUser.name)
                                .font(.headline)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    }
                    
                    Text("表示データの切り替え")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(userGroups, id: \.id) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    Button(action: {
                                        toggleGroup(group.id)
                                    }) {
                                        HStack {
                                            Image(systemName: group.iconName)
                                                .foregroundColor(.primary)
                                                .frame(width: 24)
                                            
                                            Text(group.name)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: expandedGroupIds.contains(group.id) ? "chevron.down" : "chevron.right")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    
                                    if expandedGroupIds.contains(group.id) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            ForEach(group.users, id: \.id) { user in
                                                Button(action: {
                                                    onUserSelect(user)
                                                    onClose()
                                                }) {
                                                    HStack(spacing: 12) {
                                                        Circle()
                                                            .fill(Color.gray.opacity(0.3))
                                                            .frame(width: 36, height: 36)
                                                            .overlay(
                                                                Image(systemName: "person.fill")
                                                                    .foregroundColor(.gray)
                                                                    .font(.system(size: 18))
                                                            )
                                                        
                                                        Text(user.name)
                                                            .foregroundColor(.primary)
                                                    }
                                                }
                                                .padding(.leading, 32)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
            }
            .frame(width: width)
            .offset(x: isOpen ? 0 : -width)
            .animation(.easeInOut(duration: 0.3), value: isOpen)
            
            if isOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onClose()
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isOpen)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func toggleGroup(_ groupId: Int) {
        if expandedGroupIds.contains(groupId) {
            expandedGroupIds.remove(groupId)
        } else {
            expandedGroupIds.insert(groupId)
        }
    }
} 