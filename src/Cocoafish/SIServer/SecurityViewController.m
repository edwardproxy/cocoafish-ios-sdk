//
//  SecurityViewController.m
//  Cocoafish-ios-sdk
//
//  Created by EdwardSun on 8/24/12.
//
//

#import "SecurityViewController.h"

@interface SecurityViewController ()

@end

@implementation SecurityViewController

@synthesize webView;
@synthesize indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addSubview:self.indicator];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [self.webView release];
    [self.indicator release];
    [super dealloc];
}

- (void)showPage:(NSString *)which WithURL:(NSString *)authURL consumerKey:(NSString *)consumerKey redirectUri:(NSString *)redirectUri delegate:(id)del
{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(closeWebView)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navItem setRightBarButtonItem:barItem];
    UINavigationBar * navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)] autorelease];
    [navBar setItems:[NSArray arrayWithObject:navItem]];
    [self.view addSubview:navBar];
    [self.view bringSubviewToFront:navBar];
    
    CGRect rect = CGRectMake(0, navBar.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height - navBar.frame.size.height);
    self.webView = [[UIWebView alloc] initWithFrame:rect];
    self.webView.delegate = del;

    [self.view addSubview:self.webView];
    [self.view bringSubviewToFront:self.webView];
    
    NSString *urlString = [[NSString alloc] initWithString:@""];
    if (@"SIGNUP" == which) {
        urlString = [[NSString alloc] initWithFormat:@"http://%@/users/sign_up?client_id=%@&redirect_uri=%@",
                               authURL,
                               consumerKey,
                               redirectUri];
    }
    if (@"SIGNIN" == which) {
        urlString = [[NSString alloc] initWithFormat:@"http://%@/oauth/authorize?client_id=%@&response_type=token&redirect_uri=%@",
                               authURL,
                               consumerKey,
                               redirectUri];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString ]]];
}

- (void)showSignUpPageWithURL:(NSString *)authURL consumerKey:(NSString *)consumerKey redirectUri:(NSString *)redirectUri delegate:(id)del
{
    [self showPage:@"SIGNUP" WithURL:authURL consumerKey:consumerKey redirectUri:redirectUri delegate:del];
}

- (void)showSignInPageWithURL:(NSString *)authURL consumerKey:(NSString *)consumerKey redirectUri:(NSString *)redirectUri delegate:(id)del
{
    [self showPage:@"SIGNIN" WithURL:authURL consumerKey:consumerKey redirectUri:redirectUri delegate:del];
}

- (void)closeWebView
{
//    for (UIView *sub in self.view.superview.subviews) {
//        [sub removeFromSuperview];
//    }
    [UIView beginAnimations:@"ToggleSiblings" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.webView.superview.superview cache:YES];
    [UIView setAnimationDuration:1.0];
    
    [self.view setHidden:YES];
    [self.view release];
    
    [UIView commitAnimations];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end
