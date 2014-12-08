//
//  Created by Jesse Rajat
//  http://www.jesseRajat.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jesseRajat/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Rajat
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "DemoModelData.h"

#import "NSUserDefaults+DemoSettings.h"


/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation DemoModelData

- (instancetype)init
{
    self = [super init];
    if (self) {
		
		// Load our default settings
		[NSUserDefaults saveIncomingAvatarSetting:NO];
		[NSUserDefaults saveOutgoingAvatarSetting:NO];

		/*
        if ([NSUserDefaults emptyMessagesSetting]) {
            self.messages = [NSMutableArray new];
        }
        else {
            [self loadFakeMessages];
        }
        */
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
 
        JSQMessagesAvatarImage *jsqImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"JSQ"
                                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                 font:[UIFont systemFontOfSize:14.0f]
                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
             */
		
        JSQMessagesAvatarImage *rajatImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"rajat_thumbpic.jpg"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *courtneyImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"mockFaces-female1.jpg"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.avatars = @{ kJSQDemoAvatarIdSelf : rajatImage,
                          kJSQDemoAvatarIdOther : courtneyImage
						  };
        
        
        self.users = @{ kJSQDemoAvatarIdSelf : kJSQDemoAvatarDisplayNameRajat,
                        kJSQDemoAvatarIdOther : kJSQDemoAvatarDisplayNameCourtney
                      };
        
		 
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
		JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

- (void)loadFakeMessages
{
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdOther
                                            senderDisplayName:kJSQDemoAvatarDisplayNameCourtney
                                                         date:[NSDate date]
                                                         text:@"Hi Rajat, my name is Courtney and I will be helping you with your Fashin questions. How are you doing?"],
                     
                     [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdSelf
                                            senderDisplayName:kJSQDemoAvatarDisplayNameRajat
                                                         date:[NSDate date]
                                                         text:@"Hi Courtney, I'm good. How are you?"],
					 
					 [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdOther
											senderDisplayName:kJSQDemoAvatarDisplayNameCourtney
														 date:[NSDate date]
														 text:@"I'm doing well. Thank you for asking. So how can I help you today?"],
					 
					 [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdSelf
											senderDisplayName:kJSQDemoAvatarDisplayNameRajat
														 date:[NSDate date]
														 text:@"I have an interview coming up in San Francisco. I was told that the dress code is business casual. Should I go with a blazer or just dress shirt and tie?"],
					 
					 [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdOther
											senderDisplayName:kJSQDemoAvatarDisplayNameCourtney
														 date:[NSDate date]
														 text:@"I would need a little more info about what you currently have in your wardrobe and what styles you are comfortable with."],
					 
					 [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdOther
											senderDisplayName:kJSQDemoAvatarDisplayNameCourtney
														 date:[NSDate date]
														 text:@"It would definitely be possible to create a casual look even with a blazer. In fact I recommend going with a blazer as it provides a sharp and confident look."],
					 
					 [[JSQTextMessage alloc] initWithSenderId:kJSQDemoAvatarIdSelf
											senderDisplayName:kJSQDemoAvatarDisplayNameRajat
														 date:[NSDate date]
														 text:@"Yeah, that's what I was thinking too. I don't currently have any good blazers and am thinking of buying one this afternoon. I had something like this pic in mind."],
					 
                     nil];
	
//    [self addPhotoMediaMessage];
	
    /**
     *  Setting to load extra messages for testing/demo
     */
    if ([NSUserDefaults extraMessagesSetting]) {
        NSArray *copyOfMessages = [self.messages copy];
        for (NSUInteger i = 0; i < 4; i++) {
            [self.messages addObjectsFromArray:copyOfMessages];
        }
    }
    
    
    /**
     *  Setting to load REALLY long message for testing/demo
     *  You should see "END" twice
     */
    if ([NSUserDefaults longMessageSetting]) {
        JSQTextMessage *reallyLongMessage = [JSQTextMessage messageWithSenderId:kJSQDemoAvatarIdSelf
                                                                    displayName:kJSQDemoAvatarDisplayNameRajat
                                                                           text:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END"];
        
        [self.messages addObject:reallyLongMessage];
    }
}

- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"md-blazer.jpg"]];
    JSQMediaMessage *photoMessage = [JSQMediaMessage messageWithSenderId:kJSQDemoAvatarIdSelf
                                                             displayName:kJSQDemoAvatarDisplayNameRajat
                                                                   media:photoItem];
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMediaMessage *locationMessage = [JSQMediaMessage messageWithSenderId:kJSQDemoAvatarIdSelf
                                                                displayName:kJSQDemoAvatarDisplayNameRajat
                                                                      media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaitem *videoItem = [[JSQVideoMediaitem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMediaMessage *videoMessage = [JSQMediaMessage messageWithSenderId:kJSQDemoAvatarIdSelf
                                                             displayName:kJSQDemoAvatarDisplayNameRajat
                                                                   media:videoItem];
    [self.messages addObject:videoMessage];
}

@end
