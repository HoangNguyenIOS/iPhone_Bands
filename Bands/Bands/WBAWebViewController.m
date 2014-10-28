//
//  WBAWebViewController.m
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import "WBAWebViewController.h"

@interface WBAWebViewController ()

@end

@implementation WBAWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webViewLoadCount = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.bandName)
    {
        NSString *urlEncodedBandName = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.bandName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
        NSString *yahooSearchString = [NSString stringWithFormat:@"http://search.yahoo.com/search?p=%@", urlEncodedBandName];
        NSURL *yahooSearchUrl = [NSURL URLWithString: yahooSearchString];
        NSURLRequest *yahooSearchUrlRequest = [NSURLRequest requestWithURL:yahooSearchUrl];

        [self.webView loadRequest:yahooSearchUrlRequest];
    } else if (self.recordStoreUrlString) {
        NSURL *recordStoreUrl = [NSURL URLWithString:self.recordStoreUrlString];
        NSURLRequest *recordStoreUrlRequest = [NSURLRequest requestWithURL:recordStoreUrl];
        
        [self.webView loadRequest:recordStoreUrlRequest];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    self.webViewLoadCount ++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self setToolbarButtons];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    self.webViewLoadCount --;
    
    if (self.webViewLoadCount == 0) {
        [self webViewLoadComplete];
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.webViewLoadCount --;
    
    if (self.webViewLoadCount == 0) {
        [self webViewLoadComplete];
    }
}

- (void) setToolbarButtons
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    self.stopButton.enabled = self.webView.isLoading;
    self.refreshButton.enabled = ! self.webView.isLoading;
}

- (void) webViewLoadComplete
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setToolbarButtons];
}

- (IBAction)backButtonTouched:(id)sender
{
    //NSLog(@"backButtonTouched");
    [self.webView goBack];
}

- (IBAction)stopButtonTouched:(id)sender
{
    //NSLog(@"stopButtonTouched");
    [self.webView stopLoading];
    self.webViewLoadCount = 0;
    [self webViewLoadComplete];
}

- (IBAction)refreshButtonTouched:(id)sender
{
    //NSLog(@"refreshButtonTouched");
    [self.webView loadRequest:self.webView.request];
}

- (IBAction)forwardButtonTouched:(id)sender
{
    //NSLog(@"forwardButtonTouched");
    [self.webView goForward];
}

- (IBAction)webViewActionButtonTouched:(id)sender
{
    UIActionSheet *webViewActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    [webViewActionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == WBAWebViewActionButtonIndexOpenInSafari)
    {
        [[UIApplication sharedApplication] openURL:self.webView.request.mainDocumentURL];
    }
}


@end

