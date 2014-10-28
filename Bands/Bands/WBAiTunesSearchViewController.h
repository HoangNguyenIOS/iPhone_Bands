//
//  WBAiTunesSearchViewController.h
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    WBATrackOptionsButtonIndexPreview,
    WBATrackOptionsButtonIndexOpenIniTunes,
} WBATrackOptionsButtonIndex;

@interface WBAiTunesSearchViewController : UITableViewController <UISearchBarDelegate, UIActionSheetDelegate>

@property (nonatomic, assign) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSString *bandName;
@property (nonatomic, strong) NSMutableArray *firstLettersArray;
@property (nonatomic, strong) NSMutableDictionary *tracksDictionary;

- (void) searchForTracks;

@end
