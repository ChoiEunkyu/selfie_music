//
//  youtubeListViewController.m
//  selfie_Music
//
//  Created by imbc on 2017. 6. 28..
//  Copyright © 2017년 imbc. All rights reserved.
//

#import "youtubeListViewController.h"
#import "ViewController.h"
#import "customMusicTableViewCell.h"
#import "saveData.h"
#import <Social/Social.h>

@interface youtubeListViewController ()
@end

@implementation youtubeListViewController {
}

-(void)viewDidLoad {
    
    _listOfMusicTableView.delegate = self;
    _listOfMusicTableView.dataSource = self;
    [self.listOfMusicTableView registerNib:[UINib nibWithNibName:@"customMusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"musicListCell"];
    
    //blur
    [self.backBlurImageView setImage:[_bgImg blur:(_bgImg)]];
    [self.backBlurImageView setAlpha:0.6];
    
    //나이 데이터 값 임의 조정
    _checkforAge = 2020 - [_age intValue];
    self.savedMusicDataList = [[NSMutableArray alloc] init];
    self.musicList = [[NSMutableArray alloc] init];
    
    /**Youtube Data 수신*/
    [self getPlayListId];
    [self youtubeData];
    
    /**server 송신*/
    [self sendToTextData];
    [self sendToImageData];
    
    /**Youtube Play*/
    [self playYoutube];
    
}

/**Youtube Play*/
- (void) playYoutube {
    
    self.playerView.delegate = self;
    
    NSDictionary *playerVars = @ {
        @"controls" :@1,
        @"playsinline" :@1,
        @"loop" :@1,
    };
    
    [self.playerView loadWithPlaylistId:_playListId playerVars:playerVars];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedPlaybackStartedNotification:)
                                                 name:@"Playback started"
                                               object:nil];
    
    [self.playerView playVideo];
}

-(void)playerView:(YTPlayerView *)ytPlayerView didChangeToState:(YTPlayerState)state{
    
    NSString *message = [NSString stringWithFormat:@"player state chaged: %ld\n",(long) state];
    NSLog(@"%@",message);
    
    if (state == 0) {
        [self.playerView nextVideo];
    } else if (state ==2) {
        saveData *savedData= [self.savedMusicDataList objectAtIndex:[self.playerView playlistIndex]];
        _labelMusicTitle.text = savedData.musicName;
        [_labelMusicTitle setFont:[UIFont systemFontOfSize:12.0f]];
    } else if (state == 4) {
        _labelMusicTitle.text = @"";
    }
}

- (void)receivedPlaybackStartedNotification:(NSNotification *) notification {
    
    if([notification.name isEqual:@"Playback started"] && notification.object != self) {
        [self.playerView pauseVideo];
    }
}


/**server 송신*/

- (void) sendToTextData {
    
    NSURL *textURL = [NSURL URLWithString:@"http://ec2-52-14-187-109.us-east-2.compute.amazonaws.com:8080/api"];
    
    //textrequest 객체 옵션 설정
    NSMutableURLRequest *textRequest = [NSMutableURLRequest requestWithURL:textURL];
    [textRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [textRequest setHTTPShouldHandleCookies:NO];
    [textRequest setTimeoutInterval:30.0f];
    [textRequest setHTTPMethod:@"POST"];
    
    //텍스트 데이터 객체 생성
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *date = [[NSDate alloc]init];
    _dateString =[format stringFromDate:date];
    NSMutableArray *keys = [NSMutableArray arrayWithObjects:@"userName", @"userGender",@"userAge", @"userEmotion", @"musicList", @"imgSrc",nil];
    NSMutableArray *obj = [NSMutableArray arrayWithObjects:_userName,_gender,_age,_emotionList,_musicList,_dateString,nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:obj forKeys:keys];
    NSError *error;
    NSData *textData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONReadingMutableContainers error:&error];
    
    [textRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [textRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [textRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[textData length]] forHTTPHeaderField:@"Content-Length"];
    
    [textRequest setHTTPBody: textData];
    // start upload
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:textRequest
                                                                  delegate:self];
    if(connection) {
        [connection start];
        NSLog(@"데이터가 연결에 다가가고 있다");
    } else {
        NSLog(@"데이터 연결에 실패하였습니다");
    }
    
}

