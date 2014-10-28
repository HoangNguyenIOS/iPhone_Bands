//
//  WBABandsListTableViewController.m
//  Bands
//
//  Created by Thomas Chen on 6/21/14.
//
//

#import "WBABandsListTableViewController.h"
#import "WBABand.h"
#import "WBABandDetailsViewController.h"

static NSString *bandsDictionaryKey = @"BABandsDictionaryKey";

@implementation WBABandsListTableViewController

- (void)addNewBand:(WBABand *)bandObject
{
    NSString *bandNameFirstLetter = [bandObject.name substringToIndex:1];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:bandNameFirstLetter];
    
    if (! bandsForLetter) {
        bandsForLetter = [NSMutableArray array];
    }
    
    [bandsForLetter addObject:bandObject];
    [bandsForLetter sortUsingSelector:@selector(compare:)];
    [self.bandsDictionary setObject:bandsForLetter forKey:bandNameFirstLetter];
    
    if (! [self.firstLettersArray containsObject:bandNameFirstLetter])
    {
        [self.firstLettersArray addObject:bandNameFirstLetter];
        [self.firstLettersArray sortUsingSelector:@selector(compare:)];
    }
                                                            
    [self saveBandsDictionary];
}

- (void)saveBandsDictionary
{
    //UIAlertView *saveBandAlertView = [[UIAlertView alloc] initWithTitle:@"SaveBandsDictionary" message:@"Saving.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[saveBandAlertView show];

    NSData *bandsDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:self.bandsDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:bandsDictionaryData forKey:bandsDictionaryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadBandsDictionary
{
    NSData *bandsDictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:bandsDictionaryKey];
    
    if (bandsDictionaryData) {
        self.bandsDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:bandsDictionaryData];
        self.firstLettersArray = [NSMutableArray arrayWithArray:self.bandsDictionary.allKeys];
        [self.firstLettersArray sortUsingSelector:@selector(compare:)];
    }
    else {
        self.bandsDictionary = [NSMutableDictionary dictionary];
        self.firstLettersArray = [NSMutableArray array];
    }
}


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
    
    [self loadBandsDictionary];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.clearsSelectionOnViewWillAppear = NO;
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
    return self.bandsDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *firstLetter = [self.firstLettersArray objectAtIndex:section];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:firstLetter];
    return bandsForLetter.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *firstLetter = [self.firstLettersArray objectAtIndex:indexPath.section];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:firstLetter];
    WBABand *bandObject = [bandsForLetter objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = bandObject.name;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteBandAtIndexPath: indexPath];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void) deleteBandAtIndexPath:(NSIndexPath *) indexPath
{
    NSString *sectionHeader = [self.firstLettersArray objectAtIndex:indexPath.section];
    NSMutableArray *bandsForLetter = [self.bandsDictionary objectForKey:sectionHeader];
    [bandsForLetter removeObjectAtIndex:indexPath.row];
    
    if (bandsForLetter.count == 0) {
        [self.firstLettersArray removeObject:sectionHeader];
        [self.bandsDictionary removeObjectForKey:sectionHeader];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [self.bandsDictionary setObject:bandsForLetter forKey:sectionHeader];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self saveBandsDictionary];
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.bandDetailsViewController) {
        
        /*
       if (self.bandDetailsViewController.saveBand) {
          [self addNewBand:self.bandDetailsViewController.bandObject];
           [self.tableView reloadData];
       }
       self.bandDetailsViewController = nil;
         */
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        if (self.bandDetailsViewController.saveBand)
        {
            if (selectedIndexPath) {
                // If nothing is changed, do not save.
                // This can be more efficient. XC. 2014-06-23
                if (self.bandDetailsViewController.bandIsChanged) {
                    [self updateBandObject:self.bandDetailsViewController.bandObject atIndexPath:selectedIndexPath];
                }
                [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
            }
            else
                [self addNewBand:self.bandDetailsViewController.bandObject];
            [self.tableView reloadData];
        }
        else if (selectedIndexPath) {
            [self deleteBandAtIndexPath:selectedIndexPath];
        }
        
        self.bandDetailsViewController = nil;
    }
}

- (void) updateBandObject:(WBABand *)bandObject atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSString *sectionHeader = [self.firstLettersArray objectAtIndex:selectedIndexPath.section];
    NSMutableArray *bandsForSection = [self.bandsDictionary objectForKey:sectionHeader];
    [bandsForSection removeObjectAtIndex:indexPath.row];
    [bandsForSection addObject:bandObject];
    [bandsForSection sortUsingSelector:@selector(compare:)];
    [self.bandsDictionary setObject:bandsForSection forKey:sectionHeader];
    [self saveBandsDictionary];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //UIAlertView *x = [[UIAlertView alloc] initWithTitle:@"prepareForSegue" message:@"x" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
    //[x show];
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSString *sectionHeader = [self.firstLettersArray objectAtIndex:selectedIndexPath.section];
    NSMutableArray *bandsForSection = [self.bandsDictionary objectForKey:sectionHeader];
    WBABand *bandObject = [bandsForSection objectAtIndex:selectedIndexPath.row];
    self.bandDetailsViewController = segue.destinationViewController;
    self.bandDetailsViewController.bandObject = bandObject;

    // If have this, it'll always save, and slows down response.
    // It should save only when user touches the "Save" button in the
    // DetailsView.
    // However, current implementation is that, if this is NO, then
    // the band will be deleted. SHould consider use another variable,
    // such as "bandChanged" for this purpose.
    self.bandDetailsViewController.saveBand = YES;
}

- (IBAction) addBandTouched:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.bandDetailsViewController = (WBABandDetailsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"bandDetails"];
    
    [self presentViewController:self.bandDetailsViewController animated:YES completion:nil];
}

- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.firstLettersArray objectAtIndex:section];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.firstLettersArray;
}

- (int)tableView: (UITableView *) tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.firstLettersArray indexOfObject:title];
}

@end
