//
//  CheckinViewController.m
//  Demo
//
//  Created by Wei Kong on 3/4/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CheckinViewController.h"
#import "CocoaFishLibrary.h"
#import "Cocoafish.h"

// review photo image size
#define PHOTO_MAX_SIZE 800

// define jpeg compression factor
#define JPEG_COMPRESSION 0.5

@interface CheckinViewController()
-(void)preparePhoto:(UIImage *)image;
-(void)dismissKeyboard;
- (void)showImagePicker:(NSInteger)sourceType rectForPopover:(CGRect)rect;
@end

@implementation CheckinViewController

@synthesize delegate = _delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	photoView.delegate = self;
	msgView.delegate = self;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [photoImage release];
    [super dealloc];
}


- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint
{
	[self dismissKeyboard];
	// Show the action sheet if we have a camera
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:nil
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
									  otherButtonTitles:@"Take Photo", @"Choose from Library",nil];
		[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		[actionSheet showInView:[[self view] window]];
		[actionSheet release];
		
		// Otherwise go directly to the photo library chooser
	} else {
		[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary rectForPopover:CGRectZero];
	}
}


#pragma mark -
#pragma mark UIActionSheet Delegate Methods

// action delegate will only be shown on devices with cameras
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self showImagePicker:UIImagePickerControllerSourceTypeCamera rectForPopover:CGRectZero];
	} else if (buttonIndex == 1) {
		[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary rectForPopover:CGRectZero];
	}
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	
	if (photoImage) {
		[photoImage release];
		photoImage = nil;
	}
	
	// get the image
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	//photoImage = [image retain];
	
	// Dismiss the image selection, hide the picker and show the image view with the picked image
	[picker dismissModalViewControllerAnimated:YES];
	
	/*// Write the image to the photo album if we took it with the camera
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		CCLog(@"Start saving fullsize image to the camera roll");
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
		CCLog(@"End saving fullsize image to the camera roll");
	}*/
	
	[self preparePhoto:image];
	
	photoLabel.hidden = YES;
	[photoView setImage:image];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker 
{
	[picker dismissModalViewControllerAnimated:YES];
}

-(void)preparePhoto:(UIImage *)image
{		
    if (photoImage == nil) {
        photoImage = [image retain];
    }
 
}

// Set up the image picker controller and add it to the view
- (void)showImagePicker:(NSInteger)sourceType rectForPopover:(CGRect)rect {
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
	[self presentModalViewController:imagePickerController animated:YES];
	[imagePickerController release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)dismissKeyboard
{
	[msgView resignFirstResponder];
}

-(IBAction)startCheckin
{
	[_delegate startCheckin:self message:msgView.text image:photoImage];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
