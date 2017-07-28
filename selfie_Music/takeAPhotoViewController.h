//
//  takeAPhotoViewController.h
//  selfie_Music
//
//  Created by imbc on 2017. 6. 27..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ProjectOxfordFace/MPOFaceServiceClient.h>
#import "ViewController.h"
#import "UIImage+Crop.h"
#import "UIImage+Blur.h"

@interface takeAPhotoViewController : UIViewController <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewResult;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackGround;
@property (weak, nonatomic) IBOutlet UIButton *btnRetakeAPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnRecommendMusic;
@property (strong, nonatomic) UIImage *targetImage;
@property (strong, nonatomic) NSString *userName;

@property (weak, nonatomic) IBOutlet UIView *detectingProcessView;
@property (weak, nonatomic) IBOutlet UILabel *labelDetectProcess;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerDetectProcess;
@property (weak, nonatomic) IBOutlet UILabel *causeOfDetectFailed;
@property (weak, nonatomic) IBOutlet UILabel *labelDetectResult;


- (IBAction)btnHome:(id)sender;
- (IBAction)btnChart:(id)sender;
- (IBAction)btnRetakeAPhoto:(id)sender;
- (IBAction)btnRecommendMusic:(id)sender;

@end
