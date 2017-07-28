//
//  Share+SNS.h
//  selfie_for_music_
//
//  Created by imbc on 2017. 6. 26..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface Share_SNS : NSObject {
    
}

+(SLComposeViewController*)sendToFacebook:(NSString *)shareToText
                                         :(NSString*)shareToURL
                                         :(UIImage*)shareToImg;

+(SLComposeViewController*)sendToTwitter:(NSString *)shareToText
                                        :(NSString*)shareToURL
                                        :(UIImage*)shareToImg;

@end
