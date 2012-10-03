//
//  UserController.m
//  Demo
//
//  Created by Wei Kong on 10/15/10.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "UserController.h"
#import "LoginViewController.h"
#import "CocoafishLibrary.h"
#import "CCFile.h"

static NSInteger count = 0;

@implementation UserController

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDownloaded:) name:@"DownloadFinished" object:[Cocoafish defaultCocoafish]];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)handleDownloaded:(NSNotification *)notification
{
	[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	CCUser *currentUser = [[Cocoafish defaultCocoafish] getCurrentUser];
	if (!currentUser) {
		// show login window
		LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
		[self.navigationController pushViewController:loginViewController animated:NO];
		[loginViewController release];
		return;
	} else {
		UIBarButtonItem *button;

		// create the logout button	
		button = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(startLogout)];
		self.navigationItem.rightBarButtonItem = button;
		[button release];
        
        /*
         * uploadFile
         */
        UIButton *button_15MB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button_15MB.frame = CGRectMake(50, 100, 100, 50);
        [button_15MB setTitle:@"upload 15MB" forState:UIControlStateNormal];
        [button_15MB addTarget:self action:@selector(uploadFile_15MB) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:button_15MB];
        [self.view bringSubviewToFront:button_15MB];
        
        UIButton *button_10MB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button_10MB.frame = CGRectMake(50, 160, 100, 50);
        [button_10MB setTitle:@"upload 10MB" forState:UIControlStateNormal];
        [button_10MB addTarget:self action:@selector(uploadFile_10MB) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:button_10MB];
        [self.view bringSubviewToFront:button_10MB];
        /*
         * downloadFile
         */
        UIButton *getbutton_15MB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        getbutton_15MB.frame = CGRectMake(180, 100, 120, 50);
        [getbutton_15MB setTitle:@"download 15MB" forState:UIControlStateNormal];
        [getbutton_15MB addTarget:self action:@selector(downloadFile_15MB) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:getbutton_15MB];
        [self.view bringSubviewToFront:getbutton_15MB];
        
        UIButton *getbutton_10MB = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        getbutton_10MB.frame = CGRectMake(180, 160, 120, 50);
        [getbutton_10MB setTitle:@"download 10MB" forState:UIControlStateNormal];
        [getbutton_10MB addTarget:self action:@selector(downloadFile_10MB) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:getbutton_10MB];
        [self.view bringSubviewToFront:getbutton_10MB];
		
	/*	if ([currentUser.facebookAccessToken length] > 0) {
			// create the link with facebook button
			button = [[UIBarButtonItem alloc] initWithTitle:@"Unlink Facebook" style:UIBarButtonItemStylePlain target:self action:@selector(unlinkFromFacebook)];
		} else {
			button = [[UIBarButtonItem alloc] initWithTitle:@"Link Facebook" style:UIBarButtonItemStylePlain target:self action:@selector(linkWithFacebook)];
		}
		self.navigationItem.leftBarButtonItem = button;
		[button release];*/
		
		self.navigationItem.title = [[[Cocoafish defaultCocoafish] getCurrentUser] firstName];
		
	}
	
	[self getUserCheckins];

	
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
#pragma mark getUserCheckins

-(void)getUserCheckins
{
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[[Cocoafish defaultCocoafish] getCurrentUser].objectId, @"user_id", nil];
	
    CCRequest *request = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"GET" baseUrl:@"checkins/search.json" paramDict:paramDict] autorelease];

    [request startAsynchronous];
}


#pragma mark -
#pragma mark logout

// start the login process
- (void)startLogout
{	
    CCRequest *request = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"GET" baseUrl:@"users/logout.json" paramDict:nil] autorelease];
    
    [request startAsynchronous];
}

