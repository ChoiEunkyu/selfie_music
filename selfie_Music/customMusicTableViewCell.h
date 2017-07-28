//
//  customMusicTableViewCell.h
//  selfie_for_music_
//
//  Created by imbc on 2017. 5. 17..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customMusicTableViewCell : UITableViewCell

-(void)setThumbnailWithImage:(NSURL *)thumbnailURL;
-(void)setMusicName:(NSString *)musicName;

@end
