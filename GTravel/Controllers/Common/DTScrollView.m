//
//  DTScrollView.m
//  GTravel
//
//  Created by Raynay Yue on 5/11/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "DTScrollView.h"
#import "RYCommon.h"

#define TagImageView 10
#define TagButton 11
#define DefaultShowTime 5

@interface DTScrollView () <UIScrollViewDelegate> {
    int iShowTime;
    BOOL bScrollForever;
    BOOL bAutoScroll;
}
@property (nonatomic, weak) id<DTScrollViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *subItemViews;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) UIImage *defatultImage;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<DTScrollViewDelegate>)delegate repeat:(BOOL)repeat;
- (void)imageButtonClicked:(UIButton *)sender;

- (void)reorderSubviewsWithIndex:(NSInteger)index;
- (void)reorderScrollViewWhenScrollToBeginning;
- (void)reorderScrollViewWhenScrollToEnd;

- (void)startAutoScroll;
- (void)scrollToNextPage;
- (void)stopAutoScroll;

- (void)updatePageControlWithContentOffset:(CGPoint)offset;
- (void)updateImageDataOfURL:(NSURL *)url atIndex:(NSInteger)index;
- (void)removeAllSubItemViews;

@end

@implementation DTScrollView
#pragma mark - Non-Public Methods
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<DTScrollViewDelegate>)delegate repeat:(BOOL)repeat
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        bScrollForever = repeat;

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];

        self.scrollView = scrollView;

        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [self addSubview:pageControl];

        self.pageControl = pageControl;

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        self.queue = queue;

        iShowTime = DefaultShowTime;
    }
    return self;
}

- (void)imageButtonClicked:(UIButton *)sender
{
    if (RYDelegateCanResponseToSelector(self.delegate, @selector(scrollView:didClickImageAtIndex:))) {
        [self.delegate scrollView:self didClickImageAtIndex:sender.superview.tag];
    }
}

- (void)reorderSubviewsWithIndex:(NSInteger)index
{
    if (index == 0) {
        [self reorderScrollViewWhenScrollToBeginning];
    }
    else if (index == self.subItemViews.count - 1) {
        [self reorderScrollViewWhenScrollToEnd];
    }
}

- (void)reorderScrollViewWhenScrollToBeginning
{
    [self.subItemViews insertObject:[self.subItemViews lastObject] atIndex:0];
    [self.subItemViews removeLastObject];
    CGRect scrollViewFrame = self.scrollView.frame;
    for (int index = 0; index < self.subItemViews.count; index++) {
        UIView *subview = self.subItemViews[index];
        subview.frame = CGRectMake(index * scrollViewFrame.size.width, 0, subview.frame.size.width, subview.frame.size.height);
    }
    self.scrollView.contentOffset = CGPointMake(scrollViewFrame.size.width, 0);
}

- (void)reorderScrollViewWhenScrollToEnd
{
    [self.subItemViews addObject:[self.subItemViews firstObject]];
    [self.subItemViews removeObjectAtIndex:0];
    CGRect scrollViewFrame = self.scrollView.frame;
    for (int index = 0; index < self.subItemViews.count; index++) {
        UIView *subview = self.subItemViews[index];
        subview.frame = CGRectMake(index * scrollViewFrame.size.width, 0, subview.frame.size.width, subview.frame.size.height);
    }
    self.scrollView.contentOffset = CGPointMake((self.subItemViews.count - 2) * scrollViewFrame.size.width, 0);
}

- (void)startAutoScroll
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:iShowTime target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.autoScrollTimer = timer;
}

- (void)scrollToNextPage
{
    CGPoint currentContentOffset = self.scrollView.contentOffset;
    CGFloat nextContentOffsetX = currentContentOffset.x + self.scrollView.frame.size.width;
    BOOL bAnimated = nextContentOffsetX <= (self.subItemViews.count - 1) * self.scrollView.frame.size.width;
    nextContentOffsetX = nextContentOffsetX > (self.subItemViews.count - 1) * self.scrollView.frame.size.width ? 0 : nextContentOffsetX;
    CGPoint nextContentOffset = CGPointMake(nextContentOffsetX, currentContentOffset.y);
    [self.scrollView setContentOffset:nextContentOffset animated:bAnimated];
    [self updatePageControlWithContentOffset:nextContentOffset];
}

