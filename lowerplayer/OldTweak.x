#import <UIKit/UIKit.h>

@interface CSQuickActionsViewController : UIViewController

- (UIView *)findViewWithKind:(UIView *)view ofClass:(NSString *)className;

@end

@interface NCNotificationListView : UIView

@property (nonatomic, assign, getter=isRevealed) BOOL revealed;

@end

%hook CSQuickActionsViewController

UIView *mediaPlayer;
NCNotificationListView *notificationCenterSuperview;
NCNotificationListView *notificationCenter;
BOOL ncVisible;

%new
- (UIView *)findViewWithKind:(UIView *)view ofClass:(NSString *)className {
    if ([view isKindOfClass:NSClassFromString(className)]) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView *result = [self findViewWithKind:subview ofClass:className];
        if (result) {
            return result;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;

    if (!mediaPlayer) {
        UIWindow *lockScreenWindow = [[UIApplication sharedApplication] keyWindow];
        mediaPlayer = [self findViewWithKind:lockScreenWindow ofClass:@"MRUNowPlayingView"].superview.superview.superview.superview;
		notificationCenterSuperview = (NCNotificationListView *) mediaPlayer.superview.superview.superview;
		notificationCenter = notificationCenterSuperview.subviews[0];
    }

    if (mediaPlayer) {
		ncVisible = notificationCenter.revealed;
		if (ncVisible) {
			NSLog(@"NC is visible");
			NSLog(@"Moving it up");
			//do later
			return;
		}


		NSLog(@"Moving it down");
        CGRect frame = mediaPlayer.frame;
		frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
        frame.origin.y = self.view.frame.size.height - (110 + frame.size.height);
        mediaPlayer.frame = frame;
        [self.view addSubview:mediaPlayer];
    }
	else {
		NSLog(@"Cant find media player");
	}
}

%end
