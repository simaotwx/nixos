{ config, ... }:
let
  cfg = config.customization.kodi.addons."plugin.video.youtube".settings;
in ''
<settings version="2">
    <setting id="kodion.setup_wizard">false</setting>
    <setting id="kodion.setup_wizard.forced_runs">5</setting>
    <setting id="kodion.mpd.videos" default="true">true</setting>
    <setting id="kodion.mpd.stream.select" default="true">3</setting>
    <setting id="kodion.mpd.quality.selection">6</setting>
    <setting id="kodion.video.stream.select" default="true">2</setting>
    <setting id="kodion.video.quality.ask" default="true">false</setting>
    <setting id="kodion.video.quality" default="true">3</setting>
    <setting id="kodion.mpd.stream.features">avc1,vp9,av01,hdr,hfr,vorbis,opus,mp4a,ssa,ac-3,ec-3,dts,filter</setting>
    <setting id="kodion.audio_only" default="true">false</setting>
    <setting id="kodion.subtitle.languages.num" default="true">0</setting>
    <setting id="kodion.subtitle.download" default="true">false</setting>
    <setting id="kodion.content.max_per_page" default="true">50</setting>
    <setting id="youtube.view.hide_videos" default="true" />
    <setting id="youtube.suggested_videos" default="true">false</setting>
    <setting id="youtube.post.play.rate" default="true">false</setting>
    <setting id="youtube.post.play.rate.playlists" default="true">false</setting>
    <setting id="kodion.safe.search">1</setting>
    <setting id="kodion.age.gate">false</setting>
    <setting id="youtube.api.key">${cfg.apiKey}</setting>
    <setting id="youtube.api.id">${cfg.apiClientId}</setting>
    <setting id="youtube.api.secret">${cfg.apiClientSecret}</setting>
    <setting id="youtube.allow.dev.keys" default="true">true</setting>
    <setting id="youtube.api.config.page" default="true">false</setting>
    <setting id="youtube.folder.sign.in.show" default="true">false</setting>
    <setting id="youtube.folder.my_subscriptions.show" default="true">true</setting>
    <setting id="youtube.folder.my_subscriptions_filtered.show" default="true">false</setting>
    <setting id="youtube.filter.my_subscriptions_filtered.blacklist" default="true">false</setting>
    <setting id="youtube.filter.my_subscriptions_filtered.list" default="true" />
    <setting id="youtube.folder.recommendations.show" default="true">true</setting>
    <setting id="youtube.folder.related.show" default="true">true</setting>
    <setting id="youtube.folder.popular_right_now.show" default="true">true</setting>
    <setting id="youtube.folder.search.show" default="true">false</setting>
    <setting id="youtube.folder.quick_search.show">true</setting>
    <setting id="youtube.folder.quick_search_incognito.show" default="true">false</setting>
    <setting id="youtube.folder.my_location.show" default="true">true</setting>
    <setting id="youtube.folder.my_channel.show" default="true">true</setting>
    <setting id="youtube.folder.purchases.show" default="true">false</setting>
    <setting id="youtube.folder.watch_later.show" default="true">true</setting>
    <setting id="youtube.folder.watch_later.playlist" default="true" />
    <setting id="youtube.folder.liked_videos.show" default="true">true</setting>
    <setting id="youtube.folder.disliked_videos.show" default="true">true</setting>
    <setting id="youtube.folder.history.show" default="true">true</setting>
    <setting id="youtube.folder.history.playlist" default="true" />
    <setting id="youtube.folder.playlists.show" default="true">true</setting>
    <setting id="youtube.folder.saved.playlists.show" default="true">false</setting>
    <setting id="youtube.folder.subscriptions.show" default="true">true</setting>
    <setting id="youtube.folder.bookmarks.show" default="true">true</setting>
    <setting id="youtube.folder.browse_channels.show" default="true">true</setting>
    <setting id="youtube.folder.completed.live.show" default="true">true</setting>
    <setting id="youtube.folder.upcoming.live.show" default="true">true</setting>
    <setting id="youtube.folder.live.show" default="true">true</setting>
    <setting id="youtube.folder.switch.user.show" default="true">true</setting>
    <setting id="youtube.folder.sign.out.show" default="true">true</setting>
    <setting id="youtube.folder.settings.show" default="true">true</setting>
    <setting id="youtube.folder.settings.advanced.show" default="true">false</setting>
    <setting id="kodion.support.alternative_player" default="true">false</setting>
    <setting id="kodion.alternative_player.web_urls" default="true">false</setting>
    <setting id="kodion.alternative_player.adaptive" default="true">false</setting>
    <setting id="kodion.default_player.web_urls" default="true">false</setting>
    <setting id="kodion.video.quality.isa" default="true">true</setting>
    <setting id="kodion.live_stream.selection.1">2</setting>
    <setting id="kodion.live_stream.selection.2" default="true">0</setting>
    <setting id="kodion.history.local">false</setting>
    <setting id="kodion.history.remote">true</setting>
    <setting id="kodion.cache.size">40</setting>
    <setting id="kodion.search.size">0</setting>
    <setting id="youtube.view.description.details" default="true">true</setting>
    <setting id="youtube.view.label.details" default="true">true</setting>
    <setting id="youtube.view.channel_name.aliases" default="true">cast</setting>
    <setting id="youtube.view.label.color.viewCount" default="true">ffadd8e6</setting>
    <setting id="youtube.view.label.color.likeCount" default="true">ff00ff00</setting>
    <setting id="youtube.view.label.color.commentCount" default="true">ff00ffff</setting>
    <setting id="kodion.thumbnail.size" default="true">1</setting>
    <setting id="kodion.fanart.selection" default="true">2</setting>
    <setting id="youtube.language">en</setting>
    <setting id="youtube.region">DE</setting>
    <setting id="youtube.location" default="true" />
    <setting id="youtube.location.radius" default="true">500</setting>
    <setting id="kodion.play_count.percent">85</setting>
    <setting id="youtube.playlist.watchlater.autoremove" default="true">true</setting>
    <setting id="youtube.post.play.refresh" default="true">false</setting>
    <setting id="requests.ssl.verify" default="true">true</setting>
    <setting id="requests.timeout.connect" default="true">9</setting>
    <setting id="requests.timeout.read">20</setting>
    <setting id="kodion.http.listen">0.0.0.0</setting>
    <setting id="kodion.http.port" default="true">50152</setting>
    <setting id="kodion.http.ip.whitelist" default="true" />
    <setting id="youtube.http.idle_sleep" default="true">true</setting>
    <setting id="|end_settings_marker|">true</setting>
</settings>
''