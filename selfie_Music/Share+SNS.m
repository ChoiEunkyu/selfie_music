//
//  Share+SNS.m
//  selfie_for_music_
//
//  Created by imbc on 2017. 6. 26..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import "Share+SNS.h"

@implementation Share_SNS


//FaceBook
+ (SLComposeViewController*)sendToFacebook:(NSString*)shareToText
                                          :(NSString*)shareToURL
                                          :(UIImage*)shareToImg {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        shareToURL = [shareToURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [controller setInitialText:shareToText];
        [controller addURL:[NSURL URLWithString:shareToURL]];
        [controller addImage:shareToImg];
        
        
        return controller;
    }
    return nil;
}

//Twitter
+ (SLComposeViewController*)sendToTwitter:(NSString *)shareToText
                                         :(NSString*)shareToURL
                                         :(UIImage*)shareToImg {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        shareToURL = [shareToURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [controller setInitialText:shareToText];
        [controller addURL:[NSURL URLWithString:shareToURL]];
        [controller addImage:shareToImg];
        return controller;
    }
    return nil;
}
@end
