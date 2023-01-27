#import <UIKit/UIKit.h>

@interface CSQuickActionsViewController : UIViewController

- (UIView *)findViewWithKind:(UIView *)view ofClass:(NSString *)className;

@end

%hook CSQuickActionsViewController

UIView *mediaPlayer;

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
    }
    if (mediaPlayer) {
        CGRect frame = mediaPlayer.frame;
		frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
        frame.origin.y = self.view.frame.size.height - (110 + frame.size.height);
        mediaPlayer.frame = frame;
        [self.view addSubview:mediaPlayer];
    }
}

%end
