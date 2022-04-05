# docker-dosbox

Run [DOSBox](https://www.dosbox.com/) in a docker container. I run it on my NAS.

1. Add your game archives into the current working directory and find out via which command your game is being launched (this will be one of the `exe` or `bat` files in the zip file).
2. Copy the file `/etc/zypp/credentials.d/SCCcredentials` from a registered SLES machine into the current working directory.
3. Run `buildah bud --layers -t dosbox --secret=id=SCCcredentials,src=SCCcredentials --build-arg GAME_ZIP=$YOUR_DOSBOX_ZIP --build-arg LAUNCH_CMD="$YOUR_GAMES_LAUNCH_COMMAND" .`, where you replace `$YOUR_DOSBOX_ZIP` with the filename of the zipfile containing your game and `$YOUR_GAMES_LAUNCH_COMMAND` with the command that will launch your game.
4. Start with `podman run -p 8080:8080 dosbox`
5. Connect with a browser to your docker host e.g. http://localhost:8080
