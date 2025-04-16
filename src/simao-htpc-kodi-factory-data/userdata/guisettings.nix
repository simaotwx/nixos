{ config, ... }: ''
    <settings version="2">
        <setting id="lookandfeel.skin" default="true">skin.estuary</setting>
        <setting id="lookandfeel.skintheme" default="true">SKINDEFAULT</setting>
        <setting id="lookandfeel.skincolors">midnight</setting>
        <setting id="lookandfeel.font" default="true">Default</setting>
        <setting id="lookandfeel.skinzoom" default="true">0</setting>
        <setting id="lookandfeel.stereostrength" default="true">5</setting>
        <setting id="lookandfeel.enablerssfeeds" default="true">false</setting>
        <setting id="locale.language" default="true">resource.language.en_gb</setting>
        <setting id="locale.charset" default="true">DEFAULT</setting>
        <setting id="locale.keyboardlayouts">German QWERTZ</setting>
        <setting id="locale.activekeyboardlayout" default="true">German QWERTZ</setting>
        <setting id="locale.country">Central Europe</setting>
        <setting id="locale.timezonecountry" default="true">Germany</setting>
        <setting id="locale.timezone" default="true">${config.customization.general.timeZone}</setting>
        <setting id="locale.shortdateformat">DD.MM.YYYY</setting>
        <setting id="locale.longdateformat" default="true">regional</setting>
        <setting id="locale.timeformat">HH:mm:ss</setting>
        <setting id="locale.use24hourclock" default="true">regional</setting>
        <setting id="locale.temperatureunit" default="true">regional</setting>
        <setting id="locale.speedunit" default="true">regional</setting>
        <setting id="screensaver.mode" default="true">screensaver.xbmc.builtin.dim</setting>
        <setting id="screensaver.time">5</setting>
        <setting id="screensaver.disableforaudio" default="true">true</setting>
        <setting id="screensaver.usedimonpause" default="true">true</setting>
        <setting id="lookandfeel.startupaction" default="true">0</setting>
        <setting id="lookandfeel.startupwindow" default="true">10000</setting>
        <setting id="videolibrary.updateonstartup">true</setting>
        <setting id="videolibrary.backgroundupdate" default="true">false</setting>
        <setting id="musiclibrary.updateonstartup">true</setting>
        <setting id="musiclibrary.backgroundupdate" default="true">false</setting>
        <setting id="myvideos.flatten" default="true">false</setting>
        <setting id="myvideos.extractthumb" default="true">true</setting>
        <setting id="videoplayer.autoplaynextitem" default="true" />
        <setting id="videoplayer.seeksteps" default="true">-600,-300,-180,-60,-30,-10,-5,5,10,30,60,180,300,600</setting>
        <setting id="videoplayer.seekdelay" default="true">750</setting>
        <setting id="videoplayer.adjustrefreshrate">2</setting>
        <setting id="winsystem.ishdrdisplay" default="true">true</setting>
        <setting id="musicplayer.autoplaynextitem" default="true">true</setting>
        <setting id="musicplayer.queuebydefault" default="true">true</setting>
        <setting id="musicplayer.seeksteps" default="true">-60,-30,-10,10,30,60</setting>
        <setting id="locale.audiolanguage">German</setting>
        <setting id="services.devicename">${config.customization.general.hostName}</setting>
        <setting id="services.zeroconf" default="true">true</setting>
        <setting id="services.deviceuuid">${config.customization.kodi.settings.deviceUuid}</setting>
        <setting id="services.webserver">${toString config.customization.kodi.settings.webserver.enable}</setting>
        <setting id="services.webserverport">8081</setting>
        <setting id="services.webserverauthentication" default="true">true</setting>
        <setting id="services.webserverusername" default="true">${config.customization.kodi.settings.webserver.username}</setting>
        <setting id="services.webserverpassword">${config.customization.kodi.settings.webserver.password}</setting>
        <setting id="services.webserverssl" default="true">false</setting>
        <setting id="services.webskin" default="true">webinterface.default</setting>
        <setting id="services.esenabled" default="true">true</setting>
        <setting id="services.esport" default="true">9777</setting>
        <setting id="services.esportrange" default="true">10</setting>
        <setting id="services.esmaxclients" default="true">20</setting>
        <setting id="services.esallinterfaces">true</setting>
        <setting id="services.esinitialdelay" default="true">750</setting>
        <setting id="services.escontinuousdelay" default="true">25</setting>
        <setting id="services.upnp">true</setting>
        <setting id="services.upnpserver" default="true">false</setting>
        <setting id="services.upnpannounce" default="true">true</setting>
        <setting id="services.upnplookforexternalsubtitles" default="true">false</setting>
        <setting id="services.upnpcontroller" default="true">false</setting>
        <setting id="services.upnpplayervolumesync" default="true">true</setting>
        <setting id="services.upnprenderer" default="true">false</setting>
        <setting id="services.airplay" default="true">true</setting>
        <setting id="services.airplayvolumecontrol">false</setting>
        <setting id="services.airplayvideosupport" default="true">false</setting>
        <setting id="services.useairplaypassword" default="true">false</setting>
        <setting id="services.airplaypassword" default="true" />
        <setting id="services.wsdiscovery">false</setting>
        <setting id="filecache.buffermode" default="true">4</setting>
        <setting id="filecache.memorysize">512</setting>
        <setting id="filecache.readfactor">0</setting>
        <setting id="filecache.chunksize">262144</setting>
        <setting id="general.addonupdates">0</setting>
        <setting id="general.addonnotifications" default="true">false</setting>
        <setting id="addons.updatemode" default="true">0</setting>
        <setting id="cache.harddisk" default="true">256</setting>
        <setting id="cachevideo.lan" default="true">2048</setting>
        <setting id="cachevideo.internet" default="true">4096</setting>
        <setting id="cacheaudio.lan" default="true">256</setting>
        <setting id="cacheaudio.internet" default="true">256</setting>
        <setting id="cacheunknown.internet" default="true">4096</setting>
        <setting id="weather.addon" default="true">false</setting>
    </settings>
''