- (void)stopAutoScroll
{
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (void)updatePageControlWithContentOffset:(CGPoint)offset
{
    for (UIView *subView in self.subItemViews) {
        if (subView.frame.origin.x == offset.x) {
            self.pageControl.currentPage = subView.tag;
            break;
        }
    }
    if (self.pageControl.currentPage == self.subItemViews.count - 1) {
        if (!bScrollForever) {
            [self setAutoScrollEnabled:NO];
        }
        if (RYDelegateCanResponseToSelector(self.delegate, @selector(scrollViewDidScrollToEnd:))) {
            [self.delegate scrollViewDidScrollToEnd:self];
        }
    }
}

- (void)updateImageDataOfURL:(NSURL *)url atIndex:(NSInteger)index
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:self.queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                             if (connectionError) {
//                                 RYCONDITIONLOG(DEBUG, @"%@", connectionError);
//                             }
//                             else {
//                                 UIImage *image = [UIImage imageWithData:data];
//                                 if (index < self.subItemViews.count) {
//                                     UIView *subView = self.subItemViews[index];
//                                     UIImageView *imageView = (UIImageView *)[subView viewWithTag:TagImageView];
//                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                       imageView.image = image;
//                                       if (RYDelegateCanResponseToSelector(self.delegate, @selector(scrollView:didUpdateImageData:atIndex:))) {
//                                           [self.delegate scrollView:self didUpdateImageData:data atIndex:index];
//                                       }
//                                     });
//                                 }
//                                 else
//                                     RYCONDITIONLOG(DEBUG, @"Index(%d) is out of range [0...%d]", (int)index, (int)(self.subItemViews.count - 1));
//                             }
//                           }];
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (connectionError) {
					RYCONDITIONLOG(DEBUG, @"%@", connectionError);
				}
				else {
					UIImage *image = [UIImage imageWithData:data];
					if (index < self.subItemViews.count) {
						UIView *subView = self.subItemViews[index];
						UIImageView *imageView = (UIImageView *)[subView viewWithTag:TagImageView];
						dispatch_async(dispatch_get_main_queue(), ^{
							imageView.image = image;
							if (RYDelegateCanResponseToSelector(self.delegate, @selector(scrollView:didUpdateImageData:atIndex:))) {
								[self.delegate scrollView:self didUpdateImageData:data atIndex:index];
							}
						});
					}
					else
						RYCONDITIONLOG(DEBUG, @"Index(%d) is out of range [0...%d]", (int)index, (int)(self.subItemViews.count - 1));
				}
			});
		}];
		[task resume];
	}];
	[self.queue addOperation:operation];
}

- (void)removeAllSubItemViews
{
    for (UIView *view in self.subItemViews) {
        [view removeFromSuperview];
    }
    [self.subItemViews removeAllObjects];
}

- (void)dealloc
{
    [self stopAutoScroll];
    [self.queue cancelAllOperations];
    self.queue = nil;
}

#pragma mark - Public Methods
+ (DTScrollView *)scrollViewWithFrame:(CGRect)frame delegate:(id<DTScrollViewDelegate>)delegate scrollForever:(BOOL)forever
{
    DTScrollView *scrollView = [[DTScrollView alloc] initWithFrame:frame delegate:delegate repeat:forever];
    return scrollView;
}

- (void)setImageWithPaths:(NSArray *)paths pageIndicatorPosition:(DTPageControlPosition)position
{
    [self removeAllSubItemViews];
    [self.queue cancelAllOperations];

    CGRect frame = self.frame;
    self.scrollView.contentSize = CGSizeMake(frame.size.width * paths.count, frame.size.height);
    self.scrollView.scrollEnabled = paths.count > 1;

    NSMutableArray *arrItems = [NSMutableArray array];
    for (int i = 0; i < paths.count; i++) {
        UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:subview.bounds];
        imageView.tag = TagImageView;
        NSString *strImagePath = paths[i];
        if ([strImagePath rangeOfString:@"http://"].location == NSNotFound) {
            imageView.image = [UIImage imageWithContentsOfFile:strImagePath];
        }
        else {
            imageView.image = self.defatultImage;
            [self updateImageDataOfURL:[NSURL URLWithString:strImagePath] atIndex:i];
        }
        [subview addSubview:imageView];

        UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backgroundButton setFrame:subview.bounds];
        backgroundButton.tag = TagButton;
        [backgroundButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [subview addSubview:backgroundButton];

        subview.tag = i;
        [self.scrollView addSubview:subview];
        [arrItems addObject:subview];
    }
    self.subItemViews = arrItems;

    self.pageControl.numberOfPages = paths.count;

    CGSize size = [self.pageControl sizeForNumberOfPages:paths.count];
    CGFloat fX = 0;
    switch (position) {
        case DTPageControlPositionLeft:
            fX = 10;
            break;
        case DTPageControlPositionCenter:
            fX = (frame.size.width - size.width) * 0.5;
            break;
        case DTPageControlPositionRight:
            fX = frame.size.width - size.width - 10;
            break;
        default:
            break;
    }
    self.pageControl.frame = CGRectMake(fX, frame.size.height - size.height * 0.5, size.width, size.height * 0.5);
}

- (void)setImageWithPaths:(NSArray *)paths defaultImage:(UIImage *)image pageIndicatorPosition:(DTPageControlPosition)position
{
    self.defatultImage = image;
    [self setImageWithPaths:paths pageIndicatorPosition:position];
}

- (void)setAutoScrollEnabled:(BOOL)enabled
{
    if (self.subItemViews.count > 1) {
        if (enabled) {
            [self startAutoScroll];
        }
        else {
            [self stopAutoScroll];
        }
        bAutoScroll = enabled;
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [NSThread sleepForTimeInterval:DefaultShowTime];
          dispatch_async(dispatch_get_main_queue(), ^{
            if (RYDelegateCanResponseToSelector(self.delegate, @selector(scrollViewDidScrollToEnd:))) {
                [self.delegate scrollViewDidScrollToEnd:self];
            }
          });
        });
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAutoScroll];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (bAutoScroll) {
        [self startAutoScroll];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePageControlWithContentOffset:scrollView.contentOffset];
    if (bScrollForever) {
        CGPoint offset = scrollView.contentOffset;
        int index = offset.x / scrollView.frame.size.width;
        [self reorderSubviewsWithIndex:index];
    }
}

@end
