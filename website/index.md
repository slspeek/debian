<style>#forkongithub a{background:#3d9435;color:#fff;text-decoration:none;font-family:arial,sans-serif;text-align:center;font-weight:bold;padding:5px 40px;font-size:1rem;line-height:2rem;position:relative;transition:0.5s;}#forkongithub a:hover{background:#34d126;color:#fff;}#forkongithub a::before,#forkongithub a::after{content:"";width:100%;display:block;position:absolute;top:1px;left:0;height:1px;background:#fff;}#forkongithub a::after{bottom:1px;top:auto;}@media screen and (min-width:800px){#forkongithub{position:fixed;display:block;top:0;right:0;width:200px;overflow:hidden;height:200px;z-index:9999;}#forkongithub a{width:200px;position:absolute;top:60px;right:-60px;transform:rotate(45deg);-webkit-transform:rotate(45deg);-ms-transform:rotate(45deg);-moz-transform:rotate(45deg);-o-transform:rotate(45deg);box-shadow:4px 4px 10px rgba(0,0,0,0.8);}}</style><span id="forkongithub"><a href="https://github.com/slspeek/debian">Fork me on GitHub</a></span>

## Profielen

### GNOME
- [gnome.cfg](gnome.cfg) [gnome-live.tar.gz](gnome-live.tar.gz) een GNOME installatie met gebruiker 'tux'
- [gnome-personal.cfg](gnome-personal.cfg) een GNOME installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [cursus.cfg](cursus.cfg) een standaard GNOME installatie
- [tutor.cfg](tutor.cfg) een cursus schrijver GNOME installatie
- [gnome-complete.cfg](gnome-complete.cfg) [gnome-complete-live.tar.gz](gnome-complete-live.tar.gz) alles erop en eraan GNOME installatie met gebruiker 'tux'
- [gnome-complete-personal.cfg](gnome-complete-personal.cfg) alles erop en eraan GNOME installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [steven.cfg](steven.cfg) alles erop en eraan GNOME installatie met gebruiker 'steven'

### KDE
- [kde.cfg](kde.cfg) [kde-live.tar.gz](kde-live.tar.gz) een KDE installatie
- [kde-personal.cfg](kde-personal.cfg) een KDE installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [kde-complete.cfg](kde-complete.cfg) [kde-complete-live.tar.gz](kde-complete-live.tar.gz) een KDE installatie met alles erop en eraan
- [kde-complete-personal.cfg](kde-complete-personal.cfg) een KDE installatie met alles erop en eraan waarbij u de gebruiker mag definiëren tijdens de installatie

### XFCE
- [xfce.cfg](xfce.cfg) [xfce-live.tar.gz](xfce-live.tar.gz) een XFCE installatie
- [xfce-personal.cfg](xfce-personal.cfg) een XFCE installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [xfce-complete.cfg](xfce-complete.cfg) [xfce-complete-live.tar.gz](xfce-complete-live.tar.gz) een XFCE installatie met alles erop en eraan
- [xfce-complete-personal.cfg](xfce-complete-personal.cfg) een XFCE installatie met alles erop en eraan waarbij u de gebruiker mag definiëren tijdens de installatie

### Cinnamon
- [cinnamon.cfg](cinnamon.cfg) [cinnamon-live.tar.gz](cinnamon-live.tar.gz) een cinnamon installatie
- [cinnamon-personal.cfg](cinnamon-personal.cfg) een cinnamon installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [cinnamon-complete.cfg](cinnamon-complete.cfg) [cinnamon-complete-live.tar.gz](cinnamon-complete-live.tar.gz) een cinnamon installatie met alles erop en eraan
- [cinnamon-complete-personal.cfg](cinnamon-complete-personal.cfg) een cinnamon installatie met alles erop en eraan waarbij u de gebruiker mag definiëren tijdens de installatie

### MATE
- [mate.cfg](mate.cfg) [mate-live.tar.gz](mate-live.tar.gz) een MATE installatie
- [mate-personal.cfg](mate-personal.cfg) een MATE installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [mate-complete.cfg](mate-complete.cfg) [mate-complete-live.tar.gz](mate-complete-live.tar.gz) een MATE installatie met alles erop en eraan
- [mate-complete-personal.cfg](mate-complete-personal.cfg) een MATE installatie met alles erop en eraan waarbij u de gebruiker mag definiëren tijdens de installatie

### LXDE
- [lxde.cfg](lxde.cfg) [lxde-live.tar.gz](lxde-live.tar.gz) standaard LXDE installatie 
- [lxde-personal.cfg](lxde-personal.cfg) LXDE installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [lxde-complete.cfg](lxde-complete.cfg) [lxde-complete-live.tar.gz](lxde-complete-live.tar.gz) een LXDE installatie met alles erop en eraan
- [lxde-complete-personal.cfg](lxde-complete-personal.cfg) alles erop en eraan LXDE installatie waarbij u de gebruiker mag definiëren tijdens de installatie

### Multi desktop omgeving (GNOME, KDE, Mate, Cinnamon, XFCE, LXDE)
- [multi.cfg](multi.cfg) [multi-live.tar.gz](multi-live.tar.gz) standaard multi desktop installatie 
- [multi-personal.cfg](multi-personal.cfg) multi desktop installatie waarbij u de gebruiker mag definiëren tijdens de installatie
- [multi-complete.cfg](multi-complete.cfg) [multi-complete-live.tar.gz](multi-complete-live.tar.gz) een multi desktop installatie met alles erop en eraan
- [multi-complete-personal.cfg](multi-complete-personal.cfg) alles erop en eraan multi desktop installatie waarbij u de gebruiker mag definiëren tijdens de installatie

### Geen desktop
- [server.cfg](server.cfg) [server-live.tar.gz](server-live.tar.gz) een simpele server met gebruiker 'tux'
- [server-personal.cfg](server-personal.cfg) een simpele server waarbij u de gebruiker mag definiëren tijdens de installatie

## Gebruik

### Preseeds
Boot de [Debian installer](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/) via het [boot menu](https://www.boot-disk.com/quest_bootmenu.htm) en kies "Advanced options >" -> "Automated install"

Vul:

```
https://slspeek.github.io/debian/gnome-personal.cfg
```

in in het veld "Location of initial preconfiguration file".

Voor gedetaileerde instructies zie [deze presentatie handout](https://github.com/slspeek/installatie-cursus/releases/latest/download/installatie-handout.pdf) uit de [installatie cursus](https://github.com/slspeek/installatie-cursus).

### Live build

#### Installeer live-build
U installeert [live-build](https://live-team.pages.debian.net/live-manual/html/live-manual.en.html) als volgt
```
# apt-get install live-build
```
#### Gnome-complete live image bouwen
Download [gnome-complete-live.tag.gz](gnome-complete-live.tar.gz).

```
$ mkdir live
$ cd live
$ tar xvzf ~/Downloads/gnome-complete-live.tar.gz
$ cd gnome-complete-live
$ ./build.sh
$ cd build
$ lb config --mirror-bootstrap http://mirrors.xtom.nl/debian/
$ time sudo lb build
```
Als alles goed is gegaan staat er in ```build``` een bestand ```live-image-amd64.hybrid.iso```

## Scripts installeren

### Op een niet gepreseede machine
```
curl https://slspeek.github.io/debian/scripts.tar.gz | sudo tar xvz -C /usr/local/bin
```
### Op een gepreseede machine
```
sudo update-scripts.sh
```



