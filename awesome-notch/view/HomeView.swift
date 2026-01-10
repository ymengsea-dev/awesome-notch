import SwiftUI

struct HomeView: View {
    
    @StateObject var nowPlaying = MusicManager.shared
    
    var body: some View {
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
                    }.buttonStyle(.plain)

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
                    }.buttonStyle(.plain)
                }
            }
            
        }
        .onAppear {
            nowPlaying.fetchNowPlaying()
            nowPlaying.setupNotifications()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom)
    }
}

