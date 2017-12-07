//
//  ViewController.m
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) ZSBReoprtFormView *reportFormView;

@property (nonatomic, strong) ZSBReportFormModel *formModel;

@end

@implementation ViewController

//初始化数据
- (void)initData {
    self.formModel = [[ZSBReportFormModel alloc] init];
    self.formModel.lockColumns = 2;
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list" ofType:@"txt"]];
    
    NSDictionary *JSONDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",JSONDic);
    
    NSDictionary *result = JSONDic[@"Result"];
    NSArray *cIndexList = result[@"CIndex"];
    NSDictionary *cIndex = cIndexList.firstObject;
    
    NSArray *allIndexKey = [cIndex keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger value1 = 0;
        NSInteger value2 = 0;
        if ([obj1 isKindOfClass:[NSDictionary class]]) {
            value1 = [obj1[@"Index"] integerValue];
        }else {
            value1 = [obj1 integerValue];
        }
        if ([obj2 isKindOfClass:[NSDictionary class]]) {
            value2 = [obj2[@"Index"] integerValue];
        }else {
            value2 = [obj2 integerValue];
        }
        if (value1 > value2) {
            return NSOrderedDescending;
        }else {
            return NSOrderedAscending;
        }
    }];
    
    NSArray *columns = result[@"Columns"];
    NSDictionary *headerDic = columns.firstObject;
    NSMutableArray *headers = [[NSMutableArray alloc] init];
    for (NSString *key in allIndexKey) {
        if ([cIndex[key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *setDic = cIndex[key][@"SubIndex"];
            NSArray *setIndexKey = [setDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return NSOrderedDescending;
                }else {
                    return NSOrderedAscending;
                }
            }];
            for (NSString *setKey in setIndexKey) {
                ZSBReoprtFormSubModel *model = [[ZSBReoprtFormSubModel alloc] init];
                model.key = setKey;
                model.value = headerDic[setKey];
                [headers addObject:model];
            }
        }else {
            ZSBReoprtFormSubModel *model = [[ZSBReoprtFormSubModel alloc] init];
            model.key = key;
            model.value = headerDic[key];
            [headers addObject:model];
        }
    }
    
    [headers addObject: [ZSBReoprtFormSubModel defaultTitleForKey:@"history" andName:@"历史"]];
    [headers addObject: [ZSBReoprtFormSubModel defaultTitleForKey:@"show" andName:@"检视"]];
    [headers addObject: [ZSBReoprtFormSubModel defaultTitleForKey:@"edit" andName:@"编辑"]];
    [headers addObject: [ZSBReoprtFormSubModel defaultTitleForKey:@"delete" andName:@"删除"]];
    
    self.formModel.headerList = headers;
    
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    NSArray *rows = result[@"Rows"];
    for (int i = 0; i < rows.count; i++) {
        NSMutableArray *rowList = [[NSMutableArray alloc] init];
        NSDictionary *rowDic = rows[i];
        for (NSString *key in allIndexKey) {
            if ([rowDic[key] isKindOfClass:[NSArray class]]) {
                NSArray *subRows = rowDic[key];
                
                NSDictionary *setDic = cIndex[key][@"SubIndex"];
                NSArray *setIndexKey = [setDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    if ([obj1 integerValue] > [obj2 integerValue]) {
                        return NSOrderedDescending;
                    }else {
                        return NSOrderedAscending;
                    }
                }];
                for (NSString *setKey in setIndexKey) {
                    NSMutableArray *subRowList = [[NSMutableArray alloc] init];
                    for (NSDictionary *subRowDic in subRows) {
                        ZSBReoprtFormSubModel *model = [[ZSBReoprtFormSubModel alloc] init];
                        model.key = setKey;
                        model.value = subRowDic[setKey];
                        [subRowList addObject:model];
                    }
                    [rowList addObject:subRowList];
                }
            }else {
                ZSBReoprtFormSubModel *model = [[ZSBReoprtFormSubModel alloc] init];
                model.key = key;
                model.value = rowDic[key];
                [rowList addObject:model];
            }
        }
        [rowList addObject: [ZSBReoprtFormSubModel defaultButtonForKey:@"history" andName:@"历史"]];
        [rowList addObject: [ZSBReoprtFormSubModel defaultButtonForKey:@"show" andName:@"检视"]];
        [rowList addObject: [ZSBReoprtFormSubModel defaultButtonForKey:@"edit" andName:@"编辑"]];
        [rowList addObject: [ZSBReoprtFormSubModel defaultButtonForKey:@"delete" andName:@"删除"]];

        [dataList addObject:rowList];
    }
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1000; i++) {
        [list addObjectsFromArray:dataList];
    }
    
    self.formModel.dataList = list;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
    
    [self setupView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化页面
- (void)setupView {
    self.reportFormView = [[ZSBReoprtFormView alloc] init];
    self.reportFormView.formDataModel = self.formModel;
    [self.view addSubview:self.reportFormView];
    
    self.reportFormView.formButtonClick = ^(ZSBReportFormButton *clickButton) {
        NSLog(@"key = %@; indexPath = %@", clickButton.subModel.key, clickButton.indexPath);
    };
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.reportFormView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
