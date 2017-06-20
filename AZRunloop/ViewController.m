//
//  ViewController.m
//  AZRunloop
//
//  Created by 徐振 on 2017/6/19.
//  Copyright © 2017年 徐振. All rights reserved.
//

#import "ViewController.h"
#import <CoreFoundation/CFRunLoop.h>

static NSString *identifier = @"cellIdentifier";
static CFRunLoopObserverRef  defonserver;

#import "CustomTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *tasks;

@property (nonatomic, assign)NSInteger maxTaskslangth;

@property (nonatomic, weak)NSTimer *timer;

@end

@implementation ViewController

-(void) ontimer{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tasks = [NSMutableArray array];
    //添加定时器  激活 runloop 循环次数
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(ontimer) userInfo:nil repeats:YES];
    //开启监听
    [self addRunloopObserver];
    //设置最大任务数  最好提前计算好最大任务数
    self.maxTaskslangth = 10;

    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    [self addTasks:^{
      [weakSelf addCellImage:cell];
    }];

    return cell;
}


- (void)addCellImage:(UITableViewCell *)cell{
    
    for (int i = 0 ; i < 4; i ++) {
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timg"]];
        image.tag = i + 10;
        image.frame = CGRectMake(i*110, 50, 100, 60);
        [cell.contentView addSubview:image];
        UILabel *lbl = [[UILabel alloc]init];
        lbl.text = @"accountcertificate, identifiers & profile创建标识符 项目的Bundle identifier创建发布证书 测试证书";
        lbl.numberOfLines = 2;
        lbl.frame = CGRectMake(0, i *11, self.view.frame.size.width, 10);
        [cell.contentView addSubview:lbl];
        
    }
    
}

- (void)addRunloopObserver {
    //获取当前 runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //创建上下文
    CFRunLoopObserverContext context = {
      0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    //创建一个监听者
    defonserver =  CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    //添加监听者
    CFRunLoopAddObserver(runloop, defonserver, kCFRunLoopCommonModes);
    //释放
    

    
}
//添加任务
- (void)addTasks:(dispatch_block_t)task{
    [self.tasks addObject:task];
    
    if (self.tasks.count > self.maxTaskslangth) {
        [self.tasks removeObjectAtIndex:0];
    }
    
}

//执行函数
void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    
//    桥接对象
    ViewController *vc = (__bridge ViewController *)info;
    //如果任务为0 直接结束 节省性能
    if (vc.tasks.count == 0) {
        return;
    }
    //执行任务
    dispatch_block_t dask = vc.tasks.firstObject;
    
    dask();
    //执行完毕 删除
    [vc.tasks removeObject:dask];
    
}




- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.maxTaskslangth = self.tableView.visibleCells.count;

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate]; //在这里销毁定时器
    self.timer = nil;
    NSLog(@"销毁定时器");
    //
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //释放监听者
    CFRunLoopRemoveObserver(runloop, defonserver, kCFRunLoopCommonModes);
    CFRelease(defonserver);
    CFRelease(runloop);

}

- (void)dealloc {
    //释放定时器
    NSLog(@"销毁当前控制器");
}

@end
