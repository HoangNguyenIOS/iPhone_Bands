//
//  WBABandsListTableViewController.h
//  Bands
//
//  Created by Thomas Chen on 6/21/14.
//
//

#import <UIKit/UIKit.h>

@class WBABand, WBABandDetailsViewController;
@interface WBABandsListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *bandsDictionary;
@property (nonatomic, strong) NSMutableArray *firstLettersArray;
@property (nonatomic, strong) WBABandDetailsViewController *bandDetailsViewController;

///- (void) addNewBand:(WBABand *) WBABand;
- (void) addNewBand:(WBABand *) bandObject;
- (void) saveBandsDictionary;
- (void) loadBandsDictionary;
- (void) deleteBandAtIndexPath:(NSIndexPath *)indexPath;
- (void) updateBandObject:(WBABand *)bandObject atIndexPath:(NSIndexPath *)indexPath;

-(IBAction)addBandTouched:(id)sender;

@end
