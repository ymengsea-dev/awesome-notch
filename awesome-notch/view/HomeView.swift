import SwiftUI

struct HomeView: View {
    
    @StateObject var nowPlaying = MusicManager.shared
    let spacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width - spacing

            ZStack {
                // Background overlay with music artwork (behind everything)
                if let artwork = nowPlaying.artwork {
                    Image(nsImage: artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: availableWidth * 3 / 4, height: geo.size.height)
                        .blur(radius: 20)
                        .opacity(0.3)
                        .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                        .allowsHitTesting(false)
                        .zIndex(0)
                }
                
                // Content layer (in front)
                HStack(spacing: spacing) {
                    HStack(spacing: 25){
                        // music artwork
                        if let image = nowPlaying.artwork {
                            Image(nsImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .cornerRadius(12)
                                .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                        } else {
                            Image("apple_music")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                                .animation(.easeInOut(duration: 0.4), value: nowPlaying.artwork)
                        }
                        
                        // music info and controller
                        VStack(alignment: .leading) {
                            // music text
                            Text(nowPlaying.title)
                                .font(.headline)
                                .lineLimit(1)
                                .foregroundStyle(.white)
                            Text(nowPlaying.artist)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                            
                            // button controler
                            HStack(spacing: 20) {
                                Button(action: { nowPlaying.sendCommand(.previousTrack) }) {
                                    Image(systemName: "backward.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                                .buttonStyle(.plain)

                                Button(action: {
                                    nowPlaying.sendCommand(.togglePlayPause)
                                    nowPlaying.isPlaying.toggle()
                                }) {
                                    Image(systemName: nowPlaying.isPlaying ? "pause.fill" : "play.fill")
                                        .font(.title)
                                        .frame(width: 30)
                                        .foregroundStyle(.white)
                                }
                                .buttonStyle(.plain)

                                Button(action: { nowPlaying.sendCommand(.nextTrack) }) {
                                    Image(systemName: "forward.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .zIndex(1)
                }
                .frame(width: availableWidth * 3 / 4)
            }
            
            EmptyView()
                .frame(width: availableWidth * 1 / 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            nowPlaying.fetchNowPlaying()
            nowPlaying.setupNotifications()
        }
    }
}

