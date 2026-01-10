import SwiftUI

struct HomeView: View {
    @StateObject var nowPlaying = MusicManager()
    var body: some View {
        HStack(spacing: 10){
            if let image = nowPlaying.artwork {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
            }
            VStack(alignment: .leading) {
                Text(nowPlaying.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                Text(nowPlaying.artist)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                HStack(spacing: 20) {
                    Button(action: { nowPlaying.sendCommand(.previousTrack) }) {
                        Image(systemName: "backward.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }.buttonStyle(.plain)

                    Button(action: { nowPlaying.sendCommand(.togglePlayPause) })
                    {
                        Image(systemName: nowPlaying.isPlaying ?  "play.fill" : "pause.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }.buttonStyle(.plain)

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

