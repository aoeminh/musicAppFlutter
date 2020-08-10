// Copyright 2020 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'podcast.dart';

class Feed {
  final PodcastMusic podcast;
  String imageUrl;
  String thumbImageUrl;
  bool refresh;

  Feed(
      {@required this.podcast,
      this.imageUrl,
      this.thumbImageUrl,
      this.refresh = false});
}
