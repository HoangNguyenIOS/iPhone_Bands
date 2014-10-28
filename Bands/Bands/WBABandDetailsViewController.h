//
//  ViewController.h
//  Bands
//
//  Created by Thomas Chen on 6/17/14.
//
//

//#import <UIKit/UIKit.h>
#import "WBABand.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "WBAWebViewController.h"
#import "WBAiTunesSearchViewController.h"


typedef enum {
    WBAActionSheetTagDeleteBand,
    WBAActionSheetTagDeleteBandImage,
    WBAActionSheetTagChooseImagePickerSource,
    WBAActionSheetTagActivity,
} WBAActionSheetTag;

typedef enum {
    WBAImagePickerSourceCamera,
    WBAImagePickerSourcePhotoLibrary,
} WBAImagePickerSource;

typedef enum {
    //WBAActivityButtonIndexEmail,
    //WBAActivityButtonIndexMessage,
    WBAActivityButtonIndexShare,
    WBAActivityButtonIndexWebSearch,
    WBAActivityButtonIndexFindLocalRecordStores,
    WBAActivityButtonIndexSearchForTracks,
} WBAActivityButtonIndex;

@interface WBABandDetailsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) WBABand *bandObject;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextView *notesTextView;
@property (nonatomic, weak) IBOutlet UIButton *saveNotesButton;
@property (nonatomic, weak) IBOutlet UIStepper *ratingStepper;
@property (nonatomic, weak) IBOutlet UILabel *ratingValueLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *touringStatusSegmentedControl;
@property (nonatomic, weak) IBOutlet UISwitch *haveSeenLiveSwitch;
@property (nonatomic, assign) BOOL saveBand;
@property (nonatomic, assign) IBOutlet UIImageView *bandImageView;
@property (nonatomic, assign) IBOutlet UILabel *addPhotoLabel;

// If nothing is changed, do not save.
// This can be more efficient. XC. 2014-06-23
@property (nonatomic, assign) BOOL bandIsChanged;
           

- (IBAction)saveNotesButtonTouched:(id)sender;
- (IBAction)ratingStepperValueChanged:(id)sender;
- (IBAction)tourStatusSegmentedControlValueChanged:(id)sender;
- (IBAction)haveSeenLiveSwitchValueChanged:(id)sender;
- (IBAction)deleteButtonTouched:(id)sender;
- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)activityButtonTouched:(id)sender;

//- (void) saveBandObject;
//- (void) loadBandObject;
- (void) setUserInterfaceValues;

- (void) bandImageViewTapDetected;
- (void) bandImageViewSwipeDetected;
- (void) presentPhotoLibraryImagePicker;
- (void) presentCameraImagePicker;
- (void) emailBandInfo;
- (void) messageBandInfo;
- (void) shareBandInfo;

@end
