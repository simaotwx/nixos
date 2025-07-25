{ config, lib, ... }:
''
  <settings version="2">
      <setting id="gamesgeneral.enable" default="true">true</setting>
      <setting id="gamesgeneral.showosdhelp" default="true">true</setting>
      <setting id="gamesgeneral.enableautosave" default="true">true</setting>
      <setting id="gamesgeneral.enablerewind" default="true">true</setting>
      <setting id="gamesgeneral.rewindtime" default="true">60</setting>
      <setting id="gamesachievements.username" default="true" />
      <setting id="gamesachievements.password" default="true" />
      <setting id="gamesachievements.token" default="true" />
      <setting id="gamesachievements.loggedin" default="true">false</setting>
      <setting id="lookandfeel.skin" default="true">skin.estuary</setting>
      <setting id="lookandfeel.skintheme" default="true">SKINDEFAULT</setting>
      <setting id="lookandfeel.skincolors">midnight</setting>
      <setting id="lookandfeel.font" default="true">Default</setting>
      <setting id="lookandfeel.skinzoom" default="true">0</setting>
      <setting id="lookandfeel.stereostrength" default="true">5</setting>
      <setting id="lookandfeel.enablerssfeeds" default="true">false</setting>
      <setting id="lookandfeel.rssedit" default="true" />
      <setting id="locale.language" default="true">resource.language.en_gb</setting>
      <setting id="locale.charset" default="true">DEFAULT</setting>
      <setting id="locale.keyboardlayouts">German QWERTZ</setting>
      <setting id="locale.activekeyboardlayout" default="true">German QWERTZ</setting>
      <setting id="locale.country">Central Europe</setting>
      <setting id="locale.timezonecountry">Germany</setting>
      <setting id="locale.timezone" default="true">${config.customization.general.timeZone}</setting>
      <setting id="locale.shortdateformat">DD.MM.YYYY</setting>
      <setting id="locale.longdateformat" default="true">regional</setting>
      <setting id="locale.timeformat">HH:mm:ss</setting>
      <setting id="locale.use24hourclock" default="true">regional</setting>
      <setting id="locale.temperatureunit" default="true">regional</setting>
      <setting id="locale.speedunit" default="true">regional</setting>
      <setting id="screensaver.mode" default="true" />
      <setting id="screensaver.time">5</setting>
      <setting id="screensaver.disableforaudio" default="true">true</setting>
      <setting id="screensaver.usedimonpause" default="true">true</setting>
      <setting id="masterlock.startuplock" default="true">false</setting>
      <setting id="masterlock.maxretries" default="true">3</setting>
      <setting id="lookandfeel.startupaction" default="true">0</setting>
      <setting id="lookandfeel.startupwindow" default="true">10000</setting>
      <setting id="window.width" default="true">720</setting>
      <setting id="window.height" default="true">480</setting>
      <setting id="videolibrary.updateonstartup">true</setting>
      <setting id="videolibrary.backgroundupdate" default="true">false</setting>
      <setting id="videolibrary.ignorevideoversions" default="true">true</setting>
      <setting id="videolibrary.ignorevideoextras" default="true">true</setting>
      <setting id="musiclibrary.updateonstartup">true</setting>
      <setting id="musiclibrary.backgroundupdate" default="true">false</setting>
      <setting id="musiclibrary.exportfiletype" default="true">0</setting>
      <setting id="musiclibrary.exportfolder" default="true" />
      <setting id="musiclibrary.exportitems" default="true">48</setting>
      <setting id="musiclibrary.exportunscraped" default="true">false</setting>
      <setting id="musiclibrary.exportoverwrite" default="true">false</setting>
      <setting id="musiclibrary.exportartwork" default="true">false</setting>
      <setting id="musiclibrary.exportskipnfo" default="true">false</setting>
      <setting id="filelists.showparentdiritems" default="true">true</setting>
      <setting id="filelists.ignorethewhensorting" default="true">true</setting>
      <setting id="filelists.showextensions" default="true">true</setting>
      <setting id="filelists.showaddsourcebuttons" default="true">true</setting>
      <setting id="filelists.showhidden" default="true">false</setting>
      <setting id="filelists.allowfiledeletion" default="true">false</setting>
      <setting id="myvideos.selectaction" default="true">1</setting>
      <setting id="myvideos.selectdefaultversion" default="true">false</setting>
      <setting id="myvideos.playaction" default="true">1</setting>
      <setting id="myvideos.usetags" default="true">false</setting>
      <setting id="myvideos.extractflags" default="true">true</setting>
      <setting id="myvideos.extractchapterthumbs" default="true">true</setting>
      <setting id="myvideos.stackvideos" default="true">false</setting>
      <setting id="myvideos.replacelabels" default="true">true</setting>
      <setting id="videolibrary.showallitems" default="true">true</setting>
      <setting id="videolibrary.showunwatchedplots" default="true">0,1,2</setting>
      <setting id="videolibrary.groupmoviesets" default="true">false</setting>
      <setting id="videolibrary.groupsingleitemsets" default="true">false</setting>
      <setting id="videolibrary.showvideoversionsasfolder" default="true">false</setting>
      <setting id="myvideos.flatten" default="true">false</setting>
      <setting id="videolibrary.flattentvshows" default="true">1</setting>
      <setting id="videolibrary.showemptytvshows" default="true">true</setting>
      <setting id="videolibrary.tvshowsselectfirstunwatcheditem" default="true">0</setting>
      <setting id="videolibrary.tvshowsincludeallseasonsandspecials" default="true">0</setting>
      <setting id="videolibrary.moviesetsfolder" default="true" />
      <setting id="videolibrary.musicvideosallperformers" default="true">true</setting>
      <setting id="videolibrary.artworklevel" default="true">0</setting>
      <setting id="videolibrary.movieartwhitelist" default="true" />
      <setting id="videolibrary.tvshowartwhitelist" default="true" />
      <setting id="videolibrary.episodeartwhitelist" default="true" />
      <setting id="videolibrary.musicvideoartwhitelist" default="true" />
      <setting id="videolibrary.actorthumbs" default="true">true</setting>
      <setting id="myvideos.extractthumb" default="true">true</setting>
      <setting id="musiclibrary.showallitems" default="true">true</setting>
      <setting id="musiclibrary.showcompilationartists" default="true">true</setting>
      <setting id="musiclibrary.showdiscs" default="true">true</setting>
      <setting id="musiclibrary.useartistsortname" default="true">false</setting>
      <setting id="musiclibrary.useoriginaldate" default="true">false</setting>
      <setting id="musiclibrary.downloadinfo" default="true">false</setting>
      <setting id="musiclibrary.artistsfolder" default="true" />
      <setting id="musiclibrary.albumsscraper" default="true">metadata.generic.albums</setting>
      <setting id="musiclibrary.artistsscraper" default="true">metadata.generic.artists</setting>
      <setting id="musiclibrary.overridetags" default="true">false</setting>
      <setting id="musiclibrary.artworklevel" default="true">0</setting>
      <setting id="musiclibrary.usealllocalart" default="true">false</setting>
      <setting id="musiclibrary.useallremoteart" default="true">false</setting>
      <setting id="musiclibrary.artistartwhitelist" default="true" />
      <setting id="musiclibrary.albumartwhitelist" default="true" />
      <setting id="musiclibrary.musicthumbs" default="true">folder.jpg, cover.jpg, cover.jpeg, thumb.jpg</setting>
      <setting id="musiclibrary.preferonlinealbumart" default="true">false</setting>
      <setting id="musicfiles.selectaction" default="true">false</setting>
      <setting id="musicfiles.trackformat" default="true">[%N. ]%A - %T</setting>
      <setting id="musicfiles.nowplayingtrackformat" default="true" />
      <setting id="musicfiles.librarytrackformat" default="true" />
      <setting id="musicfiles.findremotethumbs" default="true">true</setting>
      <setting id="musicfiles.usetags" default="true">true</setting>
      <setting id="mymusic.songthumbinvis" default="true">false</setting>
      <setting id="mymusic.defaultlibview" default="true" />
      <setting id="pictures.usetags" default="true">true</setting>
      <setting id="pictures.generatethumbs" default="true">true</setting>
      <setting id="pictures.showvideos" default="true">true</setting>
      <setting id="pictures.displayresolution" default="true">14</setting>
      <setting id="scrapers.moviesdefault" default="true">metadata.themoviedb.org.python</setting>
      <setting id="scrapers.tvshowsdefault" default="true">metadata.tvshows.themoviedb.org.python</setting>
      <setting id="scrapers.musicvideosdefault" default="true">metadata.local</setting>
      <setting id="videoplayer.autoplaynextitem" default="true" />
      <setting id="videoplayer.seeksteps" default="true">-600,-300,-180,-60,-30,-10,10,30,60,180,300,600</setting>
      <setting id="videoplayer.seekdelay" default="true">750</setting>
      <setting id="videoplayer.adjustrefreshrate">2</setting>
      <setting id="winsystem.ishdrdisplay" default="true">true</setting>
      <setting id="videoplayer.usedisplayasclock" default="true">false</setting>
      <setting id="videoplayer.errorinaspect" default="true">0</setting>
      <setting id="videoplayer.stretch43" default="true">0</setting>
      <setting id="videoplayer.rendermethod" default="true">0</setting>
      <setting id="videoplayer.hqscalers" default="true">20</setting>
      <setting id="videoplayer.usesuperresolution" default="true">false</setting>
      <setting id="videoplayer.usemediacodecsurface" default="true">true</setting>
      <setting id="videoplayer.usemediacodec" default="true">true</setting>
      <setting id="videoplayer.usedxva2" default="true">true</setting>
      <setting id="videoplayer.usevtb" default="true">true</setting>
      <setting id="videoplayer.highprecision" default="true">true</setting>
      <setting id="videoplayer.convertdovi" default="true">false</setting>
      <setting id="videoplayer.allowedhdrformats" default="true">0,1</setting>
      <setting id="videoplayer.usevdpau" default="true">true</setting>
      <setting id="videoplayer.usevdpaumixer" default="true">true</setting>
      <setting id="videoplayer.usevdpaumpeg2" default="true">false</setting>
      <setting id="videoplayer.usevdpaumpeg4" default="true">false</setting>
      <setting id="videoplayer.usevdpauvc1" default="true">true</setting>
      <setting id="videoplayer.usevaapi" default="true">true</setting>
      <setting id="videoplayer.usevaapimpeg2" default="true">false</setting>
      <setting id="videoplayer.usevaapimpeg4" default="true">true</setting>
      <setting id="videoplayer.usevaapivc1" default="true">true</setting>
      <setting id="videoplayer.usevaapivp8" default="true">true</setting>
      <setting id="videoplayer.usevaapivp9" default="true">true</setting>
      <setting id="videoplayer.usevaapihevc" default="true">true</setting>
      <setting id="videoplayer.usevaapiav1" default="true">true</setting>
      <setting id="videoplayer.prefervaapirender" default="true">true</setting>
      <setting id="videoplayer.useprimedecoder" default="true">false</setting>
      <setting id="videoplayer.useprimedecoderforhw" default="true">true</setting>
      <setting id="videoplayer.useprimerenderer" default="true">1</setting>
      <setting id="videoplayer.stereoscopicplaybackmode" default="true">0</setting>
      <setting id="videoplayer.quitstereomodeonstop" default="true">true</setting>
      <setting id="videoplayer.teletextenabled" default="true">true</setting>
      <setting id="videoplayer.teletextscale" default="true">true</setting>
      <setting id="musicplayer.autoplaynextitem" default="true">true</setting>
      <setting id="musicplayer.queuebydefault" default="true">false</setting>
      <setting id="musicplayer.seeksteps" default="true">-60,-30,-10,10,30,60</setting>
      <setting id="musicplayer.seekdelay" default="true">750</setting>
      <setting id="musicplayer.crossfade" default="true">0</setting>
      <setting id="musicplayer.crossfadealbumtracks" default="true">true</setting>
      <setting id="musicplayer.visualisation" default="true" />
      <setting id="musicplayer.replaygaintype" default="true">1</setting>
      <setting id="musicplayer.replaygainpreamp" default="true">89</setting>
      <setting id="musicplayer.replaygainnogainpreamp" default="true">89</setting>
      <setting id="musicplayer.replaygainavoidclipping" default="true">false</setting>
      <setting id="dvds.autorun" default="true">false</setting>
      <setting id="dvds.playerregion" default="true">0</setting>
      <setting id="dvds.automenu" default="true">false</setting>
      <setting id="bluray.playerregion" default="true">1</setting>
      <setting id="disc.playback" default="true">0</setting>
      <setting id="audiocds.autoaction" default="true">0</setting>
      <setting id="audiocds.usecddb" default="true">true</setting>
      <setting id="audiocds.recordingpath" default="true" />
      <setting id="audiocds.trackpathformat" default="true">%A/%A - %B/[%N. ][%A - ]%T</setting>
      <setting id="audiocds.encoder" default="true">audioencoder.kodi.builtin.aac</setting>
      <setting id="audiocds.ejectonrip" default="true">true</setting>
      <setting id="slideshow.staytime" default="true">5</setting>
      <setting id="slideshow.displayeffects" default="true">true</setting>
      <setting id="slideshow.shuffle" default="true">false</setting>
      <setting id="slideshow.highqualitydownscaling" default="true">false</setting>
      <setting id="locale.audiolanguage">German</setting>
      <setting id="videoplayer.preferdefaultflag" default="true">true</setting>
      <setting id="locale.subtitlelanguage" default="true">original</setting>
      <setting id="accessibility.audiovisual" default="true">false</setting>
      <setting id="accessibility.audiohearing" default="true">false</setting>
      <setting id="accessibility.subhearing" default="true">false</setting>
      <setting id="subtitles.align" default="true">2</setting>
      <setting id="subtitles.fontname" default="true">DEFAULT</setting>
      <setting id="subtitles.fontsize" default="true">42</setting>
      <setting id="subtitles.style" default="true">0</setting>
      <setting id="subtitles.colorpick" default="true">FFFFFFFF</setting>
      <setting id="subtitles.opacity" default="true">100</setting>
      <setting id="subtitles.bordersize" default="true">25</setting>
      <setting id="subtitles.bordercolorpick" default="true">FF000000</setting>
      <setting id="subtitles.blur" default="true">0</setting>
      <setting id="subtitles.backgroundtype" default="true">0</setting>
      <setting id="subtitles.bgcolorpick" default="true">FF000000</setting>
      <setting id="subtitles.bgopacity" default="true">80</setting>
      <setting id="subtitles.shadowcolor" default="true">FF000000</setting>
      <setting id="subtitles.shadowopacity" default="true">100</setting>
      <setting id="subtitles.shadowsize" default="true">15</setting>
      <setting id="subtitles.marginvertical" default="true">4.95</setting>
      <setting id="subtitles.overridefonts" default="true">false</setting>
      <setting id="subtitles.overridestyles" default="true">0</setting>
      <setting id="subtitles.stereoscopicdepth" default="true">0</setting>
      <setting id="subtitles.charset" default="true">DEFAULT</setting>
      <setting id="subtitles.parsecaptions" default="true">false</setting>
      <setting id="subtitles.captionsalign" default="true">0</setting>
      <setting id="subtitles.languages" default="true">English</setting>
      <setting id="subtitles.storagemode" default="true">0</setting>
      <setting id="subtitles.custompath" default="true" />
      <setting id="subtitles.pauseonsearch" default="true">true</setting>
      <setting id="subtitles.downloadfirst" default="true">false</setting>
      <setting id="subtitles.tv" default="true" />
      <setting id="subtitles.movie" default="true" />
      <setting id="pvrmanager.backendchannelgroupsorder" default="true">true</setting>
      <setting id="pvrmanager.backendchannelorder" default="true">true</setting>
      <setting id="pvrmanager.usebackendchannelnumbersalways" default="true">false</setting>
      <setting id="pvrmanager.usebackendchannelnumbers" default="true">false</setting>
      <setting id="pvrmanager.startgroupchannelnumbersfromone" default="true">false</setting>
      <setting id="pvrmenu.iconpath" default="true" />
      <setting id="epg.pastdaystodisplay" default="true">1</setting>
      <setting id="epg.futuredaystodisplay" default="true">3</setting>
      <setting id="epg.selectaction" default="true">2</setting>
      <setting id="epg.hidenoinfoavailable" default="true">true</setting>
      <setting id="epg.epgupdate" default="true">120</setting>
      <setting id="epg.preventupdateswhileplayingtv" default="true">false</setting>
      <setting id="pvrplayback.switchtofullscreenchanneltypes" default="true">3</setting>
      <setting id="pvrmanager.preselectplayingchannel" default="true">false</setting>
      <setting id="pvrmenu.displaychannelinfo" default="true">5</setting>
      <setting id="pvrmenu.closechannelosdonswitch" default="true">true</setting>
      <setting id="pvrplayback.confirmchannelswitch" default="true">true</setting>
      <setting id="pvrplayback.channelentrytimeout" default="true">0</setting>
      <setting id="pvrplayback.delaymarklastwatched" default="true">0</setting>
      <setting id="pvrplayback.signalquality" default="true">true</setting>
      <setting id="pvrplayback.fps" default="true">0</setting>
      <setting id="pvrplayback.autoplaynextprogramme" default="true">true</setting>
      <setting id="pvrplayback.enableradiords" default="true">true</setting>
      <setting id="pvrplayback.trafficadvisory" default="true">false</setting>
      <setting id="pvrplayback.trafficadvisoryvolume" default="true">10</setting>
      <setting id="pvrrecord.instantrecordaction" default="true">0</setting>
      <setting id="pvrrecord.instantrecordtime" default="true">120</setting>
      <setting id="pvrrecord.marginstart" default="true">0</setting>
      <setting id="pvrrecord.marginend" default="true">0</setting>
      <setting id="pvrrecord.timernotifications" default="true">true</setting>
      <setting id="pvrrecord.grouprecordings" default="true">true</setting>
      <setting id="pvrreminders.autoclosedelay" default="true">10</setting>
      <setting id="pvrreminders.autorecord" default="true">true</setting>
      <setting id="pvrreminders.autoswitch" default="true">false</setting>
      <setting id="pvrpowermanagement.enabled" default="true">false</setting>
      <setting id="pvrpowermanagement.backendidletime" default="true">15</setting>
      <setting id="pvrpowermanagement.setwakeupcmd" default="true" />
      <setting id="pvrpowermanagement.prewakeup" default="true">15</setting>
      <setting id="pvrpowermanagement.dailywakeup" default="true">false</setting>
      <setting id="pvrpowermanagement.dailywakeuptime" default="true">00:00:00</setting>
      <setting id="pvrparental.enabled" default="true">false</setting>
      <setting id="pvrparental.pin" default="true" />
      <setting id="pvrparental.duration" default="true">300</setting>
      <setting id="pvrtimers.hidedisabledtimers" default="true">false</setting>
      <setting id="services.devicename">${config.customization.general.hostName}</setting>
      <setting id="services.zeroconf" default="true">true</setting>
      <setting id="services.deviceuuid">${config.customization.kodi.settings.deviceUuid}</setting>
      <setting id="services.webserver">${lib.boolToString config.customization.kodi.settings.webserver.enable}</setting>
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
      <setting id="smb.workgroup" default="true">WORKGROUP</setting>
      <setting id="smb.winsserver" default="true">0.0.0.0</setting>
      <setting id="smb.minprotocol" default="true">0</setting>
      <setting id="smb.maxprotocol" default="true">3</setting>
      <setting id="smb.legacysecurity" default="true">false</setting>
      <setting id="services.wsdiscovery">false</setting>
      <setting id="smb.chunksize" default="true">128</setting>
      <setting id="nfs.version" default="true">3</setting>
      <setting id="nfs.chunksize" default="true">128</setting>
      <setting id="filecache.buffermode" default="true">4</setting>
      <setting id="filecache.memorysize">512</setting>
      <setting id="filecache.readfactor">0</setting>
      <setting id="filecache.chunksize">262144</setting>
      <setting id="weather.currentlocation" default="true">1</setting>
      <setting id="weather.addon" default="true" />
      <setting id="videoscreen.monitor" default="true">Default</setting>
      <setting id="videoscreen.screen" default="true">0</setting>
      <setting id="videoscreen.resolution">17</setting>
      <setting id="videoscreen.screenmode">0384002160060.00000pstd</setting>
      <setting id="videoscreen.fakefullscreen" default="true">true</setting>
      <setting id="videoscreen.blankdisplays">true</setting>
      <setting id="videoscreen.delayrefreshchange" default="true">0</setting>
      <setting id="videoscreen.10bitsurfaces" default="true">0</setting>
      <setting id="videoscreen.dither" default="true">false</setting>
      <setting id="videoscreen.ditherdepth" default="true">8</setting>
      <setting id="videoscreen.cmsenabled" default="true">false</setting>
      <setting id="videoscreen.cmsmode" default="true">0</setting>
      <setting id="videoscreen.cms3dlut" default="true" />
      <setting id="videoscreen.displayprofile" default="true" />
      <setting id="videoscreen.cmswhitepoint" default="true">0</setting>
      <setting id="videoscreen.cmsprimaries" default="true">0</setting>
      <setting id="videoscreen.cmsgammamode" default="true">0</setting>
      <setting id="videoscreen.cmsgamma" default="true">220</setting>
      <setting id="videoscreen.cmslutsize" default="true">6</setting>
      <setting id="videoscreen.hwscalingfilter" default="true">true</setting>
      <setting id="videoscreen.limitguisize" default="true">0</setting>
      <setting id="videoscreen.limitedrange" default="true">false</setting>
      <setting id="videoscreen.usesystemsdrpeakluminance" default="true">true</setting>
      <setting id="videoscreen.guipeakluminance" default="true">40</setting>
      <setting id="videoscreen.whitelist" default="true" />
      <setting id="videoscreen.whitelistpulldown" default="true">false</setting>
      <setting id="videoscreen.whitelistdoublerefreshrate" default="true">false</setting>
      <setting id="videoscreen.stereoscopicmode" default="true">0</setting>
      <setting id="videoscreen.preferedstereoscopicmode" default="true">100</setting>
      <setting id="videoscreen.noofbuffers" default="true">3</setting>
      <setting id="audiooutput.audiodevice">ALSA:hdmi:CARD=PCH,DEV=1|HDA Intel PCH</setting>
      <setting id="audiooutput.channels">8</setting>
      <setting id="audiooutput.config">3</setting>
      <setting id="audiooutput.volumesteps" default="true">90</setting>
      <setting id="audiooutput.maintainoriginalvolume" default="true">true</setting>
      <setting id="audiooutput.stereoupmix">true</setting>
      <setting id="audiooutput.processquality">50</setting>
      <setting id="audiooutput.atempothreshold" default="true">2</setting>
      <setting id="audiooutput.samplerate" default="true">48000</setting>
      <setting id="audiooutput.streamsilence" default="true">1</setting>
      <setting id="audiooutput.streamnoise" default="true">true</setting>
      <setting id="audiooutput.guisoundmode" default="true">1</setting>
      <setting id="audiooutput.guisoundvolume" default="true">100</setting>
      <setting id="lookandfeel.soundskin" default="true">resource.uisounds.kodi</setting>
      <setting id="audiooutput.passthrough">true</setting>
      <setting id="audiooutput.passthroughdevice">ALSA:hdmi:CARD=PCH,DEV=1|HDA Intel PCH</setting>
      <setting id="audiooutput.ac3passthrough" default="true">true</setting>
      <setting id="audiooutput.ac3transcode" default="true">false</setting>
      <setting id="audiooutput.eac3passthrough">true</setting>
      <setting id="audiooutput.dtspassthrough">true</setting>
      <setting id="audiooutput.truehdpassthrough">true</setting>
      <setting id="audiooutput.dtshdpassthrough">true</setting>
      <setting id="audiooutput.dtshdcorefallback" default="true">true</setting>
      <setting id="input.enablemouse" default="true">true</setting>
      <setting id="input.enablejoystick" default="true">true</setting>
      <setting id="input.asknewcontrollers" default="true">true</setting>
      <setting id="input.rumblenotify" default="true">false</setting>
      <setting id="input.controllerpoweroff" default="true">false</setting>
      <setting id="input.libinputkeyboardlayout" default="true">us</setting>
      <setting id="network.usehttpproxy" default="true">false</setting>
      <setting id="network.httpproxytype" default="true">0</setting>
      <setting id="network.httpproxyserver" default="true" />
      <setting id="network.httpproxyport" default="true">8080</setting>
      <setting id="network.httpproxyusername" default="true" />
      <setting id="network.httpproxypassword" default="true" />
      <setting id="network.bandwidth" default="true">0</setting>
      <setting id="powermanagement.displaysoff" default="true">0</setting>
      <setting id="powermanagement.shutdowntime" default="true">0</setting>
      <setting id="powermanagement.shutdownstate" default="true">1</setting>
      <setting id="powermanagement.waitfornetwork" default="true">0</setting>
      <setting id="powermanagement.wakeonaccess" default="true">false</setting>
      <setting id="general.addonupdates" default="true">0</setting>
      <setting id="general.addonnotifications" default="true">false</setting>
      <setting id="addons.unknownsources" default="true">false</setting>
      <setting id="addons.updatemode" default="true">0</setting>
      <setting id="debug.showloginfo" default="true">false</setting>
      <setting id="debug.extralogging" default="true">false</setting>
      <setting id="debug.setextraloglevel" default="true" />
      <setting id="debug.screenshotpath" default="true" />
      <setting id="eventlog.enabled" default="true">true</setting>
      <setting id="eventlog.enablednotifications" default="true">false</setting>
      <setting id="cache.harddisk" default="true">256</setting>
      <setting id="cachevideo.dvdrom" default="true">2048</setting>
      <setting id="cachevideo.lan" default="true">2048</setting>
      <setting id="cachevideo.internet" default="true">4096</setting>
      <setting id="cacheaudio.dvdrom" default="true">256</setting>
      <setting id="cacheaudio.lan" default="true">256</setting>
      <setting id="cacheaudio.internet" default="true">256</setting>
      <setting id="cachedvd.dvdrom" default="true">2048</setting>
      <setting id="cachedvd.lan" default="true">2048</setting>
      <setting id="cacheunknown.internet" default="true">4096</setting>
      <setting id="system.playlistspath">special://profile/playlists/</setting>
      <setting id="general.addonforeignfilter" default="true">false</setting>
      <setting id="general.addonbrokenfilter" default="true">true</setting>
      <resolutions />
      <defaultvideosettings>
          <interlacemethod>1</interlacemethod>
          <scalingmethod>1</scalingmethod>
          <noisereduction>0.000000</noisereduction>
          <postprocess>false</postprocess>
          <sharpness>0.000000</sharpness>
          <viewmode>0</viewmode>
          <zoomamount>1.000000</zoomamount>
          <pixelratio>1.000000</pixelratio>
          <verticalshift>0.000000</verticalshift>
          <volumeamplification>0.000000</volumeamplification>
          <showsubtitles>true</showsubtitles>
          <brightness>50.000000</brightness>
          <contrast>50.000000</contrast>
          <gamma>20.000000</gamma>
          <audiodelay>0.000000</audiodelay>
          <subtitledelay>0.000000</subtitledelay>
          <nonlinstretch>false</nonlinstretch>
          <stereomode>0</stereomode>
          <centermixlevel>0</centermixlevel>
          <tonemapmethod>1</tonemapmethod>
          <tonemapparam>1.000000</tonemapparam>
      </defaultvideosettings>
      <defaultaudiosettings />
      <audio>
          <mute>false</mute>
          <fvolumelevel>1.000000</fvolumelevel>
      </audio>
  </settings>
''
