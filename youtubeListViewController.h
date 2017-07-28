//
//  youtubeListViewController.h
//  selfie_Music
//
//  Created by imbc on 2017. 6. 28..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "UIImage+Blur.h"
#import "Share+SNS.h"

@interface youtubeListViewController : UIViewController <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, YTPlayerViewDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIImageView *backBlurImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelMusicTitle;
@property (weak, nonatomic) IBOutlet UITableView *listOfMusicTableView;

@property (strong, nonatomic) NSMutableArray *savedMusicDataList;
@property (strong, nonatomic) UIImage *bgImg;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *mostEmotion;
@property (strong, nonatomic) NSString *emotionList;
@property (strong, nonatomic) NSString *userName;

@property int checkforAge;
@property NSURLRequest *request;
@property NSMutableArray *musicList;

@property NSString *playListId;
@property NSString *dateString;

//@property int playRow;

- (IBAction)btnChart:(id)sender;
- (IBAction)btnHome:(id)sender;
- (IBAction)btnRetakeAPhoto:(id)sender;
- (IBAction)btnShare:(id)sender;

- (IBAction)btnPrev:(id)sender;
- (IBAction)btnNext:(id)sender;



@end
