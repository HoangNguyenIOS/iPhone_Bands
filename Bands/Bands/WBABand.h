//
//  WBABand.h
//  Bands
//
//  Created by Thomas Chen on 6/17/14.
//
//

#import <Foundation/Foundation.h>


typedef enum {
    WBATouringStatusOnTour,
    WBATouringStatusOffTour,
    WBATouringStatusDisbanded,
} WBATouringStatus;


@interface WBABand : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, assign) int rating;
@property (nonatomic, assign) WBATouringStatus touringStatus;
@property (nonatomic, assign) BOOL haveSeenLive;
@property (nonatomic, strong) UIImage *bandImage;

- (NSString *)stringForMessaging;

@end
