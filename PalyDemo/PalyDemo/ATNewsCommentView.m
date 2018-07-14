//
//  ATNewsCommentView.m
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/14.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ATNewsCommentView.h"
#import "ATNewsBaseInfo.h"
#import "ATPersonalCommentView.h"


#define BottomBarHeight (ATSafeAreaBottomHeight + 44)

@interface ATNewsCommentView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSMutableArray *commentArray;//评论数组
@property(nonatomic)ATNewsBaseInfo *newsInfo;
@end


@implementation ATNewsCommentView

//外部传入的数据
- (instancetype)initWithNewsBaseInfo:(ATNewsBaseInfo *)newsInfo{
    self = [super init];
    if(self){
        self.topSpace = 0 ;
        self.navContentOffsetY = 0 ;
        self.navTitleHeight = 44 ;
        self.contentViewCornerRadius = 10 ;
         self.newsInfo = newsInfo;
        self.cornerEdge = UIRectCornerTopRight|UIRectCornerTopLeft;
    }
    return self ;
}
#pragma mark -- 视图的显示和消失

- (void)viewWillAppear{
    [super viewWillAppear];
    [self initUI];
    [self loadCommentData];
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
}
#pragma mark -- 初始化UI

- (void)initUI{
    [self.dragContentView addSubview:self.tableView];
//    [self.dragContentView insertSubview:self.loadingView aboveSubview:self.tableView];  //加载
//    [self.dragContentView insertSubview:self.bottomBar aboveSubview:self.tableView]; //底部评论
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navTitleView.mas_bottom);
        make.left.width.mas_equalTo(self.dragContentView);
        make.height.mas_equalTo(self.dragContentView).mas_offset(-BottomBarHeight-self.navTitleHeight).priority(998);
    }];
    
    [self initNavBar];
}

#pragma mark -- 导航栏

- (void)initNavBar{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"button_close"] imageWithAlpha:0.5] forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(startHide) forControlEvents:UIControlEventTouchUpInside];
    self.navTitleView.leftBtns = @[backButton];
    self.navTitleView.title = @"评论";
}
#pragma mark -- 加载评论

- (void)loadCommentData{
    
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"终于搞定了==点我%ld",(long)indexPath.row];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showPersonalCommentWithId:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
}
#pragma mark -- 显示个人评论详情视图

- (void)showPersonalCommentWithId:(NSString *)commentId{
    ATPersonalCommentView *view = [[ATPersonalCommentView alloc]initWithCommentId:commentId];
    view.topSpace =0 ;
    view.navContentOffsetY = 0 ;
    view.navTitleHeight = 44 ;
    view.contentViewCornerRadius = 10 ;
    view.cornerEdge = UIRectCornerTopRight|UIRectCornerTopLeft;
    
    [self.dragContentView addSubview:view];
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.dragContentView);
    }];
    [view startShow];
}
#pragma mark -- @property
#define IOS11_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending )
#define ATAdjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = ({
            UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            view.delegate = self;
            view.dataSource = self ;
            [view registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
            view.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            weakSelf(self);
            
            MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
 
                [weakSelf loadCommentData];
            }];
            [footer setTitle:@"正在努力加载" forState:MJRefreshStateIdle];
            [footer setTitle:@"正在努力加载" forState:MJRefreshStateRefreshing];
            [footer setTitle:@"正在努力加载" forState:MJRefreshStatePulling];
            [footer setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
            [view setMj_footer:footer];
            
            //iOS11 reloadData界面乱跳bug
            view.estimatedRowHeight = 0;
            view.estimatedSectionHeaderHeight = 0;
            view.estimatedSectionFooterHeight = 0;
            if(IOS11_OR_LATER){
                ATAdjustsScrollViewInsets(view);
            }
            
            view ;
        });
    }
    return _tableView ;
}
@end
