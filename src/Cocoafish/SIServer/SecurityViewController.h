//
//  SecurityViewController.h
//  Cocoafish-ios-sdk
//
//  Created by EdwardSun on 8/24/12.
//
//

#import <UIKit/UIKit.h>

@interface SecurityViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (void)showSignUpPageWithURL:(NSString *)authURL consumerKey:(NSString *)consumerKey redirectUri:(NSString *)redirectUri delegate:(id)del;
- (void)showSignInPageWithURL:(NSString *)authURL consumerKey:(NSString *)consumerKey redirectUri:(NSString *)redirectUri delegate:(id)del;
- (void)showPage:(NSString *)which WithURL:(NSString *)authURL consumerKey:(NSString *)consumerKey redirectUri:(NSString *)redirectUri delegate:(id)del;

@end
