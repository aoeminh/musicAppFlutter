// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Anytime Podcast Player`
  String get app_title {
    return Intl.message(
      'Anytime Podcast Player',
      name: 'app_title',
      desc: 'Full title for the application',
      args: [],
    );
  }

  /// `Anytime Player`
  String get app_title_short {
    return Intl.message(
      'Anytime Player',
      name: 'app_title_short',
      desc: 'Title for the application',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: 'Library tab label',
      args: [],
    );
  }

  /// `Discover`
  String get discover {
    return Intl.message(
      'Discover',
      name: 'discover',
      desc: 'Discover tab label',
      args: [],
    );
  }

  /// `Downloads`
  String get downloads {
    return Intl.message(
      'Downloads',
      name: 'downloads',
      desc: 'Downloads tab label',
      args: [],
    );
  }

  /// `SUBSCRIBE`
  String get subscribe_button_label {
    return Intl.message(
      'SUBSCRIBE',
      name: 'subscribe_button_label',
      desc: 'Subscribe button label',
      args: [],
    );
  }

  /// `UNSUBSCRIBE`
  String get unsubscribe_button_label {
    return Intl.message(
      'UNSUBSCRIBE',
      name: 'unsubscribe_button_label',
      desc: 'Unsubscribe button label',
      args: [],
    );
  }

  /// `CANCEL`
  String get cancel_button_label {
    return Intl.message(
      'CANCEL',
      name: 'cancel_button_label',
      desc: 'Cancel button label',
      args: [],
    );
  }

  /// `OK`
  String get ok_button_label {
    return Intl.message(
      'OK',
      name: 'ok_button_label',
      desc: 'OK button label',
      args: [],
    );
  }

  /// `Subscribe`
  String get subscribe_label {
    return Intl.message(
      'Subscribe',
      name: 'subscribe_label',
      desc: 'Subscribe label',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get unsubscribe_label {
    return Intl.message(
      'Unsubscribe',
      name: 'unsubscribe_label',
      desc: 'Unsubscribe label',
      args: [],
    );
  }

  /// `Unsubscribing will delete all downloaded episodes of this podcast.`
  String get unsubscribe_message {
    return Intl.message(
      'Unsubscribing will delete all downloaded episodes of this podcast.',
      name: 'unsubscribe_message',
      desc: 'Displayed when the user unsubscribes from a podcast.',
      args: [],
    );
  }

  /// `Search for podcasts`
  String get search_for_podcasts_hint {
    return Intl.message(
      'Search for podcasts',
      name: 'search_for_podcasts_hint',
      desc: 'Hint displayed on search bar when the user clicks the search icon.',
      args: [],
    );
  }

  /// `Delete`
  String get delete_label {
    return Intl.message(
      'Delete',
      name: 'delete_label',
      desc: 'Delete label',
      args: [],
    );
  }

  /// `DELETE`
  String get delete_button_label {
    return Intl.message(
      'DELETE',
      name: 'delete_button_label',
      desc: 'Delete label',
      args: [],
    );
  }

  /// `Mark As Played`
  String get mark_played_label {
    return Intl.message(
      'Mark As Played',
      name: 'mark_played_label',
      desc: 'Mark as played',
      args: [],
    );
  }

  /// `Mark As Unplayed`
  String get mark_unplayed_label {
    return Intl.message(
      'Mark As Unplayed',
      name: 'mark_unplayed_label',
      desc: 'Mark as unplayed',
      args: [],
    );
  }

  /// `Are you sure you wish to delete this episode?`
  String get delete_episode_confirmation {
    return Intl.message(
      'Are you sure you wish to delete this episode?',
      name: 'delete_episode_confirmation',
      desc: 'User is asked to confirm when they attempt to delete an episode',
      args: [],
    );
  }

  /// `Delete Episode`
  String get delete_episode_title {
    return Intl.message(
      'Delete Episode',
      name: 'delete_episode_title',
      desc: 'Delete label',
      args: [],
    );
  }

  /// `You do not have any downloaded episodes`
  String get no_downloads_message {
    return Intl.message(
      'You do not have any downloaded episodes',
      name: 'no_downloads_message',
      desc: 'Displayed on the library tab when the user has no subscriptions',
      args: [],
    );
  }

  /// `No podcasts found`
  String get no_search_results_message {
    return Intl.message(
      'No podcasts found',
      name: 'no_search_results_message',
      desc: 'Displayed on the library tab when the user has no subscriptions',
      args: [],
    );
  }

  /// `Could not load podcast episodes. Please check your connection.`
  String get no_podcast_details_message {
    return Intl.message(
      'Could not load podcast episodes. Please check your connection.',
      name: 'no_podcast_details_message',
      desc: 'Displayed on the podcast details page when the details could not be loaded',
      args: [],
    );
  }

  /// `Play episode`
  String get play_button_label {
    return Intl.message(
      'Play episode',
      name: 'play_button_label',
      desc: 'Semantic label for the play button',
      args: [],
    );
  }

  /// `Pause episode`
  String get pause_button_label {
    return Intl.message(
      'Pause episode',
      name: 'pause_button_label',
      desc: 'Semantic label for the pause button',
      args: [],
    );
  }

  /// `Download episode`
  String get download_episode_button_label {
    return Intl.message(
      'Download episode',
      name: 'download_episode_button_label',
      desc: 'Semantic label for the download episode button',
      args: [],
    );
  }

  /// `Delete episode`
  String get delete_episode_button_label {
    return Intl.message(
      'Delete episode',
      name: 'delete_episode_button_label',
      desc: 'Semantic label for the delete episode',
      args: [],
    );
  }

  /// `Close`
  String get close_button_label {
    return Intl.message(
      'Close',
      name: 'close_button_label',
      desc: 'Close button label',
      args: [],
    );
  }

  /// `Search`
  String get search_button_label {
    return Intl.message(
      'Search',
      name: 'search_button_label',
      desc: 'Search button label',
      args: [],
    );
  }

  /// `Clear search text`
  String get clear_search_button_label {
    return Intl.message(
      'Clear search text',
      name: 'clear_search_button_label',
      desc: 'Search button label',
      args: [],
    );
  }

  /// `Back`
  String get search_back_button_label {
    return Intl.message(
      'Back',
      name: 'search_back_button_label',
      desc: 'Search button label',
      args: [],
    );
  }

  /// `Minimise player window`
  String get minimise_player_window_button_label {
    return Intl.message(
      'Minimise player window',
      name: 'minimise_player_window_button_label',
      desc: 'Search button label',
      args: [],
    );
  }

  /// `Rewind episode 30 seconds`
  String get rewind_button_label {
    return Intl.message(
      'Rewind episode 30 seconds',
      name: 'rewind_button_label',
      desc: 'Rewind button tooltip',
      args: [],
    );
  }

  /// `Fast-forward episode 30 seconds`
  String get fast_forward_button_label {
    return Intl.message(
      'Fast-forward episode 30 seconds',
      name: 'fast_forward_button_label',
      desc: 'Fast forward tooltip',
      args: [],
    );
  }

  /// `About`
  String get about_label {
    return Intl.message(
      'About',
      name: 'about_label',
      desc: 'About menu item',
      args: [],
    );
  }

  /// `Mark all episodes as played`
  String get mark_episodes_played_label {
    return Intl.message(
      'Mark all episodes as played',
      name: 'mark_episodes_played_label',
      desc: 'Mark all episodes played menu item',
      args: [],
    );
  }

  /// `Mark all episodes as not played`
  String get mark_episodes_not_played_label {
    return Intl.message(
      'Mark all episodes as not played',
      name: 'mark_episodes_not_played_label',
      desc: 'Mark all episodes not-played menu item',
      args: [],
    );
  }

  /// `Are you sure you wish to stop this download and delete the episode?`
  String get stop_download_confirmation {
    return Intl.message(
      'Are you sure you wish to stop this download and delete the episode?',
      name: 'stop_download_confirmation',
      desc: 'User is asked to confirm when they wish to stop the active download.',
      args: [],
    );
  }

  /// `STOP`
  String get stop_download_button_label {
    return Intl.message(
      'STOP',
      name: 'stop_download_button_label',
      desc: 'Stop label',
      args: [],
    );
  }

  /// `Stop Download`
  String get stop_download_title {
    return Intl.message(
      'Stop Download',
      name: 'stop_download_title',
      desc: 'Stop download label',
      args: [],
    );
  }

  /// `Mark deleted episodes as played`
  String get settings_mark_deleted_played_label {
    return Intl.message(
      'Mark deleted episodes as played',
      name: 'settings_mark_deleted_played_label',
      desc: 'Mark deleted episodes as played setting',
      args: [],
    );
  }

  /// `Download episodes to SD card`
  String get settings_download_sd_card_label {
    return Intl.message(
      'Download episodes to SD card',
      name: 'settings_download_sd_card_label',
      desc: 'Download episodes to SD card setting',
      args: [],
    );
  }

  /// `New downloads will be saved to the SD card. Existing downloads will remain on internal storage.`
  String get settings_download_switch_card {
    return Intl.message(
      'New downloads will be saved to the SD card. Existing downloads will remain on internal storage.',
      name: 'settings_download_switch_card',
      desc: 'Displayed when user switches from internal storage to SD card',
      args: [],
    );
  }

  /// `New downloads will be saved to internal storage. Existing downloads will remain on the SD card.`
  String get settings_download_switch_internal {
    return Intl.message(
      'New downloads will be saved to internal storage. Existing downloads will remain on the SD card.',
      name: 'settings_download_switch_internal',
      desc: 'Displayed when user switches from internal SD card to internal storage',
      args: [],
    );
  }

  /// `Change storage location`
  String get settings_download_switch_label {
    return Intl.message(
      'Change storage location',
      name: 'settings_download_switch_label',
      desc: 'Dialog label for storage switch',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}