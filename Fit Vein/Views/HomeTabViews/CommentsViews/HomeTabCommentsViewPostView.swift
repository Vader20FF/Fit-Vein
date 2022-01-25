//
//  HomeTabCommentsViewPostView.swift
//  Fit Vein
//
//  Created by Łukasz Janiszewski on 13/01/2022.
//

import SwiftUI

struct HomeTabCommentsViewPostView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        let screenWidth = UIScreen.screenWidth
        let screenHeight = UIScreen.screenHeight
        
        VStack {
            Text(post.text)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .padding(.top)
            
            if let post = self.homeViewModel.getCurrentPostDetails(postID: post.id) {
                if let postPhotoURL = post.photoURL {
                    Group {
                        if let postPictureURL = self.homeViewModel.postsPicturesURLs[post.id] {
                            AsyncImage(url: postPictureURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                    }
//                    .padding(.vertical)
//                    .frame(width: screenWidth * 0.53, height: screenHeight * 0.55)
//                    .padding(.bottom, screenHeight * 0.05)
                }
            }

            HStack {
                if post.reactionsUsersIDs != nil {
                    if post.reactionsUsersIDs!.count != 0 {
                        Image(systemName: post.reactionsUsersIDs!.contains(self.profileViewModel.profile!.id) ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(.accentColor)
                            .padding(.leading, screenWidth * 0.05)

                        Text("\(post.reactionsUsersIDs!.count)")
                            .foregroundColor(Color(uiColor: .systemGray2))
                    }

                }

                Spacer()

                if let postComments = homeViewModel.postsComments[post.id] {
                    Text("\(postComments.count) \(String(localized: "CommentView_comment_number_label"))")
                        .foregroundColor(Color(uiColor: .systemGray2))
                        .padding(.trailing, screenWidth * 0.05)
                }
            }
            .padding(.top, screenHeight * 0.02)

            HStack {
                Spacer()

                if let reactionsUsersIDs = profileViewModel.profile!.reactedPostsIDs {
                    Button(action: {
                        withAnimation {
                            if reactionsUsersIDs.contains(post.id) {
                                self.homeViewModel.removeReactionFromPost(postID: post.id)  { success in }
                            } else {
                                self.homeViewModel.reactToPost(postID: post.id)  { success in }
                            }
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .symbolVariant(reactionsUsersIDs.contains(post.id) ? .fill : .none)
                            Text(String(localized: "CommentView_post_like_button"))
                        }
                        .foregroundColor(reactionsUsersIDs.contains(post.id) ? .accentColor : (colorScheme == .dark ? .white : .black))
                    })
                } else {
                    Button(action: {
                        withAnimation {
                            self.homeViewModel.reactToPost(postID: post.id)  { success in }
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                            Text(String(localized: "CommentView_post_like_button"))
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    })
                }

                Spacer()
            }
            .padding(screenHeight * 0.014)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            
            Divider()
        }
    }
}

struct HomeTabCommentsViewPostView_Previews: PreviewProvider {
    static var previews: some View {
        let homeViewModel = HomeViewModel(forPreviews: true)
        let profileViewModel = ProfileViewModel(forPreviews: true)
        let comments = [Comment(id: "id1", authorID: "1", postID: "1", authorFirstName: "Maciej", authorUsername: "maciej.j223", authorProfilePictureURL: "nil", addDate: Date(), text: "Good job!", reactionsUsersIDs: ["2", "3"]), Comment(id: "id2", authorID: "3", postID: "1", authorFirstName: "Kamil", authorUsername: "kamil.j223", authorProfilePictureURL: "nil", addDate: Date(), text: "Let's Go!", reactionsUsersIDs: ["1", "3"])]
        let post = Post(id: "1", authorID: "1", authorFirstName: "Jan", authorUsername: "jan23.d", authorProfilePictureURL: "", addDate: Date(), text: "Did this today!", reactionsUsersIDs: nil, commentedUsersIDs: nil, comments: comments)

        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ForEach(["iPhone XS MAX", "iPhone 8"], id: \.self) { deviceName in
                NavigationView {
                    HomeTabCommentsViewPostView(post: post)
                        .environmentObject(homeViewModel)
                        .environmentObject(profileViewModel)
                        .preferredColorScheme(colorScheme)
                        .previewDevice(PreviewDevice(rawValue: deviceName))
                        .previewDisplayName(deviceName)
                }
            }
        }
    }
}
