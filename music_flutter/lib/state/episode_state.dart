// Copyright 2020 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:music_flutter/model/episode.dart';

abstract class EpisodeState {
  final Episode episode;

  EpisodeState(this.episode);
}

class EpisodeUpdateState extends EpisodeState {
  EpisodeUpdateState(Episode episode) : super(episode);
}

class EpisodeDeleteState extends EpisodeState {
  EpisodeDeleteState(Episode episode) : super(episode);
}
