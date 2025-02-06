import SwiftUI

struct DrawerView: View {
    let width: CGFloat
    let isOpen: Bool
    let onClose: () -> Void
    let currentUser: UserProfile?
    let userGroups: [UserGroup]
    let selectedGroup: UserGroup?
    let selectedGroupMember: UserProfile?
    let onUserSelect: (UserProfile) -> Void
    let onGroupSelect: (UserGroup) -> Void
    let onResetSelect: () -> Void
    let onCreateGroup: () -> Void
    let onCreatePost: () -> Void
    
    @State private var expandedGroupIds: Set<Int> = []
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Color.white
                
                VStack(alignment: .leading, spacing: 24) {
                    if let currentUser = currentUser {
                        VStack(alignment: .leading, spacing: 8) {
                            Circle()
                                .fill(selectedGroup == nil && selectedGroupMember == nil ? Color.blue.opacity(0.2) : Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(selectedGroup == nil && selectedGroupMember == nil ? .blue : .gray)
                                        .font(.system(size: 30))
                                )
                            
                            Text(currentUser.name)
                                .font(.headline)
                                .foregroundColor(selectedGroup == nil && selectedGroupMember == nil ? .blue : .primary)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        .onTapGesture {
                            onResetSelect()
                            onClose()
                        }
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                onCreatePost()
                                onClose()
                            }) {
                                HStack {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 16))
                                    Text("新規投稿")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                            
                            Button(action: {
                                onCreateGroup()
                                onClose()
                            }) {
                                HStack{
                                    Image(systemName: "person.3.fill")
                                        .font(.system(size: 10))
                                    Text("団体作成")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(userGroups, id: \.id) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    Button(action: {
                                        toggleGroup(group.id)
                                    }) {
                                        HStack {
                                            if let imageURL = group.imageURL {
                                                AsyncImage(url: URL(string: imageURL)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 24, height: 24)
                                                        .clipShape(Circle())
                                                } placeholder: {
                                                    Image(systemName: "person.3.fill")
                                                        .foregroundColor(selectedGroup?.id == group.id ? .blue : .primary)
                                                        .frame(width: 24)
                                                }
                                            } else {
                                                Image(systemName: "person.3.fill")
                                                    .foregroundColor(selectedGroup?.id == group.id ? .blue : .primary)
                                                    .frame(width: 24)
                                            }
                                            
                                            Text(group.name)
                                                .foregroundColor(selectedGroup?.id == group.id ? .blue : .primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: expandedGroupIds.contains(group.id) ? "chevron.down" : "chevron.right")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                        }
                                    }
                                    .onTapGesture {
                                        onGroupSelect(group)
                                        if !expandedGroupIds.contains(group.id) {
                                            toggleGroup(group.id)
                                        }
                                        onClose()
                                    }
                                    
                                    if expandedGroupIds.contains(group.id) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            if expandedGroupIds.contains(group.id) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "key.fill")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    Text("パスワード: \(group.password)")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            Button(action: {
                                                onGroupSelect(group)
                                                onClose()
                                            }) {
                                                HStack(spacing: 12) {
                                                    Circle()
                                                        .fill(selectedGroup?.id == group.id && selectedGroupMember == nil ? Color.blue.opacity(0.2) : Color.gray.opacity(0.3))
                                                        .frame(width: 36, height: 36)
                                                        .overlay(
                                                            Image(systemName: "person.3.fill")
                                                                .foregroundColor(selectedGroup?.id == group.id && selectedGroupMember == nil ? .blue : .gray)
                                                                .font(.system(size: 18))
                                                        )
                                                    
                                                    Text("全員")
                                                        .foregroundColor(selectedGroup?.id == group.id && selectedGroupMember == nil ? .blue : .primary)
                                                }
                                            }
                                            .padding(.leading, 32)

                                            ForEach(group.users, id: \.id) { user in
                                                Button(action: {
                                                    onUserSelect(user)
                                                    onClose()
                                                }) {
                                                    HStack(spacing: 12) {
                                                        Circle()
                                                            .fill(selectedGroupMember?.id == user.id ? Color.blue.opacity(0.2) : Color.gray.opacity(0.3))
                                                            .frame(width: 36, height: 36)
                                                            .overlay(
                                                                Image(systemName: "person.fill")
                                                                    .foregroundColor(selectedGroupMember?.id == user.id ? .blue : .gray)
                                                                    .font(.system(size: 18))
                                                            )
                                                        
                                                        Text(user.name)
                                                            .foregroundColor(selectedGroupMember?.id == user.id ? .blue : .primary)
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
