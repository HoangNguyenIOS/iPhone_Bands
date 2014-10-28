//
//  WBATrack.h
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import <Foundation/Foundation.h>

@interface WBATrack : NSObject

@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSString *collectionName;
@property (nonatomic, strong) NSString *previewUrlString;
@property (nonatomic, strong) NSString *iTunesUrlString;

@end
