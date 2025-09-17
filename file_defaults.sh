#!/bin/bash
# file_defaults.sh
# set VLC as default app for common audio + video formats

# audio
duti -s org.videolan.vlc .mp3 all
duti -s org.videolan.vlc .wav all
duti -s org.videolan.vlc .flac all
duti -s org.videolan.vlc .m4a all
duti -s org.videolan.vlc .aac all
duti -s org.videolan.vlc .ogg all

# video
duti -s org.videolan.vlc .mp4 all
duti -s org.videolan.vlc .mkv all
duti -s org.videolan.vlc .mov all
duti -s org.videolan.vlc .avi all
duti -s org.videolan.vlc .wmv all
duti -s org.videolan.vlc .flv all
duti -s org.videolan.vlc .webm all

# playlists
duti -s org.videolan.vlc .m3u all
duti -s org.videolan.vlc .pls all

echo "✅ VLC set as default for common audio/video formats."
