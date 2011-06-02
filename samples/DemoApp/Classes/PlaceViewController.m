//
//  PlaceViewController.m
//  Demo
//
//  Created by Wei Kong on 10/17/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "PlaceViewController.h"
#import "CheckinViewController.h"
#import "CocoaFishLibrary.h"

@implementation PlaceViewController

@synthesize place;
@synthesize placeCheckins;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	if (placeCheckins == nil) {
		placeCheckins = [[NSMutableArray alloc] init];
	}
	if (_ccNetworkManager == nil) {
		_ccNetworkManager = [[CCNetworkManager alloc] initWithDelegate:self];
	}
	[_ccNetworkManager searchCheckins:place page:CC_FIRST_PAGE perPage:CC_DEFAULT_PER_PAGE];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloaded:) name:@"DownloadFinished" object:[Cocoafish defaultCocoafish]];

    self.navigationItem.title = place.name;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)handleDownloaded:(NSNotification *)notification
{
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark CCNetworkManager Delegate Methods
-(void)networkManager:(CCNetworkManager *)networkManager didGet:(NSArray *)objectArray objectType:(Class)objectType pagination:(CCPagination *)pagination
{
    if (objectType == [CCCheckin class]) {

        @synchronized(self) {
            self.placeCheckins = nil;
            placeCheckins = [[NSMutableArray alloc] initWithArray:objectArray];
        }
        [self.tableView reloadData];
    }
	
}

-(void)showCheckin
{
	CheckinViewController *controller = [[CheckinViewController alloc] initWithNibName:@"CheckinViewController" bundle:nil];
	controller.delegate = self;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void)startCheckin:(CheckinViewController *)controller message:(NSString *)message image:(CCPhotoAttachment *)image
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:message, place.objectId, nil] forKeys:[NSArray arrayWithObjects:@"message", @"place_id", nil]];
    CCRequest *request = [Cocoafish restRequest:self httpMethod:@"POST" baseUrl:@"checkins/create.json" paramDict:paramDict attachment:image];
    [request startAsynchronous];
	//[_ccNetworkManager createCheckin:place message:message image:image];
}

#pragma CCRequestDelegate Methods
-(void)request:(CCRequest *)request didSucceed:(CCResponse *)response
{
    if ([response.meta.method isEqualToString:@"createCheckin"]) {
        NSArray *checkins = [response getObjectsOfType:[CCCheckin class]];
        CCCheckin *checkin = nil;
        if ([checkins count] == 1) {
            checkin = [checkins objectAtIndex:0];
        }
        // update user score
        NSString *score_key = [NSString stringWithFormat:@"%@_score",[[Cocoafish defaultCocoafish] getCurrentUser].email];
        [_ccNetworkManager incrBy:score_key value:5];
        
        if (checkin) {
            @synchronized(self) {
                [placeCheckins insertObject:checkin atIndex:0];
            }
            
            [self.tableView reloadData];
        }
        
    }
}
-(void)networkManager:(CCNetworkManager *)networkManager didUpdate:(NSArray *)objectArray objectType:(Class)objectType
{
    CCKeyValuePair *keyval;
    if (objectType == [CCKeyValuePair class]) {
        keyval = [objectArray objectAtIndex:0];
    }
    UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Yay!" 
						  message:[NSString stringWithFormat:@"You just earned 5 points and your total score is %@", keyval.value]
						  delegate:self 
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
    
}

-(void)networkManager:(CCNetworkManager *)networkManager didCreate:(NSArray *)objectArray objectType:(Class)objectType
{
    CCCheckin *checkin;
    if (objectType == [CCCheckin class]) {
        checkin = [objectArray objectAtIndex:0];;
    }
    // update user score
    NSString *score_key = [NSString stringWithFormat:@"%@_score",[[Cocoafish defaultCocoafish] getCurrentUser].email];
    [_ccNetworkManager incrBy:score_key value:5];
     
	if (checkin) {
		@synchronized(self) {
			[placeCheckins insertObject:checkin atIndex:0];
		}
	
		[self.tableView reloadData];
	}
   
	
}


- (void)networkManager:(CCNetworkManager *)networkManager didFailWithError:(NSError *)error
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Error!" 
						  message:[error localizedDescription]
						  delegate:self 
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if ([[Cocoafish defaultCocoafish] getCurrentUser] != nil) {
		UIBarButtonItem *checkinButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkin" style:UIBarButtonItemStylePlain target:self action:@selector(showCheckin)];
		self.navigationItem.rightBarButtonItem = checkinButton;
		[checkinButton release];
	}
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [placeCheckins count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
	CCCheckin *checkin = [placeCheckins objectAtIndex:indexPath.row];
	cell.imageView.image = nil;
    cell.imageView.image = [checkin.photo getImage:CC_THUMB_100];
		
	cell.textLabel.text = checkin.message;
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Checked in %@", [[checkin user] firstName], timeElapsedFrom([checkin createdAt])];
	
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (void)dealloc {
    [_ccNetworkManager release];
    [super dealloc];
}


@end

