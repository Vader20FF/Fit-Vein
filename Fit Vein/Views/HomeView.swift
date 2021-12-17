//
//  HomeView.swift
//  Fit Vein
//
//  Created by Łukasz Janiszewski on 20/10/2021.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject private var homeViewModel: HomeViewModel
    @ObservedObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showPostOptions = false
    @State private var showEditView = false
    @State private var showAddView = false
    
    init(homeViewModel: HomeViewModel, profileViewModel: ProfileViewModel) {
        self.homeViewModel = homeViewModel
        self.profileViewModel = profileViewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            if showEditView {
                EditPostView()
            } else {
                if profileViewModel.profile != nil {
                    withAnimation {
                        NavigationView {
                            ScrollView(.vertical) {
                                VStack {
                                    VStack {
                                        HStack {
                                            if let profilePicturePhotoURL = profileViewModel.profilePicturePhotoURL {
                                                AsyncImage(url: profilePicturePhotoURL) { phase in
                                                    if let image = phase.image {
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                                            .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
                                                    } else {
                                                        Image(uiImage: UIImage(named: "blank-profile-hi")!)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                                            .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
                                                    }
                                                }
                                            } else {
                                                Image(uiImage: UIImage(named: "blank-profile-hi")!)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                                    .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
                                            }
                                            
                                            Text("What do you want to share?")
                                                .frame(width: screenWidth * 0.6, height: screenHeight * 0.1)
                                        }
                                        .padding(.leading, screenWidth * 0.05)
                                        .onTapGesture {
                                            withAnimation {
                                                self.showAddView = true
                                            }
                                        }
                                        
                                        Divider()
                                        
                                        HStack(spacing: 0) {
                                            
                                        }
                                        
                                        Divider()
                                        
                                        Spacer(minLength: screenHeight * 0.05)
                                        
                                        HStack {
                                            Text("Your friends activity")
                                                .foregroundColor(.green)
                                                .font(.system(size: screenHeight * 0.04, weight: .bold))
                                                .background(Rectangle().foregroundColor(Color(uiColor: .systemGray6)).frame(width: screenWidth, height: screenHeight * 0.08))
                                        }
                                        .padding()
                                        
                                        if let posts = homeViewModel.posts {
                                            ForEach(posts) { post in
                                                VStack {
                                                    Rectangle()
                                                        .foregroundColor(Color(uiColor: .systemGray6))
                                                        .frame(width: screenWidth, height: screenHeight * 0.02)
                                                        .confirmationDialog("What do you want to do with the selected post?", isPresented: $showPostOptions) {
                                                            Button("Edit") {
                                                                self.showEditView = true
                                                            }
                                                            Button("Delete", role: .destructive) {
                                                                self.homeViewModel.deletePost(postID: post.id)
                                                            }
                                                            Button("Cancel", role: .cancel) {}
                                                        }
                                                    
                                                    HStack {
                                                        Spacer()
    //                                                    This causes an error
    //                                                    if let postAuthorProfilePictureURL = homeViewModel.postsAuthorsProfilePicturesURLs[post.id] {
    //                                                        AsyncImage(url: postAuthorProfilePictureURL) { phase in
    //                                                            if let image = phase.image {
    //                                                                image
    //                                                                    .resizable()
    //                                                                    .aspectRatio(contentMode: .fit)
    //                                                                    .clipShape(RoundedRectangle(cornerRadius: 50))
    //                                                                    .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
    //                                                            } else {
    //                                                                Image(uiImage: UIImage(named: "blank-profile-hi")!)
    //                                                                    .resizable()
    //                                                                    .aspectRatio(contentMode: .fit)
    //                                                                    .clipShape(RoundedRectangle(cornerRadius: 50))
    //                                                                    .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
    //                                                            }
    //                                                        }
    //                                                    } else {
    //                                                        Image(uiImage: UIImage(named: "blank-profile-hi")!)
    //                                                            .resizable()
    //                                                            .aspectRatio(contentMode: .fit)
    //                                                            .clipShape(RoundedRectangle(cornerRadius: 50))
    //                                                            .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
    //                                                    }
    //                                                    This causes an error
                                                        
                                                        Image(uiImage: UIImage(named: "blank-profile-hi")!)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .clipShape(RoundedRectangle(cornerRadius: 50))
                                                            .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
                                                            .padding(.leading, screenWidth * 0.05)
                                                        
                                                        VStack {
                                                            HStack {
                                                                Text(post.authorFirstName)
                                                                    .fontWeight(.bold)
                                                                Text("•")
                                                                Text(post.authorUsername)
                                                                Spacer()
                                                                
                                                                if profileViewModel.profile != nil {
                                                                    if profileViewModel.profile!.id == post.authorID {
                                                                        Button(action: {
                                                                            self.showPostOptions = true
                                                                        }, label: {
                                                                            Image(systemName: "gearshape")
                                                                                .foregroundColor(.green)
                                                                                .padding(.trailing, screenWidth * 0.05)
                                                                        })
                                                                            
                                                                    }
                                                                }
                                                            }
                                                            .padding(.bottom, screenHeight * 0.001)
                                                            
                                                            HStack {
                                                                Text(getShortDate(longDate: post.addDate))
                                                                    .foregroundColor(Color(uiColor: .systemGray2))
                                                                Spacer()
                                                            }
                                                        }
                                                    }
                                                    
                                                    Text(post.text)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    
                                                    Spacer()
                                                    
                                                    HStack {
                                                        if post.reactionsUsersIDs != nil {
                                                            if post.reactionsUsersIDs!.count != 0 {
                                                                Image(systemName: "hand.thumbsup.fill")
                                                                    .foregroundColor(.green)
                                                                    .padding(.leading, screenWidth * 0.05)
                                                                
                                                                Text("\(post.reactionsUsersIDs!.count)")
                                                                    .foregroundColor(Color(uiColor: .systemGray5))
                                                            }
                                                            
                                                        }

                                                        Spacer()
                                                        
                                                        if post.comments != nil {
                                                            if post.comments!.count != 0 {
                                                                Text("\(post.comments!.count) comments")
                                                                    .padding(.trailing, screenWidth * 0.05)
                                                                    .foregroundColor(Color(uiColor: .systemGray5))
                                                            }
                                                        }
                                                    }
                                                    
                                                    Divider()
                                                    
                                                    HStack(spacing: 0) {
                                                        Button(action: {
                                                            self.homeViewModel.reactToPost(postID: post.id)
                                                        }, label: {
                                                            HStack {
                                                                Image(systemName: "hand.thumbsup")
                                                                Text("Like")
                                                            }
                                                        })
                                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                                            .frame(width: screenWidth * 0.5, height: screenHeight * 0.04)
                                                        
                                                        Divider()
                                                        
                                                        Button(action: {
                                                            // Comment Functionality
                                                        }, label: {
                                                            HStack {
                                                                Image(systemName: "bubble.left")
                                                                Text("Comment")
                                                            }
                                                        })
                                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                                            .frame(width: screenWidth * 0.5, height: screenHeight * 0.04)
                                                    }
                                                    
                                                    Divider()
                                                }
                                            }
                                        } else {
                                            if self.profileViewModel.profile!.followedIDs != nil {
                                                if self.profileViewModel.profile!.followedIDs!.count != 0 {
                                                    
                                                } else {
                                                    Text("Add friends to see their achievements")
                                                        .foregroundColor(.green)
                                                }
                                            } else {
                                                Text("Add friends to see their achievements")
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    }
                                }
                            }
                            .navigationTitle("")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Image(uiImage: UIImage(named: colorScheme == .dark ? "FitVeinIconDark" : "FitVeinIconLight")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screenWidth * 0.15, height: screenHeight * 0.15)
                                }
                                
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    NavigationLink(destination: SearchFriendsView(homeViewModel: homeViewModel, profileViewModel: profileViewModel).environmentObject(sessionStore)) {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    NavigationLink(destination: NotificationsView()) {
                                        Image(systemName: "bell")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                        .sheet(isPresented: self.$showAddView) {
                            AddPostView(homeViewModel: homeViewModel, profileViewModel: profileViewModel).environmentObject(sessionStore)
                        }
                    }
                } else {
                    withAnimation {
                        HomeTabFetchingView()
                            .onAppear() {
//                                self.homeViewModel.setup(sessionStore: sessionStore)
//                                self.homeViewModel.fetchData()
//                                self.profileViewModel.setup(sessionStore: sessionStore)
//                                self.profileViewModel.fetchData()
                            }
                    }
                }
            }
            
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let homeViewModel = HomeViewModel(forPreviews: true)
        let profileViewModel = ProfileViewModel(forPreviews: true)
        let sessionStore = SessionStore(forPreviews: true)

        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone XS MAX", "iPhone 8"], id: \.self) { deviceName in
                HomeView(homeViewModel: homeViewModel, profileViewModel: profileViewModel)
                    .preferredColorScheme(colorScheme)
                    .previewDevice(PreviewDevice(rawValue: deviceName))
                    .previewDisplayName(deviceName)
                    .environmentObject(sessionStore)
            }
        }
    }
}
