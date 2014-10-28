//
//  WBAWebViewController.h
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    WBAWebViewActionButtonIndexOpenInSafari,
} WBAWebViewActionButtonIndex;

@interface WBAWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *bandName;
@property (nonatomic, assign) int webViewLoadCount;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *stopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *forwardButton;

@property (nonatomic, strong) NSString *recordStoreUrlString;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)stopButtonTouched:(id)sender;
- (IBAction)refreshButtonTouched:(id)sender;
- (IBAction)forwardButtonTouched:(id)sender;
- (IBAction)webViewActionButtonTouched:(id)sender;

- (void) setToolbarButtons;

- (void) webViewLoadComplete;

@end
