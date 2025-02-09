import SwiftUI

struct JoinGroupView: View {
    @StateObject private var viewModel = JoinGroupViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.foundGroup != nil {
                    // グループが見つかった場合の表示
                    VStack(spacing: 16) {
                        if let icon = viewModel.foundGroup?.icon {
                            AsyncImage(url: URL(string: icon)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text(viewModel.foundGroup?.name ?? "")
                            .font(.title2)
                            .bold()
                        
                        SecureField("パスワード", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.joinGroup()
                        }) {
                            Text("参加する")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .disabled(viewModel.isJoining)
                    }
                    .padding()
                } else {
                    // グループ検索フォーム
                    VStack(spacing: 16) {
                        TextField("グループID", text: $viewModel.groupId)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        Button(action: {
                            viewModel.searchGroup()
                        }) {
                            Text("検索")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isSearching)
                    }
                    .padding()
                }
                
                if viewModel.isSearching || viewModel.isJoining {
                    ProgressView()
                }
            }
            .navigationTitle("グループに参加")
            .navigationBarTitleDisplayMode(.inline)
            .alert("エラー", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
} 