//
//  AppDelegate.h
//  selfie_Music
//
//  Created by imbc on 2017. 6. 27..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UIImage+Crop.h"

//static NSString *const ProjectOxfordFaceSubscriptionKey = @"aa7fc13262b54d5ca540a45d0c669136";


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain, nonatomic) NSData * mdl;
@property (retain, nonatomic) NSData * recomdl;
@property (assign, nonatomic) intptr_t jdaDetector;
@property (assign, nonatomic) intptr_t recognizer;

@property (retain, nonatomic) NSMutableArray * groups;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

