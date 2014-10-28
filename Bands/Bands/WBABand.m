//
//  WBABand.m
//  Bands
//
//  Created by Thomas Chen on 6/17/14.
//
//

#import "WBABand.h"

static NSString *nameKey = @"BANameKey";
static NSString *notesKey = @"BANotesKey";
static NSString *ratingKey = @"BARatingKey";
static NSString *tourStatusKey = @"BATourStatusKey";
static NSString *haveSeenLiveKey = @"BAHaveSeenLiveKey";
static NSString *bandImageKey = @"BABandImageKey";

@implementation WBABand

-(id) initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    self.name = [coder decodeObjectForKey:nameKey];
    self.notes = [coder decodeObjectForKey:notesKey];
    self.rating = [coder decodeIntegerForKey:ratingKey];
    self.touringStatus = [coder decodeIntegerForKey:tourStatusKey];
    self.haveSeenLive = [coder decodeBoolForKey:haveSeenLiveKey];

    NSData *bandImageData = [coder decodeObjectForKey:bandImageKey];
    if (bandImageData) {
        self.bandImage = [UIImage imageWithData:bandImageData];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:nameKey];
    [coder encodeObject:self.notes forKey:notesKey];
    [coder encodeInteger:self.rating forKey:ratingKey];
    [coder encodeInteger:self.touringStatus forKey:tourStatusKey];
    [coder encodeBool:self.haveSeenLive forKey:haveSeenLiveKey];
    
    NSData *bandImageData = UIImagePNGRepresentation(self.bandImage);
    [coder encodeObject:bandImageData forKey:bandImageKey];
}

- (NSComparisonResult)compare:(WBABand *)otherObject
{
    return [self.name compare:otherObject.name];
}

- (NSString *)stringForMessaging
{
    NSMutableString *messageString = [NSMutableString stringWithFormat:@"%@\n", self.name];
    
    if (self.notes.length > 0) {
        [messageString appendString:[NSString stringWithFormat:@"Notes: %@\n", self.notes]];
    } else {
        [messageString appendString:@"Notes: \n"];
    }
    
    [messageString appendString:[NSString stringWithFormat:@"Rating: %d\n", self.rating]];
    
    if (self.touringStatus == WBATouringStatusOnTour) {
        [messageString appendString:@"Touring Status: On Tour\n"];
    }
    else if (self.touringStatus == WBATouringStatusOffTour) {
        [messageString appendString:@"Touring Status: Off Tour\n"];
    }
    else if (self.touringStatus == WBATouringStatusDisbanded) {
        [messageString appendString:@"Touring Status: Disbanded\n"];
    }
    
    if (self.haveSeenLive) {
        [messageString appendString:@"Have Seen Live: Yes\n"];
    } else {
        [messageString appendString:@"Have Seen Live: No\n"];
    }
    
    return messageString;
}

@end
