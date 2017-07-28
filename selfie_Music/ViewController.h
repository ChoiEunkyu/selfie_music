//
//  ViewController.h
//  selfie_Music
//
//  Created by imbc on 2017. 6. 27..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
}

- (IBAction)BtnTakeAPhoto:(id)sender;
- (IBAction)BtnChart:(id)sender;



//추후 화면 전환시 얼럿 창 초기화를 위한 flag 설정
@property BOOL flag;
@end

