//
//  ZSBReoprtFormView.m
//  ZSBReoprtFormDemo
//
//  Created by shibing zhang on 2017/11/10.
//  Copyright © 2017年 shibing zhang. All rights reserved.
//

#import "ZSBReoprtFormView.h"
#import "ZSBReportFormViewItemCell.h"

@interface ZSBReoprtFormView()<UICollectionViewDelegate,UICollectionViewDataSource,ZSBReportFormCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ZSBReportFormLayout *layout;

@end

@implementation ZSBReoprtFormView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - initViews

- (void)setupView {
    
    if (self.collectionView == nil) {
        self.layout = [[ZSBReportFormLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        self.collectionView.exclusiveTouch = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.alwaysBounceVertical = YES;
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView registerClass:[ZSBReportFormViewItemCell class] forCellWithReuseIdentifier:@"ZSBReportFormViewItemCell"];
        [self addSubview:_collectionView];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - Data

- (void)setFormDataModel:(ZSBReportFormModel *)formDataModel {
    _formDataModel = formDataModel;
    NSLog(@"began calculate   count = %li",_formDataModel.dataList.count+1);
    [_formDataModel calculateModelSize];
    NSLog(@"end calculate");
    self.layout.lockRows = _formDataModel.lockRows;
    self.layout.lockColumns = _formDataModel.lockColumns;
    [self.layout setWidths:_formDataModel.maxWidths andHeights:_formDataModel.maxHeights];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //行数（包括表头）
    return self.formDataModel.dataList.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //根据表头指定列数
    return self.formDataModel.headerList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSBReportFormViewItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZSBReportFormViewItemCell" forIndexPath:indexPath ];
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    //设置单元行颜色的间隔的控制
    if (indexPath.section % 2 == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
    }else{
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (indexPath.section == 0) {
        cell.rowDatas = @[self.formDataModel.headerList[indexPath.row]];
    }else {
        NSArray *dataList = self.formDataModel.dataList[indexPath.section - 1];
        if ([dataList[indexPath.row] isKindOfClass:[NSArray class]]) {
            cell.rowDatas = dataList[indexPath.row];
        }else {
            cell.rowDatas = @[dataList[indexPath.row]];
        }
    }
    
    return cell;
}

- (void)cell:(id)cell_ didClickOnButton:(ZSBReportFormButton *)clickButton {
    if (self.formButtonClick) {
        self.formButtonClick(clickButton);
    }
}

@end
