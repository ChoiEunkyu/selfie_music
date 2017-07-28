//
//  customMusicTableViewCell.m
//  selfie_for_music_
//
//  Created by imbc on 2017. 5. 17..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import "customMusicTableViewCell.h"

@interface customMusicTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *musicTitle;

@end

@implementation customMusicTableViewCell

-(void)setFrame:(CGRect)frame {
    frame.origin.y += 4;
    frame.size.height -= 2*3;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setThumbnailWithImage:(NSURL *)thumbnailURL {
    self.thumbnail.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:thumbnailURL]];
    self.thumbnail.frame = CGRectMake(0,0,_thumbnail.frame.size.width,self.frame.size.height);
}

-(void)setMusicName:(NSString *)musicName {
    self.musicTitle.text =  musicName;
    self.musicTitle.textColor = [UIColor whiteColor];
    self.musicTitle.frame = CGRectMake(_thumbnail.frame.size.width+10, 0, _musicTitle.frame.size.width, self.frame.size.height);

}

@end
