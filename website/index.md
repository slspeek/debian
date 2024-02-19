<style>#forkongithub a{background:#3d9435;color:#fff;text-decoration:none;font-family:arial,sans-serif;text-align:center;font-weight:bold;padding:5px 40px;font-size:1rem;line-height:2rem;position:relative;transition:0.5s;}#forkongithub a:hover{background:#34d126;color:#fff;}#forkongithub a::before,#forkongithub a::after{content:"";width:100%;display:block;position:absolute;top:1px;left:0;height:1px;background:#fff;}#forkongithub a::after{bottom:1px;top:auto;}@media screen and (min-width:800px){#forkongithub{position:fixed;display:block;top:0;right:0;width:200px;overflow:hidden;height:200px;z-index:9999;}#forkongithub a{width:200px;position:absolute;top:60px;right:-60px;transform:rotate(45deg);-webkit-transform:rotate(45deg);-ms-transform:rotate(45deg);-moz-transform:rotate(45deg);-o-transform:rotate(45deg);box-shadow:4px 4px 10px rgba(0,0,0,0.8);}}</style><span id="forkongithub"><a href="https://github.com/slspeek/debian">Fork me on GitHub</a></span>

- [gnome.cfg](gnome.cfg) een standaard GNOME installatie
- [cursus.cfg](cursus.cfg) een vanilla GNOME installatie
- [tutor.cfg](tutor.cfg) een cursus schrijver GNOME installatie
- [server.cfg](server.cfg) een simpele server
- [complete.cfg](complete.cfg) alles erop en eraan GNOME installatie met gebruiker 'tux'
- [personal.cfg](personal.cfg) alles erop en eraan GNOME installatie waarbij u de gebruiker mag definieren tijdens de installatie
- [steven.cfg](steven.cfg) alles erop en eraan GNOME installatie met gebruiker 'steven' en de muis links
- [scripts.tar.gz](scripts.tar.gz) alle scripts los te downloaden

# Gebruik
Boot de Debian installer en kies "Advanced options >" -> "Automated install"

Vul:

```
https://slspeek.github.io/debian/personal.cfg
```

in in het veld "Location of initial preconfiguration file"