-(void) sendToImageData {
    
    NSURL *imgURL = [NSURL URLWithString:@"http://ec2-52-14-187-109.us-east-2.compute.amazonaws.com:8080/api/upload"];
    
    NSMutableURLRequest *imgRequest = [NSMutableURLRequest requestWithURL:imgURL];
    [imgRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [imgRequest setHTTPShouldHandleCookies:NO];
    [imgRequest setTimeoutInterval:30.0f];
    [imgRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"image_Boundary";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [imgRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *imgBody = [NSMutableData data];
    
    NSData *imageData = UIImageJPEGRepresentation(_bgImg, 1.0f);
    
    NSString *fileName = [NSString stringWithFormat:@"selfieImg_%@.jpeg",_dateString];
    
    [imgBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [imgBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"selfieImg\"; fileName=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [imgBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [imgBody appendData:imageData];
    [imgBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [imgBody appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [imgRequest setHTTPBody:imgBody];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[imgBody length]];
    [imgRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:imgRequest delegate:self];
    [connection start];
    NSLog(@"이미지 데이터 시작");
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",@"전송완료");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**YoutubeData 수신*/

-(void) getPlayListId {
    NSString *playListSearchPath = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=id,snippet&q=%d년 최신 인기 가요&type=playlist&key=AIzaSyBTnGrV6VgkXpvXWkxifu6mCG6-Llix_Uc&maxResults=1",_checkforAge];
    
    playListSearchPath = [playListSearchPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *playListUrl = [NSURL URLWithString:playListSearchPath];
    NSMutableURLRequest *playListRequest = [NSMutableURLRequest requestWithURL:playListUrl];
    [playListRequest setHTTPMethod:@"GET"];
    NSError *error;
    NSData *playListData = [NSData dataWithContentsOfURL:playListUrl options:NSDataReadingMappedIfSafe error:&error];
    
    NSDictionary* playListDic = [NSJSONSerialization JSONObjectWithData:playListData options:NSJSONReadingMutableLeaves error:&error];
    
    _playListId = [[[playListDic valueForKey:@"items"][0] valueForKey:@"id"] valueForKey:@"playlistId"];
}

-(void) youtubeData {
    
    dispatch_queue_t concurrentQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    
    dispatch_sync(concurrentQ,^
                  {
                      
                      NSString *path = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=id,snippet&maxResults=30&playlistId=%@&key=AIzaSyBTnGrV6VgkXpvXWkxifu6mCG6-Llix_Uc",_playListId];
                      
                      path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                      
                      NSURL *url = [NSURL URLWithString:path];
                      NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url];
                      [request2 setHTTPMethod:@"GET"];
                      NSError *error;
                      NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
                      
                      NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                      
                      NSMutableArray* item = [dic valueForKey:@"items"];
                      long row;
                      
                      for(row=0; row<item.count; row++) {
                          
                          saveData *saveMusicInfo = [[saveData alloc] init];
                          
                          saveMusicInfo.musicName = [[item[row] valueForKey:@"snippet"] valueForKey:@"title"];
                          saveMusicInfo.musicId = [[[item[row] valueForKey:@"snippet"] valueForKey:@"resourceId"] valueForKey:@"videoId"];
                          NSString *shareToPath = [[[[item[row] valueForKey:@"snippet"] valueForKey:@"thumbnails"]valueForKey:@"default" ]valueForKey:@"url"];
                          shareToPath = [shareToPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                          NSURL *shareToURL = [NSURL URLWithString:shareToPath];
                          saveMusicInfo.imageUrl = shareToURL;
                          
                          saveMusicInfo.musicRow = row;
                          [_savedMusicDataList addObject:saveMusicInfo];
                          
                          NSMutableArray * musicListSetting = [[NSMutableArray alloc] init];
                          [musicListSetting addObject:saveMusicInfo.musicName];
                          [musicListSetting addObject:saveMusicInfo.musicId];
                          
                          [_musicList addObject:musicListSetting];
                      }
                      
                      dispatch_async(mainQ,^
                                     {
                                         [self.listOfMusicTableView reloadData];
                                     });
                  });
    
}

/**table*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.savedMusicDataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    saveData *savedData = [self.savedMusicDataList objectAtIndex:indexPath.row];
    customMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicListCell" forIndexPath:indexPath];
    
    [cell setThumbnailWithImage:savedData.imageUrl];
    [cell setMusicName:savedData.musicName];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeBtnImg.png"]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.playerView playVideoAt:indexPath.row];
}




//SNS공유

- (IBAction)btnChart:(id)sender {
}

- (IBAction)btnHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnRetakeAPhoto:(id)sender {
    NSArray *allControllers = self.navigationController.viewControllers;
    ViewController *root = [allControllers firstObject];
    root.flag = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)btnShare:(id)sender {
    
    NSString *URL = [NSString stringWithFormat:@"http://ec2-52-14-187-109.us-east-2.compute.amazonaws.com:8080/users/%@",_userName];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController* facebookComposeView = [Share_SNS sendToFacebook:nil :URL :_bgImg];
        [self presentViewController:facebookComposeView animated:YES completion:Nil];
    }
}

- (IBAction)btnPrev:(id)sender {
    [self.playerView previousVideo];
}

- (IBAction)btnNext:(id)sender {
    [self.playerView nextVideo];
}


@end

