//
//  ViewController.m
//  TestForRunloop
//
//  Created by meitu007 on 2020/2/25.
//  Copyright © 2020 meitu. All rights reserved.
//

#import "ViewController.h"
#import "FPSLabel.h"
#import "RunloopDetective.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    FPSLabel *label = [[FPSLabel alloc] initWithFrame:CGRectMake(5, 85, 100, 50)];
    [self.view addSubview:label];
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 40, 40, 40)];
    testBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:testBtn];
    
    [testBtn addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self emitterAniamtionWithRect:CGRectMake(10, 200, self.view.bounds.size.width-20, 300)];
}

- (void)testAction {
    [NSThread callStackSymbols];
}

- (void)emitterAniamtionWithRect:(CGRect)rect {
    
    UIView *contentView = [[UIView alloc] initWithFrame:rect];
    contentView.backgroundColor = [UIColor lightGrayColor];
    
    //发射器
    CAEmitterLayer *rainEmitter = [CAEmitterLayer layer];
    rainEmitter.emitterShape = kCAEmitterLayerLine;
    rainEmitter.emitterMode = kCAEmitterLayerOutline;
    rainEmitter.emitterSize = rect.size;
    rainEmitter.renderMode = kCAEmitterLayerAdditive;
    rainEmitter.emitterPosition = CGPointMake(rect.size.width/2, 20);
    
    //水滴
    CAEmitterCell *rainflake = [CAEmitterCell emitterCell];
    rainflake.birthRate = 50;   //每秒发出的数量
    //rainflake.speed = 10;   //速度
    rainflake.velocity = 30;   //加速度
    //rainflake.velocityRange = 75;   //加速度范围
    rainflake.yAcceleration = 500;  //重力
    
    rainflake.contents = (id)[UIImage imageNamed:@"rain"].CGImage;
    rainflake.color = [UIColor whiteColor].CGColor;
    rainflake.lifetime = 2;   //生命周期
    rainflake.scale = 0.3;  //缩放
    rainflake.scaleRange = 0.2;

    //水花
    CAEmitterCell *rainSpark = [CAEmitterCell emitterCell];
    
    rainSpark.birthRate         = 1;
    rainSpark.velocity          = 0;
    //rainSpark.emissionRange     = M_PI;//180度
    //rainSpark.yAcceleration     = 40;
    rainSpark.scale             = 0.5;
    rainSpark.contents          = (id)[UIImage imageNamed:@"snow"].CGImage;
    rainSpark.color = [UIColor whiteColor].CGColor;
    rainSpark.lifetime          =  0.3;
    
    //
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate            = 50;       //炸开后产生40花
    spark.velocity             = 50;       //速度
    spark.velocityRange        = 20;
    spark.emissionRange        = M_PI;   // 360 度
    spark.yAcceleration        = 40;         // 重力
    spark.lifetime             = 0.5;
    
    spark.contents          = (id) [[UIImage imageNamed:@"snow"] CGImage];
    spark.scaleSpeed        = 0.2;
    spark.scale             = 0.2;
    spark.color =[UIColor whiteColor].CGColor;
    spark.alphaSpeed        =- 0.25;
    spark.spin              = 2* M_PI;
    spark.spinRange         = 2* M_PI;
    
    rainEmitter.emitterCells    = @[rainflake];
    rainflake.emitterCells      = @[rainSpark];
    rainSpark.emitterCells      = @[spark];
    
    [contentView.layer addSublayer:rainEmitter];
    [self.view addSubview:contentView];
}

@end
