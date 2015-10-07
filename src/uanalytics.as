/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

include "C/unistd/which.as";
include "crypto/generateRandomBytes.as";

include "libraries/uanalytics/tracking/AnalyticsTracker.as";
include "libraries/uanalytics/tracking/AnalyticsSender.as";
include "libraries/uanalytics/tracking/Configuration.as";
include "libraries/uanalytics/tracking/HitModel.as";
include "libraries/uanalytics/tracking/HitSampler.as";
include "libraries/uanalytics/tracking/HitSender.as";
include "libraries/uanalytics/tracking/Metadata.as";
include "libraries/uanalytics/tracking/RateLimiter.as";
include "libraries/uanalytics/tracking/RateLimitError.as";
include "libraries/uanalytics/tracking/Tracker.as";

include "libraries/uanalytics/tracker/HitType.as";
include "libraries/uanalytics/tracker/DataSource.as";
include "libraries/uanalytics/tracker/SessionControl.as";
include "libraries/uanalytics/tracker/ApplicationInfo.as";
include "libraries/uanalytics/tracker/SystemInfo.as";
include "libraries/uanalytics/tracker/TimingInfo.as";
include "libraries/uanalytics/tracker/CommandLineTracker.as";
include "libraries/uanalytics/tracker/CliTracker.as";

include "libraries/uanalytics/tracker/senders/TraceHitSender.as";
include "libraries/uanalytics/tracker/senders/BSDSocketHitSender.as";
include "libraries/uanalytics/tracker/senders/CurlHitSender.as";

include "libraries/uanalytics/utils/isDigit.as";
include "libraries/uanalytics/utils/crc32.as";
include "libraries/uanalytics/utils/getCLIHostname.as";
include "libraries/uanalytics/utils/generateCLIUUID.as";
include "libraries/uanalytics/utils/generateCLISystemInfo.as";
include "libraries/uanalytics/utils/generateCLIUserAgent.as";

include "libraries/uanalytics/tracker/addons/DebugFileSystemStorage.as";

"uanalytics 0.8.0";