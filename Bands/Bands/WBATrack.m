//
//  WBATrack.m
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import "WBATrack.h"

@implementation WBATrack

- (NSComparisonResult)compare:(WBATrack *)otherObject
{
    return [self.trackName compare:otherObject.trackName];
}

@end
