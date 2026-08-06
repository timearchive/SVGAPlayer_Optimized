//
//  OptSVGAPlayer.h
//  OptSVGAPlayer
//
//  A unified framework containing SVGAPlayer, SVGARePlayer, and SVGAExPlayer
//
//  This framework contains all the code from:
//  - SVGAPlayer (original player with parser and rendering)
//  - Protobuf (protocol buffers for SVGA format)
//  - SSZipArchive (zip decompression)
//  - SVGARePlayer (refactored Objective-C player)
//  - SVGAExPlayer (Swift enhanced player)
//

#import <Foundation/Foundation.h>

//! Project version number for OptSVGAPlayer.
FOUNDATION_EXPORT double OptSVGAPlayerVersionNumber;

//! Project version string for OptSVGAPlayer.
FOUNDATION_EXPORT const unsigned char OptSVGAPlayerVersionString[];

// Import all public headers from SVGAPlayer (compiled into this framework)
#import <OptSVGAPlayer/SVGA.h>
#import <OptSVGAPlayer/Svga.pbobjc.h>
#import <OptSVGAPlayer/Protobuf-library-umbrella.h>
#import <OptSVGAPlayer/SVGAPlayer.h>
#import <OptSVGAPlayer/SVGAParser.h>
#import <OptSVGAPlayer/SVGAVideoEntity.h>
#import <OptSVGAPlayer/SVGAVideoSpriteEntity.h>
#import <OptSVGAPlayer/SVGAVideoSpriteFrameEntity.h>
#import <OptSVGAPlayer/SVGAContentLayer.h>
#import <OptSVGAPlayer/SVGABitmapLayer.h>
#import <OptSVGAPlayer/SVGAVectorLayer.h>
#import <OptSVGAPlayer/SVGAAudioLayer.h>
#import <OptSVGAPlayer/SVGAAudioEntity.h>
#import <OptSVGAPlayer/SVGABezierPath.h>
#import <OptSVGAPlayer/SVGAImageView.h>
#import <OptSVGAPlayer/SVGAExporter.h>

// Import SVGARePlayer and SVGAExPlayer
#import <OptSVGAPlayer/SVGARePlayer.h>
#import <OptSVGAPlayer/SVGAVideoEntity+Extension.h>
