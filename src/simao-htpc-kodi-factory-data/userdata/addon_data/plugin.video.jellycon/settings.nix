{ config, ... }:
let
  cfg = config.customization.kodi.addons."plugin.video.jellycon".settings;
in ''
<settings version="2">
    <setting id="ipaddress" default="true" />
    <setting id="protocol" default="true">0</setting>
    <setting id="port" default="true">8096</setting>
    <setting id="server_address">${cfg.serverAddress}</setting>
    <setting id="verify_cert">true</setting>
    <setting id="username">${cfg.username}</setting>
    <setting id="save_user_to_settings">true</setting>
    <setting id="allow_password_saving">true</setting>
    <setting id="play_cinema_intros" default="true">false</setting>
    <setting id="allow_direct_file_play">true</setting>
    <setting id="force_transcode_h265" default="true">false</setting>
    <setting id="force_transcode_mpeg2" default="true">false</setting>
    <setting id="force_transcode_msmpeg4v3" default="true">false</setting>
    <setting id="force_transcode_mpeg4" default="true">false</setting>
    <setting id="force_transcode_av1" default="true">false</setting>
    <setting id="direct_stream_sub_select" default="true">0</setting>
    <setting id="max_stream_bitrate">23</setting>
    <setting id="force_max_stream_bitrate">24</setting>
    <setting id="playback_max_width" default="true">1920</setting>
    <setting id="playback_video_force_8" default="true">false</setting>
    <setting id="audio_codec" default="true">ac3</setting>
    <setting id="audio_playback_bitrate">640</setting>
    <setting id="audio_max_channels">8</setting>
    <setting id="max_play_queue">200</setting>
    <setting id="play_next_trigger_time" default="true">0</setting>
    <setting id="promptPlayNextEpisodePercentage">90</setting>
    <setting id="promptPlayNextEpisodePercentage_prompt">true</setting>
    <setting id="promptDeleteEpisodePercentage">100</setting>
    <setting id="promptDeleteMoviePercentage">100</setting>
    <setting id="forceAutoResume">true</setting>
    <setting id="jump_back_amount">15</setting>
    <setting id="stopPlaybackOnScreensaver" default="true">false</setting>
    <setting id="changeUserOnScreenSaver" default="true">false</setting>
    <setting id="cacheImagesOnScreenSaver">true</setting>
    <setting id="cacheImagesOnScreenSaver_interval" default="true">0</setting>
    <setting id="addCounts" default="true">false</setting>
    <setting id="addResumePercent">true</setting>
    <setting id="addSubtitleAvailable" default="true">false</setting>
    <setting id="include_overview">true</setting>
    <setting id="include_media">true</setting>
    <setting id="add_user_ratings">true</setting>
    <setting id="include_people">true</setting>
    <setting id="hide_unwatched_details" default="true">false</setting>
    <setting id="episode_name_format" default="true">{ItemName}</setting>
    <setting id="group_movies">true</setting>
    <setting id="flatten_single_season">true</setting>
    <setting id="show_all_episodes">true</setting>
    <setting id="show_empty_folders" default="true">false</setting>
    <setting id="hide_watched">true</setting>
    <setting id="rewatch_days" default="true">0</setting>
    <setting id="rewatch_combine" default="true">false</setting>
    <setting id="moviePageSize" default="true">0</setting>
    <setting id="show_x_filtered_items">20</setting>
    <setting id="widget_select_action" default="true">0</setting>
    <setting id="interface_mode" default="true">0</setting>
    <setting id="websocket_enabled">true</setting>
    <setting id="override_contextmenu">true</setting>
    <setting id="background_interval">20</setting>
    <setting id="new_content_check_interval" default="true">0</setting>
    <setting id="simple_new_content_check">true</setting>
    <setting id="random_movie_refresh_interval">5</setting>
    <setting id="deviceName">htpc</setting>
    <setting id="http_timeout">20</setting>
    <setting id="profile_count" default="true">0</setting>
    <setting id="log_debug" default="true">false</setting>
    <setting id="log_timing" default="true">false</setting>
    <setting id="use_cache">true</setting>
    <setting id="use_cached_widget_data" default="true">false</setting>
    <setting id="showLoadProgress">true</setting>
    <setting id="suppressErrors" default="true">false</setting>
    <setting id="speed_test_data_size">10</setting>
    <setting id="view-movies" default="true" />
    <setting id="view-tvshows" default="true" />
    <setting id="view-seasons" default="true" />
    <setting id="view-episodes" default="true" />
    <setting id="view-sets" default="true" />
    <setting id="sort-Movies" default="true">0</setting>
    <setting id="sort-BoxSets" default="true">0</setting>
    <setting id="sort-Series" default="true">0</setting>
    <setting id="sort-Seasons" default="true">0</setting>
    <setting id="sort-Episodes" default="true">0</setting>
    <setting id="server_speed_check_data" default="true">${cfg.serverAddress}-692208</setting>
</settings>
''