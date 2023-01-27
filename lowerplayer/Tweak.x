#import <UIKit/UIKit.h>

@interface MRUNowPlayingView : UIView

@end

@interface CSAdjunctItemView : UIView

@end

%hook MRUNowPlayingView

- (void)layoutSubviews {
    %orig;
    CSAdjunctItemView *adjunctItemView = (CSAdjunctItemView *) self.superview.superview.superview.superview.superview;
    CGRect frame = adjunctItemView.frame;
    frame.origin.y = UIApplication.sharedApplication.keyWindow.frame.size.height - 300 - (110 + frame.size.height);
    adjunctItemView.frame = frame;
}

%end
