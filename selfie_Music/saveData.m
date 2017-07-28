//
//  saveData.m
//  selfie_for_music_
//
//  Created by imbc on 2017. 5. 12..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import "saveData.h"

@implementation saveData

-(id)init {
    self = [super init];
    if(self) {
        self.targetImage = [[UIImage alloc] init];
        self.userName = @"";
        self.age = @"";
        self.gender = @"";
        self.mostEmotion = @"";
        self.emotionList = @"";
        
        self.musicName = @"";
        self.musicId = @"";
        self.musicRow = 0;
        self.musicList = [[NSMutableArray alloc] init];
        
        self.userName =@"";
    }
    
    return self;
}

@end
