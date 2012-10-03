//
//  ViewController.m
//  TestCocoafish
//
//  Created by EdwardSun on 8/24/12.
//  Copyright (c) 2012 EdwardSun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [Cocoafish initializeWithOauthConsumerKey:@"aQXHHOgUDQY3ULgfPEh9aiVBUiFxtvYK"
//                               consumerSecret:@"xCiGsepUGpqtcGg1RXANVggYcBJACOGF"
//                                 customAppIds:[NSDictionary dictionaryWithObject:@"facebookAppId"
//                                                                          forKey:@"Facebook"]];
//    [Cocoafish initializeWithOauthConsumerKey:@"PwlZOBLGdZ0SxTohTf51mGwrrLivN5CI"
//                               consumerSecret:@"cqSreePIH9pMW37MAFO5epKIqz46oWWD"
//                                 customAppIds:[NSDictionary dictionaryWithObject:@"facebookAppId"
//                                                                          forKey:@"Facebook"]];
//    Cocoafish *sdk = Cocoafish.defaultCocoafish;
//    sdk.authURL = @"security-staging.cloud.appcelerator.com";
//    sdk.apiURL = @"api-staging.cloud.appcelerator.com/v1";
//    sdk.redirectUri = @"http://www.baidu.com";
//    [sdk useThreeLegged:YES];
//    
//    [sdk signInWithView:self.view WithSelector:@selector(callBack:) WithTarget:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)callBack:(NSMutableDictionary *)data
{
    CCRequest *request = [[CCRequest alloc] initWithDelegate:self httpMethod:@"GET" baseUrl:@"users/show/me.json" paramDict:nil];
    [request startAsynchronous];
    [request release];
}

-(void)ccrequest:(CCRequest *)request didSucceed:(CCResponse *)response
{
    NSArray *users = [response getObjectsOfType:[CCUser class]];
    if ([users count] == 1) {
        NSLog(@"Current user is %@", ((CCUser *)[users objectAtIndex:0]).firstName);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email"
                                                            message:((CCUser *)[users objectAtIndex:0]).email
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
//        [alertView release];
    }
}

- (void)ccrequest:(CCRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Code: %d\nMessage: %@", error.code, error.domain);
}

- (IBAction)showView:(id)sender
{
//    [Cocoafish initializeWithOauthConsumerKey:@"PwlZOBLGdZ0SxTohTf51mGwrrLivN5CI"
//                               consumerSecret:@"cqSreePIH9pMW37MAFO5epKIqz46oWWD"
//                                 customAppIds:[NSDictionary dictionaryWithObject:@"facebookAppId"
//                                                                          forKey:@"Facebook"]];
    [Cocoafish initializeWithOauthConsumerKey:@"PwlZOBLGdZ0SxTohTf51mGwrrLivN5CI"];
    Cocoafish *sdk = Cocoafish.defaultCocoafish;
    sdk.authURL = @"security-staging.cloud.appcelerator.com";
    sdk.apiURL = @"api-staging.cloud.appcelerator.com/v1";
    sdk.redirectUri = @"http://www.baidu.com";
    [sdk useThreeLegged:YES];
    
    [sdk signInWithView:self.view WithSelector:@selector(callBack:) WithTarget:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
