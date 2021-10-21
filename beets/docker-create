docker create \
    --name=beets \
    -v /Users/ifor/.dotfiles/beets:/config \
    -v /Users/ifor/Music/local:/music \
    -v /Users/ifor/Music/downloads:/downloads \
    -e PGID=1000 -e PUID=1000  \
    -p 8337:8337 \
    linuxserver/beets

    # -v /etc/localtime:/etc/localtime:ro \
