//
//  WBAiTunesSearchViewController.m
//  Bands
//
//  Created by Thomas Chen on 6/23/14.
//
//

#import "WBAiTunesSearchViewController.h"
#import "WBATrack.h"
#import <MediaPlayer/MediaPlayer.h>

@interface WBAiTunesSearchViewController ()

@end

@implementation WBAiTunesSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstLettersArray = [NSMutableArray array];
    self.tracksDictionary = [NSMutableDictionary dictionary];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.searchBar.text = self.bandName;
    [self searchForTracks];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"Search Button tapped");
    [self searchForTracks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.firstLettersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *firstLetter = [self.firstLettersArray objectAtIndex:section];
    NSArray *tracksWithFirstLetter = [self.tracksDictionary objectForKey:firstLetter];
    return tracksWithFirstLetter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"trackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *firstLetter = [self.firstLettersArray objectAtIndex:indexPath.section];
    NSArray *tracksWithFirstLetter = [self.tracksDictionary objectForKey:firstLetter];
    WBATrack *track = [tracksWithFirstLetter objectAtIndex:indexPath.row];
    
    cell.textLabel.text = track.trackName;
    cell.detailTextLabel.text = track.collectionName;
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.firstLettersArray objectAtIndex:section];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.firstLettersArray;
}

- (int)tableView: (UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.firstLettersArray indexOfObject:title];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) searchForTracks
{
    [self.searchBar resignFirstResponder];
    
    NSString *bandName = self.searchBar.text;
    NSString *urlEncodedBandName = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)bandName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    NSString *iTunesSearchUrlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?media=music&entity=musicTrack&term=%@", urlEncodedBandName];
    NSURL *iTunesSearchUrl = [NSURL URLWithString:iTunesSearchUrlString];
    NSURLRequest *iTunesSearchUrlRequest = [NSURLRequest requestWithURL:iTunesSearchUrl];
    
    NSURLSession *sharedUrlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *searchiTunesTask = [sharedUrlSession dataTaskWithRequest:iTunesSearchUrlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (error) {
                UIAlertView *searchAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [searchAlertView show];
            }
            else
            {
                //NSString *resultsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //NSLog(@"Search results: %@", resultsString);
                
                NSError *jsonParseError = nil;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];
                
                if (jsonParseError) {
                    UIAlertView *jsonParseErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:jsonParseError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [jsonParseErrorAlert show];
                }
                else {
                    //for (NSString * key in jsonDictionary.keyEnumerator)
                    //{
                    //    NSLog(@"First level key: %@", key);
                    //}
                    
                    [self.firstLettersArray removeAllObjects];
                    [self.tracksDictionary removeAllObjects];
                    
                    NSArray *searchResultsArray = [jsonDictionary objectForKey:@"results"];
                    for (NSDictionary *trackInfoDictionary in searchResultsArray)
                    {
                        WBATrack *track = [[WBATrack alloc] init];
                        track.trackName = [trackInfoDictionary objectForKey:@"trackName"];
                        track.collectionName = [trackInfoDictionary objectForKey:@"collectionName"];
                        track.previewUrlString = [trackInfoDictionary objectForKey:@"previewUrl"];
                        track.iTunesUrlString = [trackInfoDictionary objectForKey:@"trackViewUrl"];
                        
                        NSString *trackFirstLetter = [track.trackName substringToIndex:1];
                        NSMutableArray *tracksWithFirstLetter = [self.tracksDictionary objectForKey:trackFirstLetter];
                        
                        if (! tracksWithFirstLetter) {
                            tracksWithFirstLetter = [NSMutableArray array];
                            [self.firstLettersArray addObject:trackFirstLetter];
                        }
                             
                        [tracksWithFirstLetter addObject:track];
                        [tracksWithFirstLetter sortUsingSelector:@selector(compare:)];
                        [self.tracksDictionary setObject:tracksWithFirstLetter forKey:trackFirstLetter];
                    }
                    
                    [self.firstLettersArray sortUsingSelector:@selector(compare:)];
                    [self.tableView reloadData];
                }
            }
        });
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [searchiTunesTask resume];
}


- (void) tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *trackActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Preview Track", @"Open in iTunes", nil];
    [trackActionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    NSString *trackFirstLetter = [self.firstLettersArray objectAtIndex:selectedIndexPath.section];
    
    NSArray *tracksWithFirstLetter = [self.tracksDictionary objectForKey:trackFirstLetter];
    
    WBATrack *trackObject = [tracksWithFirstLetter objectAtIndex:selectedIndexPath.row];
    
    if (buttonIndex == WBATrackOptionsButtonIndexPreview) {
        NSURL *trackPreviewURL = [NSURL URLWithString:trackObject.previewUrlString];
        //NSLog(@"url: %@", trackObject.previewUrlString);
        
        MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:trackPreviewURL];
        
        [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
    }
    else if (buttonIndex == WBATrackOptionsButtonIndexOpenIniTunes) {
        NSURL *iTunesURL = [NSURL URLWithString:trackObject.iTunesUrlString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
    }
}

@end
