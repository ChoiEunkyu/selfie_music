//
//  ViewController.m
//  selfie_Music
//
//  Created by imbc on 2017. 6. 27..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import "ViewController.h"
#import "takeAPhotoViewController.h"

@interface ViewController ()

//카메라 촬영시 앨범 저장을 위한 시그널 역할
@property BOOL newMedia;
@end

@implementation ViewController
UIImage *takeImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    _flag = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    if(_flag) {
        [self showAlert];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)BtnTakeAPhoto:(id)sender {
    [self showAlert];
}

- (IBAction)BtnChart:(id)sender {
}

- (void)showAlert {
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* camera = [UIAlertAction
                             actionWithTitle:@"카메라"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                                     UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
                                     imagePicker.delegate = self;
                                     imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
                                     imagePicker.allowsEditing = YES;
                                     [self presentViewController:imagePicker animated:YES completion:nil];
                                     _newMedia = YES;
                                 }
                                 //카메라 사용 못할 때 얼럿 경고창
                                 
                             }];
    
    UIAlertAction* album = [UIAlertAction
                            actionWithTitle:@"앨범에서 불러오기"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
                                    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
                                    imagePicker.delegate = self;
                                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                    imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
                                    imagePicker.allowsEditing = NO;
                                    [self presentViewController:imagePicker animated:YES completion:nil];
                                    _newMedia = NO;
                                }
                                
                            }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"취소"
                             style:UIAlertActionStyleDefault
                             handler:nil];
    [view addAction:camera];
    [view addAction:album];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    takeImage = info[UIImagePickerControllerOriginalImage];
    
    if (_newMedia) {
        UIImageWriteToSavedPhotosAlbum(takeImage, nil, nil, nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *strBoard = self.storyboard;
    takeAPhotoViewController *takeAPhotoViewController = [strBoard instantiateViewControllerWithIdentifier:@"takeAPhotoViewController"];
    takeAPhotoViewController.targetImage = takeImage;
    
    if(_flag){
        _flag = false;
    }
    
    [self.navigationController pushViewController:takeAPhotoViewController animated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
