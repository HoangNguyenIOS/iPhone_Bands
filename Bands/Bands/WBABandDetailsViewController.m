//
//  ViewController.m
//  Bands
//
//  Created by Thomas Chen on 6/17/14.
//
//

#import "WBABandDetailsViewController.h"


static NSString *bandObjectKey = @"BABandObjectKey";

@implementation WBABandDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //NSLog(@"titleLabel.text = %@", self.titleLabel.text);
    
    //[self loadBandObject];
    
    if (!self.bandObject) {
        self.bandObject = [[WBABand alloc] init];
    }
    
    [self setUserInterfaceValues];
    
    UITapGestureRecognizer *bandImageViewTapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bandImageViewTapDetected)];
    bandImageViewTapGestureRecognizer.numberOfTapsRequired = 1;
    bandImageViewTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.bandImageView addGestureRecognizer:bandImageViewTapGestureRecognizer];
    
    UISwipeGestureRecognizer *bandImageViewSwipeGestureRecognizer =
        [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bandImageViewSwipeDetected)];
    bandImageViewSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.bandImageView addGestureRecognizer:bandImageViewSwipeGestureRecognizer];
    
    self.bandIsChanged = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.bandObject.name = self.nameTextField.text;
    self.bandIsChanged = YES;
    //[self saveBandObject];
    [self.nameTextField resignFirstResponder];
    return YES;
}

// can be removed safely.
// Well, not so, because editing may end without Return being hit.
// So still need this. XC. 2014-06-23.
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.bandObject.name = self.nameTextField.text;
    //[self saveBandObject];
    self.bandIsChanged = YES;
    [self.nameTextField resignFirstResponder];
    return YES;
}


/*
- (void)saveBandObject
{
    NSData *bandObjectData = [NSKeyedArchiver archivedDataWithRootObject:self.bandObject];
    [[NSUserDefaults standardUserDefaults] setObject:bandObjectData forKey:bandObjectKey];
}

- (void)loadBandObject
{
    NSData *bandObjectData = [[NSUserDefaults standardUserDefaults]
                              objectForKey:bandObjectKey];
    if (bandObjectData) {
        self.bandObject = [NSKeyedUnarchiver unarchiveObjectWithData:bandObjectData];
    }
}
 */

- (IBAction)saveButtonTouched:(id)sender
{
    if (self.bandObject.name && self.bandObject.name.length > 0)
    {
        self.saveBand = YES;
        
        if (self.navigationController)
            [self.navigationController popViewControllerAnimated:YES];
        else
            [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *noBandNameAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please supply a name for the band" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noBandNameAlertView show];
    }
}

- (void) setUserInterfaceValues
{
    self.nameTextField.text = self.bandObject.name;
    self.notesTextView.text = self.bandObject.notes;
    self.ratingStepper.value = self.bandObject.rating;
    self.ratingValueLabel.text = [NSString stringWithFormat:@"%g", self.ratingStepper.value];
    self.touringStatusSegmentedControl.selectedSegmentIndex =
        self.bandObject.touringStatus;
    self.haveSeenLiveSwitch.on = self.bandObject.haveSeenLive;
    
    if (self.bandObject.bandImage) {
        self.bandImageView.image = self.bandObject.bandImage;
        self.addPhotoLabel.hidden = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.saveNotesButton.enabled = YES;
    return YES;
}

#pragma mark UITextViewDelegate Methods
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.bandObject.notes = self.notesTextView.text;
    self.bandIsChanged = YES;
    //[self saveBandObject];
    [self.notesTextView resignFirstResponder];
    self.saveNotesButton.enabled = NO;
    return YES;
}

- (IBAction)saveNotesButtonTouched:(id)sender
{
    [self textViewShouldEndEditing:self.notesTextView];
}

- (IBAction)ratingStepperValueChanged:(id)sender
{
    self.ratingValueLabel.text = [NSString stringWithFormat:
                                  @"%g", self.ratingStepper.value];
    self.bandObject.rating = (int)self.ratingStepper.value;
    self.bandIsChanged = YES;
    //[self saveBandObject];
}

- (IBAction)tourStatusSegmentedControlValueChanged:(id)sender
{
    self.bandObject.touringStatus = self.touringStatusSegmentedControl.selectedSegmentIndex;
    self.bandIsChanged = YES;
    //[self saveBandObject];
}

- (IBAction)haveSeenLiveSwitchValueChanged:(id)sender
{
    self.bandObject.haveSeenLive = self.haveSeenLiveSwitch.on;
    self.bandIsChanged = YES;
    //[self saveBandObject];
}


- (IBAction) deleteButtonTouched:(id)sender
{
    UIActionSheet *promptDeleteDataActionSheet =
    [[UIActionSheet alloc] initWithTitle:nil delegate:self  cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:@"Delete Band" otherButtonTitles:nil];
    [promptDeleteDataActionSheet showInView:self.view];
}

- (IBAction)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == WBAActionSheetTagActivity) {
        /*
        if (buttonIndex == WBAActivityButtonIndexEmail) {
            [self emailBandInfo];
        }
        else if (buttonIndex == WBAActivityButtonIndexMessage) {
            [self messageBandInfo];
        }
         */
        //if (buttonIndex == shareActivityButtonIndex) { //??????
        if (buttonIndex == WBAActivityButtonIndexShare) {
            [self shareBandInfo];
        }
        else if (buttonIndex == WBAActivityButtonIndexWebSearch) {
            [self performSegueWithIdentifier:@"webViewSegue" sender:nil];
        }
        else if (buttonIndex == WBAActivityButtonIndexFindLocalRecordStores)
        {
            [self performSegueWithIdentifier:@"mapViewSegue" sender:nil];
        }
        else if (buttonIndex == WBAActivityButtonIndexSearchForTracks)
        {
            [self performSegueWithIdentifier:@"iTunesSearchSegue" sender:nil];
        }
    }
    else if (actionSheet.tag == WBAActionSheetTagChooseImagePickerSource) {
        if (buttonIndex == WBAImagePickerSourceCamera) {
            [self presentCameraImagePicker];
        }
        else if (buttonIndex == WBAImagePickerSourcePhotoLibrary) {
            [self presentPhotoLibraryImagePicker];
        }
    }
    else if (actionSheet.tag == WBAActionSheetTagDeleteBandImage)
    {
        if (actionSheet.destructiveButtonIndex == buttonIndex) {
            self.bandObject.bandImage = nil;
            self.bandImageView.image = nil;
            self.addPhotoLabel.hidden = NO;
            self.bandIsChanged = YES;
        }
    }
    else if (actionSheet.tag == WBAActionSheetTagDeleteBand) {
        if (actionSheet.destructiveButtonIndex == buttonIndex) {
            self.bandObject = nil;
            self.saveBand = NO;
            
            if (self.navigationController)
                [self.navigationController popViewControllerAnimated:YES];
            else
                [self dismissViewControllerAnimated:YES completion:nil];
            //[self setUserInterfaceValues];
        
            //[[NSUserDefaults standardUserDefaults]
            // setObject:nil forKey:bandObjectKey
            // ];
        }
    }
}

