//
//  GlobalConstants.h
//  NabiSquareHD
//
//  Created by Admin on 12/12/14.
//  Copyright (c) 2014 Fuhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LIVEMJPEG_STREAM_ADDRESS @"http://192.72.1.1/cgi-bin/liveMJPEG"
#define DEFAULT_SSID @"Nabi-actioncamera"
#define DEFAULT_PRESHAREDKEY @"Ab123Cd45"
#define PREFS_NAME @"nabiSquareHDCamPreferences"
#define PREFS_WARN_NETWORK_IS_DEFAULT @"warnNetworkSSIDisDefault"
#define PREFS_SSID @"SSID"
#define PREFS_FWVERSION @"FWVersion"
#define PREFS_ENCRYPTION_KEY @"EncryptionKey"
#define SHARED_PREFERENCES_WIFI @"WiFi"
#define SHARED_PREFERENCE_WIFI_KEY_SSID @"SSID"

#define CAMERA_HTTP_HOST @"http://192.72.1.1"
#define CAMERA_START_STOP_RECORD @"/cgi-bin/Config.cgi?action=set&property=Video&value=record"
#define CAMERA_CAPTURE @"/cgi-bin/Config.cgi?action=set&property=Camera&value=capture"
#define CAMERA_VIDEO_FORMAT_4K15 @"/cgi-bin/Config.cgi?action=set&property=Videores&value=4K15"
#define CAMERA_VIDEO_FORMAT_2K30 @"/cgi-bin/Config.cgi?action=set&property=Videores&value=2.7K30"
#define CAMERA_VIDEO_FORMAT_1080P60 @"/cgi-bin/Config.cgi?action=set&property=Videores&value=1080P60"
#define CAMERA_VIDEO_FORMAT_1080P30 @"/cgi-bin/Config.cgi?action=set&property=Videores&value=1080P30"
#define CAMERA_VIDEO_FORMAT_720P120 @"/cgi-bin/Config.cgi?action=set&property=Videores&value=720P120"
#define CAMERA_VIDEO_FORMAT_720P100 @"/cgi-bin/Config.cgi?action=set&property=Videores&value=720P100"

#define CAMERA_IMAGE_RESOLUTION_8MP @"/cgi-bin/Config.cgi?action=set&property=Imageres&value=8MP"
#define CAMERA_IMAGE_RESOLUTION_6MPW @"/cgi-bin/Config.cgi?action=set&property=Imageres&value=6MPW"
#define CAMERA_IMAGE_RESOLUTION_6MP @"/cgi-bin/Config.cgi?action=set&property=Imageres&value=6MP"

#define CAMERA_WHITE_BALANCE_AUTO @"/cgi-bin/Config.cgi?action=set&property=AWB&value=AUTO"
#define CAMERA_WHITE_BALANCE_DAYLIGHT @"/cgi-bin/Config.cgi?action=set&property=AWB&value=DAYLIGHT"
#define CAMERA_WHITE_BALANCE_CLOUDY @"/cgi-bin/Config.cgi?action=set&property=AWB&value=CLOUDY"
#define CAMERA_WHITE_BALANCE_FLOURESC @"/cgi-bin/Config.cgi?action=set&property=AWB&value=FLOURESC"
#define CAMERA_WHITE_BALANCE_UNDERWATER @"/cgi-bin/Config.cgi?action=set&property=AWB&value=UNDERWATER"

#define CAMERA_BURST_RATE_3X1 @"/cgi-bin/Config.cgi?action=set&property=PhotoBurst&value=3_1SEC"
#define CAMERA_BURST_RATE_5X1 @"/cgi-bin/Config.cgi?action=set&property=PhotoBurst&value=5_1SEC"
#define CAMERA_BURST_RATE_10X1 @"/cgi-bin/Config.cgi?action=set&property=PhotoBurst&value=10_1SEC"

#define CAMERA_TIMELAPSE_RATE_2SEC @"/cgi-bin/Config.cgi?action=set&property=Timelapse&value=2SEC"
#define CAMERA_TIMELAPSE_RATE_5SEC @"/cgi-bin/Config.cgi?action=set&property=Timelapse&value=5SEC"
#define CAMERA_TIMELAPSE_RATE_10SEC @"/cgi-bin/Config.cgi?action=set&property=Timelapse&value=10SEC"
#define CAMERA_TIMELAPSE_RATE_30EC @"/cgi-bin/Config.cgi?action=set&property=Timelapse&value=30SEC"
#define CAMERA_TIMELAPSE_RATE_60EC @"/cgi-bin/Config.cgi?action=set&property=Timelapse&value=60SEC"


#define CAMERA_ALL_SETTINGS @"/cgi-bin/Config.cgi?action=get&property=Camera."

#define CAMERA_BEEP_ON @"/cgi-bin/Config.cgi?action=set&property=Beep&value=on"
#define CAMERA_BEEP_OFF @"/cgi-bin/Config.cgi?action=set&property=Beep&value=off"

#define CAMERA_MODE_VIDEO @"/cgi-bin/Config.cgi?action=set&property=UIMode&value=VIDEO"
#define CAMERA_MODE_CAMERA @"/cgi-bin/Config.cgi?action=set&property=UIMode&value=CAMERA"
#define CAMERA_MODE_BURST @"/cgi-bin/Config.cgi?action=set&property=UIMode&value=BURST"
#define CAMERA_MODE_TIMELAPSE @"/cgi-bin/Config.cgi?action=set&property=UIMode&value=TIMELAPSE"

#define CAMERA_BATTERY_LEVEL @"/cgi-bin/Config.cgi?action=get&property=Camera.Battery.Level"
#define CAMERA_WIFI_RESET @"/cgi-bin/Config.cgi?action=set&property=Net&value=reset"
#define CAMERA_FIND_ME @"/cgi-bin/Config.cgi?action=set&property=Net&value=findme"

#define CAMERA_STREAM_LIVEMJPEG_HTTP @"http://192.72.1.1/cgi-bin/stream.cgi?type=live&resolution=320x240"
#define CAMERA_STREAM_LIVE_RTSP @"rtsp://192.72.1.1/liveRTSP/av1"
#define CAMERA_FIRMWARE_PREPARE_UPDATE @"/cgi-bin/Config.cgi?action=set&property=UIMode&value=UPDATEFW"
#define FIRMWARE_UPDATE_URL_ @"http://update.fuhu.org/updates/fuhu/software/SquareHD?deviceType=Camera&deviceEdition=Camera-US&firmwareVersion=default&androidVersion=default&countryCode=US&lang=En_US"

// HeaderTitle
#define HEADER_CHANGE_WIFI_SETTINGS @"Change Wi-Fi Settings"

extern NSString *const kSettingCameraStart;
extern NSString *const kSettingCameraEnd;
extern NSString *const kSettingResult;

extern NSString *const kAdvancedSelected;
extern NSString *const kAdvancedType;
extern NSString *const kAdvancedImageName;

@interface GlobalConstants : NSObject

@end
