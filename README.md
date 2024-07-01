# prolapse 👅
cmd tool for making timelapses in Linux/Bsd, supports wayland + X11 
(tested on Void Linux + FreeBSD)

# Install & Dependencies
**must** have *bash*, *scrot/grim* and *ffmpeg*

Replace *scrot* with *grim* if you're using Wayland.
| OS | Command |
|-|-|
| Arch: | `# pacman -S bash scrot ffmpeg` |
| Fedora: | `# dnf install bash scrot ffmpeg` |
| Debian/Ubuntu | `# apt install bash scrot ffmpeg` |
| FreeBSD | `# pkg install bash scrot ffmpeg` |
| OpenBSD | `# pkg_add bash scrot ffmpeg` |

after that just download the script, then run it
```
$ chmod +x prolapse.sh
$ bash prolapse.sh -h
```