- (void) presentCameraImagePicker
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) bandImageViewTapDetected
{
    //NSLog(@"band image tap detected");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *chooseCameraActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take with Camera", @"Choose from Photo Library", nil];
        chooseCameraActionSheet.tag = WBAActionSheetTagChooseImagePickerSource;
        [chooseCameraActionSheet showInView:self.view];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self presentPhotoLibraryImagePicker];
    }
    else
    {
        UIAlertView *photoLibraryErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There are no image in photo library" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [photoLibraryErrorAlert show];
    }
}

- (void) bandImageViewSwipeDetected
{
    //NSLog(@"band image swipe detected");
    
    if (self.bandObject.bandImage) {
        UIActionSheet *deleteBandImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Picture" otherButtonTitles:nil];
        deleteBandImageActionSheet.tag = WBAActionSheetTagDeleteBandImage;
        [deleteBandImageActionSheet showInView:self.view];
    }
}

- (void)presentPhotoLibraryImagePicker
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (selectedImage == NULL) {
        selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    
    self.bandImageView.image = selectedImage;
    self.bandObject.bandImage = selectedImage;
    self.addPhotoLabel.hidden = YES;
    self.bandIsChanged = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)activityButtonTouched:(id)sender
{
    UIActionSheet *activityActionSheet = nil;
    
    /*
    if ([MFMessageComposeViewController canSendText]) {
        activityActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail", @"Message", nil];
    } else {
    
        activityActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail", nil];
    }
    */
    activityActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share", @"Search the Web", @"Find Local Record Stores", @"Search iTunes for Tracks", nil];
    
    activityActionSheet.tag = WBAActionSheetTagActivity;
    [activityActionSheet showInView:self.view];
}

- (void)emailBandInfo
{
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    [mailComposeViewController setSubject:self.bandObject.name];
    [mailComposeViewController setMessageBody:[self.bandObject stringForMessaging] isHTML:NO];
    
    if (self.bandObject.bandImage) {
        [mailComposeViewController addAttachmentData:UIImagePNGRepresentation(self.bandObject.bandImage) mimeType:@"image/png" fileName:@"bandImage"];
        
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (error) {
        UIAlertView *emailErrorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emailErrorAlertView show];
    }
}

- (void)messageBandInfo
{
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;
    
    [messageComposeViewController setSubject:self.bandObject.name];
    [messageComposeViewController setBody:[self.bandObject stringForMessaging]];
    
    if (self.bandObject.bandImage) {
        [messageComposeViewController addAttachmentData:UIImagePNGRepresentation(self.bandObject.bandImage) typeIdentifier:(NSString *)kUTTypePNG filename:@"bandImage.png"];
    }
    
    [self presentViewController:messageComposeViewController animated:YES completion:nil];
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultFailed) {
        UIAlertView *emailErrorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The message failed to send" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emailErrorAlertView show];
    }
}

- (void) shareBandInfo
{
    NSArray *activityItems = [NSArray arrayWithObjects:[self.bandObject stringForMessaging], self.bandObject.bandImage, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [activityViewController setValue:self.bandObject.name forKey:@"subject"];
    
    NSArray *excludeActivityOptions = [NSArray arrayWithObjects:UIActivityTypeAssignToContact, nil];
    [activityViewController setExcludedActivityTypes:excludeActivityOptions];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController class] == [WBAWebViewController class]) {
        WBAWebViewController *webViewController = segue.destinationViewController;
        webViewController.bandName = self.bandObject.name;
    }
    else if ([segue.destinationViewController class] == [WBAiTunesSearchViewController class])
    {
        WBAiTunesSearchViewController *wBAiTunesSearchViewController = segue.destinationViewController;
        wBAiTunesSearchViewController.bandName = self.bandObject.name;
    }
}

@end
