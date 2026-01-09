import SwiftUI

struct HomeView: View {
    
    @ObservedObject var music = MusicManager.shared
    
    var body: some View {
        Text("Home view")
            .foregroundStyle(.white)
        HStack{
            if let artwork = music.artwork {
                Image(nsImage: artwork)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            VStack(alignment: .leading, spacing: 2){
                Text(music.title)
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
                    .foregroundStyle(.white)
                Text(music.artist)
                    .font(.system(size: 9))
                    .lineLimit(1)
                    .foregroundStyle(.gray.opacity(0.7))
            }
            Spacer()
        }
    }
}

