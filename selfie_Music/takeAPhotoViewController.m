
//
//  takeAPhotoViewController.m
//  selfie_Music
//
//  Created by imbc on 2017. 6. 27..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import "takeAPhotoViewController.h"
#import "youtubeListViewController.h"
#import <ProjectOxfordFace/MPOFaceServiceClient.h>

@interface MPODetectionFaceObject : NSObject
@property (nonatomic, strong) UIImage *croppedFaceImage;
@property (nonatomic, strong) NSString *ageText;
@property (nonatomic, strong) NSString *genderText;
@property (nonatomic, strong) NSString *mostEmotionText;
@property (nonatomic, strong) NSString *emotionList;
@property (nonatomic, strong) NSMutableArray *faceFrame;
@end

@implementation MPODetectionFaceObject
@end

@interface takeAPhotoViewController () {
    NSMutableArray *_detectionFaces;
    NSString *resultAge;
    NSString *resultGender;
    NSString *resultMostEmotion;
    NSString *resultEmotionList;
    NSString *resultUserName;
    NSArray *resultFace;
    float widthRatio,heightRatio;
    
    UIImage *newImage;
}
@end

@implementation takeAPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnRetakeAPhoto.hidden = true;
    _btnRecommendMusic.hidden = true;
    _labelDetectResult.hidden = true;
    
    //blur
    [self.imageViewBackGround setImage:[_targetImage blur:(_targetImage)]];
    [self.imageViewBackGround setAlpha:0.6];
    
    //result
    newImage = _targetImage;
    widthRatio = 414/_targetImage.size.width;
    heightRatio = 500/_targetImage.size.height;
    
    CGSize size=CGSizeMake(_targetImage.size.width*widthRatio, _targetImage.size.height*heightRatio);//set the width and height
    UIGraphicsBeginImageContext(size);
    [_targetImage drawInRect:CGRectMake(0,0,size.width,size.height)];
    _targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.imageViewResult setImage:newImage];

    _targetImage = [_targetImage crop:CGRectMake(0, 0, 414, 500)];
    
    //detection
    _detectionFaces = [[NSMutableArray alloc] init];
    [self detection];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) detection {
    
    MPOFaceServiceClient *client = [[MPOFaceServiceClient alloc] initWithSubscriptionKey:@"aa7fc13262b54d5ca540a45d0c669136"];
    NSData *data = UIImageJPEGRepresentation(_targetImage, 0.8);
    
    [client detectWithData:data returnFaceId:YES returnFaceLandmarks:YES returnFaceAttributes:@[@(MPOFaceAttributeTypeAge), @(MPOFaceAttributeTypeGender),@(MPOFaceAttributeTypeEmotion)] completionBlock:^(NSArray<MPOFace *> *collection, NSError *error) {
        
        if(error) {
            self.labelDetectProcess.text = @"Detect Failed";
            _causeOfDetectFailed.text = @"지원하지 않는 사진 형식입니다";
            return ;
        }
        
        [_detectionFaces removeAllObjects];
        
        for (MPOFace *face in collection) {
            
            NSNumber *left,*top,*width,*height;
            left = face.faceRectangle.left;
            top = face.faceRectangle.top;
            width = face.faceRectangle.width;
            height = face.faceRectangle.height;
            
            UIImage *croppedImage = [_targetImage crop:CGRectMake(face.faceRectangle.left.floatValue, face.faceRectangle.top.floatValue, face.faceRectangle.width.floatValue, face.faceRectangle.height.floatValue)];
            
            MPODetectionFaceObject *obj = [[MPODetectionFaceObject alloc] init];
            obj.croppedFaceImage = croppedImage;
            obj.ageText = [NSString stringWithFormat:@"%@", face.attributes.age.stringValue];
            obj.genderText = [NSString stringWithFormat:@" %@", face.attributes.gender];
            obj.mostEmotionText = [NSString stringWithFormat:@" %@", face.attributes.emotion.mostEmotion];
            obj.emotionList= [NSString stringWithFormat:@"분노 %0.1f, 경멸 %0.1f, 역겨움 %0.1f, 두려움 %0.1f, 행복 %0.1f, 중립 %0.1f, 슬픔 %0.1f, 놀람 %0.1f",face.attributes.emotion.anger.floatValue,face.attributes.emotion.contempt.floatValue,face.attributes.emotion.disgust.floatValue,face.attributes.emotion.fear.floatValue,face.attributes.emotion.happiness.floatValue, face.attributes.emotion.neutral.floatValue,face.attributes.emotion.sadness.floatValue,face.attributes.emotion.surprise.floatValue];
            obj.faceFrame = [NSMutableArray arrayWithObjects:left,top,width,height, nil];
            

            [_detectionFaces addObject:obj];
            
            resultAge = [_detectionFaces[0] valueForKey:@"ageText"];
            resultGender = [_detectionFaces[0] valueForKey:@"genderText"];
            resultMostEmotion = [_detectionFaces[0] valueForKey:@"mostEmotionText"];
            resultEmotionList= [_detectionFaces[0] valueForKey:@"emotionList"];
            
            _labelDetectResult.text = [NSString stringWithFormat:@"%@, %@ \n%@",resultAge,resultGender,resultEmotionList];
            _labelDetectResult.hidden = false;
            _btnRecommendMusic.hidden = false;
            
        }

        if (collection.count==0) {
            
            [self.spinnerDetectProcess stopAnimating];
            _causeOfDetectFailed.text = @"사진에서 얼굴을 찾을 수 없습니다";
            self.labelDetectProcess.text = @"Detect Failed";
            _btnRetakeAPhoto.frame = CGRectMake(38, 678, 340, 44);
            _btnRetakeAPhoto.hidden=false;
            
        } else {
            
            self.detectingProcessView.hidden = true;
            NSLog(@"%lu", (unsigned long)collection.count);
            _btnRetakeAPhoto.hidden=false;
            
            for (int i = 1; i <= collection.count; i++) {
               
                
                NSNumber *x = [_detectionFaces[i-1] valueForKey:@"faceFrame"][0];
                NSNumber *y = [_detectionFaces[i-1] valueForKey:@"faceFrame"][1];
                
                NSNumber *w = [_detectionFaces[i-1] valueForKey:@"faceFrame"][2];
                NSNumber *h = [_detectionFaces[i-1] valueForKey:@"faceFrame"][3];

                NSLog(@"들어와쪄 %d",i);
                NSLog(@"%@", [_detectionFaces[i-1] valueForKey:@"faceFrame"][0]);
                UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                faceBtn.layer.borderWidth = 2.0f;
                faceBtn.layer.borderColor= [UIColor greenColor].CGColor;
                faceBtn.frame = CGRectMake (x.floatValue, y.floatValue+68, w.floatValue, h.floatValue);
                faceBtn.tag = i-1;
                [faceBtn addTarget:self action:@selector(showDetectResult:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:faceBtn];
            }
        }
        
    }];
}

-(void) showDetectResult: (UIButton *) button {
    
    resultAge = [_detectionFaces[button.tag] valueForKey:@"ageText"];
    resultGender = [_detectionFaces[button.tag] valueForKey:@"genderText"];
    resultMostEmotion = [_detectionFaces[button.tag] valueForKey:@"mostEmotionText"];
    resultEmotionList= [_detectionFaces[button.tag] valueForKey:@"emotionList"];
    _labelDetectResult.text = [NSString stringWithFormat:@"%@, %@ \n%@",resultAge,resultGender,resultEmotionList];
    
}

- (IBAction)btnHome:(id)sender {
     [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnChart:(id)sender {
}

- (IBAction)btnRetakeAPhoto:(id)sender {
    NSArray *allControllers = self.navigationController.viewControllers;
    ViewController *rootViewController = [allControllers firstObject];
    rootViewController.flag =YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnRecommendMusic:(id)sender {
    UIStoryboard *strBoard = self.storyboard;
    youtubeListViewController *youtubeListViewController = [strBoard instantiateViewControllerWithIdentifier:@"toYoutubeController2"];
    
    //사용자 이름 받는 얼럿 창
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Selfie_Music 사용자 정보" message:@"성함을 입력해 주십시오" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *check = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields.firstObject;
        NSLog(@"%@", textField.text);
        _userName = textField.text;
        youtubeListViewController.age = resultAge;
        youtubeListViewController.bgImg = _targetImage;
        youtubeListViewController.gender = resultGender;
        youtubeListViewController.mostEmotion = resultMostEmotion;
        youtubeListViewController.emotionList = resultEmotionList;
        youtubeListViewController.userName = _userName;
        
        NSLog(@"%@,%@,%@,%@,%@",resultAge,resultGender,resultEmotionList,resultMostEmotion,_userName);
        //확인 액션 시, 다음 페이지로 Push 이동
        [self.navigationController pushViewController:youtubeListViewController animated:YES];
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField*_Nonnull textField){}];
    [alert addAction:check];
    
    [self presentViewController:alert animated:NO completion:nil];
}
@end
