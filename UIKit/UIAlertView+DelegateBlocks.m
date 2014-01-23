//
// protocolblocks: UIKit/UIAlertView+DelegateBlocks.m
// http://protocolblocks.org/
//
// Copyright (C) 2011 by Constantin Rack, VIGOS AG.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UIAlertView+DelegateBlocks.h"
#import <objc/runtime.h>

static NSString* UIAlertViewDelegateBlocksKey = @"UIAlertViewDelegateBlocksKey";

@implementation UIAlertView (DelegateBlocks)

-(id)useBlocksForDelegate {
    UIAlertViewDelegateBlocks* delegate = [[UIAlertViewDelegateBlocks alloc] init];
    objc_setAssociatedObject (self, &UIAlertViewDelegateBlocksKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

-(void)assureBlockDelegate {
    if (![self blockDelegate]) return;
    if (self.delegate != [self blockDelegate]) {
        self.delegate = [self blockDelegate];
    }
}

-(id)blockDelegate {
    return objc_getAssociatedObject(self, &UIAlertViewDelegateBlocksKey);
}

-(void)onClickedButtonAtIndex:(UIAlertViewClickedButtonAtIndexBlock)block {
    [((UIAlertViewDelegateBlocks*)[self blockDelegate]) setClickedButtonAtIndexBlock:block];
    [self assureBlockDelegate];
}

-(void)onDidDismissWithButtonIndex:(UIAlertViewDidDismissWithButtonIndexBlock)block {
    [((UIAlertViewDelegateBlocks*)[self blockDelegate]) setDidDismissWithButtonIndexBlock:block];
    [self assureBlockDelegate];
}

-(void)onWillDismissWithButtonIndex:(UIAlertViewWillDismissWithButtonIndexBlock)block {
    [((UIAlertViewDelegateBlocks*)[self blockDelegate]) setWillDismissWithButtonIndexBlock:block];
    [self assureBlockDelegate];
}

-(void)onCancel:(UIAlertViewCancelBlock)block {
    [((UIAlertViewDelegateBlocks*)[self blockDelegate]) setCancelBlock:block];
    [self assureBlockDelegate];
}

-(void)onDidPresentAlertView:(UIAlertViewDidPresentAlertViewBlock)block {
    [((UIAlertViewDelegateBlocks*)[self blockDelegate]) setDidPresentAlertViewBlock:block];
    [self assureBlockDelegate];
}

-(void)onWillPresentAlertView:(UIAlertViewWillPresentAlertViewBlock)block {
    [((UIAlertViewDelegateBlocks*)[self blockDelegate]) setWillPresentAlertViewBlock:block];
    [self assureBlockDelegate];
}

@end

@implementation UIAlertViewDelegateBlocks

@synthesize clickedButtonAtIndexBlock = _clickedButtonAtIndexBlock;
@synthesize didDismissWithButtonIndexBlock = _didDismissWithButtonIndexBlock;
@synthesize willDismissWithButtonIndexBlock = _willDismissWithButtonIndexBlock;
@synthesize cancelBlock = _cancelBlock;
@synthesize didPresentAlertViewBlock = _didPresentAlertViewBlock;
@synthesize willPresentAlertViewBlock = _willPresentAlertViewBlock;

-(BOOL)respondsToSelector:(SEL)aSelector {
    if ( sel_isEqual(aSelector, @selector(alertView:clickedButtonAtIndex:)) ) {
        return !!self.clickedButtonAtIndexBlock;
    } else if ( sel_isEqual(aSelector, @selector(alertView:didDissmissWithButtonIndex:)) ) {
        return !!self.didDismissWithButtonIndexBlock;
    } else if ( sel_isEqual(aSelector, @selector(alertView:willDissmissWithButtonIndex:)) ) {
        return !!self.willDismissWithButtonIndexBlock;
    } else if ( sel_isEqual(aSelector, @selector(alertViewCancel:)) ) {
        return !!self.cancelBlock;
    } else if ( sel_isEqual(aSelector, @selector(didPresentAlertView:)) ) {
        return !!self.didPresentAlertViewBlock;
    } else if ( sel_isEqual(aSelector, @selector(willPresentAlertView:)) ) {
        return !!self.willPresentAlertViewBlock;
    }
    return [super respondsToSelector:aSelector];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    UIAlertViewClickedButtonAtIndexBlock block = [self.clickedButtonAtIndexBlock copy];
    block(alertView, buttonIndex);
}

-(void)alertView:(UIAlertView*)alertView didDissmissWithButtonIndex:(NSInteger)buttonIndex  {
    UIAlertViewDidDismissWithButtonIndexBlock block = [self.didDismissWithButtonIndexBlock copy];
    block(alertView, buttonIndex);
}

-(void)alertView:(UIAlertView*)alertView willDissmissWithButtonIndex:(NSInteger)buttonIndex  {
    UIAlertViewWillDismissWithButtonIndexBlock block = [self.willDismissWithButtonIndexBlock copy];
    block(alertView, buttonIndex);
}

-(void)alertViewCancel:(UIAlertView*)alertView  {
    UIAlertViewCancelBlock block = [self.cancelBlock copy];
    block(alertView);
}

-(void)didPresentAlertView:(UIAlertView*)alertView  {
    UIAlertViewDidPresentAlertViewBlock block = [self.didPresentAlertViewBlock copy];
    block(alertView);
}

-(void)willPresentAlertView:(UIAlertView*)alertView  {
    UIAlertViewWillPresentAlertViewBlock block = [self.willPresentAlertViewBlock copy];
    block(alertView);
}

@end

