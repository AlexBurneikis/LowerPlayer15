#import <UIKit/UIKit.h>

@interface CSQuickActionsViewController : UIViewController

- (UIView *)findViewWithKind:(UIView *)view string:(NSString *)string;

@end

@interface MRUNowPlayingView : UIView

@end

%hook CSQuickActionsViewController

// store the media player view in a variable
UIView *mediaPlayer;

%new
- (UIView *)findViewWithKind:(UIView *)view string:(NSString *)string {

	if ([view isKindOfClass:NSClassFromString(string)]) {
		return view.superview.superview.superview.superview.superview;
	}

	for (UIView *subview in view.subviews) {
		UIView *result = [self findViewWithKind:subview string:string];
		if (result) {
			return result;
		}
	}

	return nil;
}

- (void)viewWillAppear:(BOOL)animated {
	%orig;

	if (mediaPlayer == nil) {
		UIWindow *lockScreenWindow = [[UIApplication sharedApplication] keyWindow];
		mediaPlayer = [self findViewWithKind:lockScreenWindow string:@"MRUNowPlayingView"];
	}

	if (mediaPlayer) {
		CGRect frame = mediaPlayer.frame;

		frame.origin.y = self.view.frame.size.height - (100 + frame.size.height);
		mediaPlayer.frame = frame;

		[self.view addSubview:mediaPlayer];
	}
}

%end
