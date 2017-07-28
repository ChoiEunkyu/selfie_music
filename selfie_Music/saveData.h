//
//  saveData.h
//  selfie_for_music_
//
//  Created by imbc on 2017. 5. 12..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface saveData : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *mostEmotion;
@property (nonatomic, strong) NSString *emotionList;
@property (nonatomic, strong) UIImage *targetImage;

@property (nonatomic, strong) NSString *musicName;
@property (nonatomic, strong) NSString *musicId;
@property (nonatomic, strong) NSMutableArray *musicList;
@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic) long musicRow;

@end