// to upload a file
- (void)uploadFile_15MB
{    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"file_15MB" ofType:@"dmg"];
    NSData *myFileData = [NSData dataWithContentsOfFile:filePath];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:@"my_file_15MB" forKey:@"name"];
    CCRequest *request = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"POST" baseUrl:@"files/create.json" paramDict:paramDict] autorelease] ;
    [request setData:(NSData *)myFileData withFileName:@"uploadedFile_15MB.dmg" andContentType:@"application/octet-stream" forKey:@"file"];
    [request startAsynchronous];
}
- (void)uploadFile_10MB
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"file_10MB" ofType:@"dmg"];
    NSData *myFileData = [NSData dataWithContentsOfFile:filePath];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramDict setObject:@"my_file_10MB" forKey:@"name"];
    CCRequest *request = [[[CCRequest alloc] initWithDelegate:self httpMethod:@"POST" baseUrl:@"files/create.json" paramDict:paramDict] autorelease] ;
    [request setData:(NSData *)myFileData withFileName:@"uploadedFile_10MB.dmg" andContentType:@"application/octet-stream" forKey:@"file"];
    [request startAsynchronous];
}
- (void)downloadFile_15MB
{
    count = 0;
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://storage.cloud.appcelerator.com/95t3sIWUcFnVPYyw5rM4khYWZCpLT9xn/files/f5/e6/506902919e73795f450003c0/uploadedFile_15MB.dmg"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                       timeoutInterval:kTimeoutInterval];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
//                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                            timeoutInterval:60.0];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [NSURLConnection connectionWithRequest:request delegate:self];
//    NSURLResponse *response = [[NSURLResponse alloc] init];
//    NSError *error = [[NSError alloc] init];
//    
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//    int responseStatusCode = [httpResponse statusCode];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download"
//                                                    message:[NSString stringWithFormat:@"%d", responseStatusCode]
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//    if (data == nil) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download"
//                                                        message:@"fail"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    // should be 14643787 bytes
//    UIAlertView *alertDone = [[UIAlertView alloc] initWithTitle:@"download" message:[NSString stringWithFormat:@"done\n size: %d", data.length] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertDone show];
}
- (void)downloadFile_10MB
{
    count = 0;
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://storage.cloud.appcelerator.com/95t3sIWUcFnVPYyw5rM4khYWZCpLT9xn/files/aa/21/506928ab6115402354000267/uploadedFile_10MB.dmg"];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request startAsynchronous];
    
    //    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
    //                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
    //                                                       timeoutInterval:kTimeoutInterval];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
//                                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                             timeoutInterval:60.0];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
//    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download"
                                                    message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    if (data == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download"
                                                        message:@"fail"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    // should be 23629311 bytes
    // should be 10403840 bytes
    UIAlertView *alertDone = [[UIAlertView alloc] initWithTitle:@"download" message:[NSString stringWithFormat:@"done\n size: %d", data.length] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDone show];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download"
                                                    message:[NSString stringWithFormat:@"%d", responseStatusCode]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    count += data.length;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download" message:@"fail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // should be 23629311 bytes or 14643787 bytes or 10403840 bytes
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download" message:[NSString stringWithFormat:@"done\n size: %d", count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // should be 23629311 bytes or 14643787 bytes or 10403840 bytes
    NSData *responseData = [request responseData];
    NSLog(@"size: %d Bytes", responseData.length);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download" message:[NSString stringWithFormat:@"done\n size: %d", responseData.length] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"download" message:@"fail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    int statusCode = [request responseStatusCode];
    NSString *statusMessage = [request responseStatusMessage];
    NSLog(@"status: %d\nmessage: %@", statusCode, statusMessage);
}

// unlink from facebook
-(void)unlinkFromFacebook
{
	NSError *error;
	[[Cocoafish defaultCocoafish] unlinkFromFacebook:&error];
	if (error == nil) {
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Link With Facebook" style:UIBarButtonItemStylePlain target:self action:@selector(linkWithFacebook)];
		self.navigationItem.leftBarButtonItem = button;
		[button release];
	}
}

// link with facebook account
- (void)linkWithFacebook
{	
    if ([[Cocoafish defaultCocoafish] getFacebook] == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error" 
                              message:@"Please initialize Cocoafish with a valid facebook id first!"
                              delegate:self 
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
	[[Cocoafish defaultCocoafish] facebookAuth:[NSArray arrayWithObjects:@"publish_stream", @"email", @"read_friendlists", @"offline_access", @"user_photos", nil] delegate:self];
}

#pragma mark -
#pragma mark CCRequest delegate methods
// successful logout
-(void)ccrequest:(CCRequest *)request didSucceed:(CCResponse *)response
{	
    if ([response.meta.methodName isEqualToString:@"logoutUser"]) {
        // show login window
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:NO];
        [userCheckins release];
        userCheckins = nil;
        [loginViewController release];
    } else if ([response.meta.methodName isEqualToString:@"searchCheckins"]) {
        @synchronized (self) {
            [userCheckins release];
            userCheckins = [[response getObjectsOfType:[CCCheckin class]] retain];
            [self.tableView reloadData];
        }
    } else if ([response.meta.methodName isEqualToString:@"createFile"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email"
                                                            message:@"Upload Done"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else if ([response.meta.methodName isEqualToString:@"showFile"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"File"
                                                            message:@"Download Done"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
	
}

-(void)ccrequest:(CCRequest *)request didFailWithError:(NSError *)error
{

	NSString *msg = [NSString stringWithFormat:@"%@.",[error localizedDescription]];
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Error" 
						  message:msg
						  delegate:self 
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [userCheckins count];
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
	CCCheckin *checkin = [userCheckins objectAtIndex:indexPath.row];
	cell.imageView.image = nil;
    cell.imageView.image = [checkin.photo getImageForPhotoSize:@"thumb_100"];
	
    cell.textLabel.text = checkin.message;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [[checkin place] name], timeElapsedFrom([checkin createdAt])];
	
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
	[userCheckins release];
    [super dealloc];
}


#pragma -
#pragma mark CCFBSessionDelegate methods
-(void)fbDidLogin
{
	NSLog(@"fbDidLogin");
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Unlink Facebook" style:UIBarButtonItemStylePlain target:self action:@selector(unlinkFromFacebook)];
	self.navigationItem.leftBarButtonItem = button;
	[button release];

}

-(void)fbDidNotLogin:(BOOL)cancelled error:(NSError *)error
{
	if (error == nil) {
		// user failed to login to facebook or cancelled the login
		return;
	}
	NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]];
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Failed to link with Facebook" 
						  message:msg
						  delegate:self 
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
@end


