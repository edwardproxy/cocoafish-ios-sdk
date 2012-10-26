//
//  Cocoafish.h
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 1/3/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCUser.h"
#import "CCCheckin.h"
#import "CCPlace.h"
#import "CCStatus.h"
#import "FBConnect.h"
#import "CCPhoto.h"
#import "CCKeyValuePair.h"
#import "CCEvent.h"
#import "CCResponse.h"
#import "CCMessage.h"
#import "CCRequest.h"
#import "CCCollection.h"
#import "CCShareRequest.h"
#import "CCChat.h"
#import "CCPost.h"
#import "CCReview.h"
#import "CCPage.h"
#import "CCFeed.h"
#import "CCWhere.h"
#import "NSDate+JSON.h"
#import "CLLocation+JSON.h"

@protocol CCFBSessionDelegate;

@class CCDownloadManager;
@interface Cocoafish : NSObject<FBSessionDelegate, FBRequestDelegate/*, UIWebViewDelegate*/> {
	id<CCFBSessionDelegate> _fbSessionDelegate;
	CCUser *_currentUser;
	NSString *_appKey;
	NSString *_consumerKey;
	NSString *_consumerSecret;
	NSString *_facebookAppId;
	Facebook *_facebook; // handles facebook authentication
	NSString *_cocoafishDir;
	CCDownloadManager *_downloadManager;
    NSString *_deviceToken; // For push notificaiton
    BOOL _loggingEnabled;
    NSDateFormatter *_jsonDateFormatter;
    NSDateFormatter *_exifDateFormatter;
    NSString *_apiUrl;
 //   BOOL _downloadManagerEnabled;
    
    //----------------------------------
    //Added by Edward Sun 2012-08-19
    NSString    *_accessToken;
    NSDate      *_expiresAt;
    NSInteger   _expiresIn;
    BOOL        _isThreeLegged;
    BOOL        _isAuthorized;
    NSString    *_authURL;
    NSString    *_redirectUri;
    //----------------------------------
}

@property(nonatomic, assign) id<CCFBSessionDelegate> _fbSessionDelegate;
@property(nonatomic, retain, readonly) CCDownloadManager *downloadManager;
@property(nonatomic, retain, readonly) NSString *cocoafishDir;
@property(nonatomic, retain, readwrite) NSString *deviceToken;
@property(nonatomic, assign, readwrite) BOOL loggingEnabled;
@property(nonatomic, retain, readwrite) NSDateFormatter *jsonDateFormatter;
@property(nonatomic, retain, readwrite) NSDateFormatter *exifDateFormatter;
@property(nonatomic, retain, readwrite) NSString *apiURL;
@property(nonatomic, retain, readwrite) NSString *redirectUri;
//@property(nonatomic, assign, readwrite) BOOL downloadManagerEnabled;

//----------------------------------
//Added by Edward Sun 2012-08-19
@property (nonatomic, retain, readwrite)  NSString    *accessToken;
@property (nonatomic, retain, readwrite)  NSDate      *expiresAt;
@property (nonatomic, readwrite)          NSInteger   expiresIn;
@property (nonatomic, readwrite)          BOOL        isThreeLegged;
@property (nonatomic, readwrite)          BOOL        isAuthorized;
@property (nonatomic, retain, readwrite)  NSString    *authURL;

- (void)signUpWithView:(UIView *)superView WithSelector:(SEL)sel WithTarget:(id)tar;
- (void)signInWithView:(UIView *)superView WithSelector:(SEL)sel WithTarget:(id)tar;
- (void)signOut;
- (void)useThreeLegged:(BOOL)flag;
- (id)initWithOauthConsumerKey:(NSString *)consumerKey;
+ (void)initializeWithOauthConsumerKey:(NSString *)consumerKey;
//----------------------------------

+(void)initializeWithAppKey:(NSString *)appKey customAppIds:(NSDictionary *)customAppIds;;
+(void)initializeWithOauthConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret customAppIds:(NSDictionary *)customAppIds;;
+(Cocoafish *)defaultCocoafish;

-(NSString *)getAppKey;
-(NSString *)getOauthConsumerKey;
-(NSString *)getOauthConsumerSecret;
-(CCUser *)getCurrentUser;
-(Facebook *)getFacebook;
-(void)setCurrentUser:(NSDictionary *)json;

-(void)facebookAuth:(NSArray *)permissions delegate:(id<CCFBSessionDelegate>)delegate;
-(void)unlinkFromFacebook:(NSError **)error;

@end


// Your program should implement the delegate methods if you use cocoafish
// to perform facebook login
@protocol CCFBSessionDelegate <NSObject>

@optional

/**
 * Called when the user successfully logged in to facebook.
 */
- (void)fbDidLogin;

/**
 * Called when the user dismissed the dialog without logging in to facebook.
 */
- (void)fbDidNotLogin:(BOOL)cancelled error:(NSError *)error;

@end

NSString* encodeToPercentEscapeString(NSString *string);
void CCLog(NSString *format, ...);

