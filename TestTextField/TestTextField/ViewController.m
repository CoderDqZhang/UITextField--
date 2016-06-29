//
//  ViewController.m
//  TestTextField
//
//  Created by Zhang on 6/29/16.
//  Copyright © 2016 Zhang. All rights reserved.
//

#import "ViewController.h"

@interface CustomTextView : UITextView

+ (instancetype)setUpTextView:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag;

@end

@implementation CustomTextView

+ (instancetype)setUpTextView:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag
{
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:frame];
    textView.text = [NSString stringWithFormat:@"●%@",text];
    [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    textView.layer.borderColor = [[UIColor redColor] CGColor];
    textView.layer.borderWidth = 0.5;
    [textView setTag:tag];
    textView.font = [UIFont systemFontOfSize:20.0];
    [textView becomeFirstResponder];
    frame.size.height = textView.contentSize.height;
    textView.frame = frame;
    return textView;
}
@end

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, copy) NSMutableArray *stringArray;
@property (nonatomic, assign) CGFloat height;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _stringArray = [NSMutableArray arrayWithArray:@[@"UITextView增加小圆点",@"UITextView增加小圆点",@"UITextView增加小圆点",@"UITextView增加小圆点"]];
    CGFloat height = 70;
    for (NSInteger i = 0; i < _stringArray.count; i ++) {
        CustomTextView *textView = [CustomTextView setUpTextView:CGRectMake(10, height, [[UIScreen mainScreen] bounds].size.width - 20, 0) text:_stringArray[i] tag:i + 1];
        textView.delegate = self;
        height = CGRectGetMaxY(textView.frame) + 10;
        [self.view addSubview:textView];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.tag == 1 && textView.text.length >= 1 && ![[textView.text substringToIndex:1] isEqualToString:@"●"]){
        ;
        textView.text  = [NSString stringWithFormat:@"●%@",textView.text];
    }
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    if (textView.contentSize.height != textView.frame.size.height) {
        CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:textView.tag];
        [self updateFrame:custonmeText];
    }
    textView.frame = frame;
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        NSInteger tag = textView.tag + 1;
        if ((CustomTextView *)[self.view viewWithTag:tag]) {
            CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:tag];
            [custonmeText becomeFirstResponder];
        }else{
            CustomTextView *cutomeText = [CustomTextView setUpTextView:CGRectMake(3, CGRectGetMaxY(textView.frame) + 10, [[UIScreen mainScreen] bounds].size.width - 6, 0) text:@"" tag:tag];
            cutomeText.delegate = self;
            [_stringArray addObject:@"tag"];
            [self.view addSubview:cutomeText];
        }
        return NO;
        
    }else if([text isEqualToString:@""]){
        if(textView.text.length == 1 && (long)textView.tag > 1){
            NSLog(@"%ld",(long)textView.tag);
            if ((long)textView.tag != _stringArray.count) {
                [self updataTag:(CustomTextView *)[self.view viewWithTag:textView.tag]];
            }
            [_stringArray removeLastObject];
            [textView removeFromSuperview];
            NSInteger tag = (long)textView.tag - 1;
            CustomTextView *tempText = (CustomTextView *)[self.view viewWithTag:tag];
            [tempText becomeFirstResponder];
            return NO;
        }else if((long)textView.tag == 1 && textView.text.length == 1){
            if ((long)textView.tag != _stringArray.count) {
                [self updataTag:(CustomTextView *)[self.view viewWithTag:textView.tag]];
            }
            if (_stringArray.count != 1) {
                [_stringArray removeLastObject];
                [textView removeFromSuperview];
            }
            textView.text = @"●";
        }
    }
    return  YES;
}


- (void)updateFrame:(CustomTextView *)textView
{
    CGFloat orignY = textView.contentSize.height + textView.frame.origin.y;
    for (NSInteger i = textView.tag + 1; i <= _stringArray.count + 1; i ++) {
        CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:i];
        CGRect frame = custonmeText.frame;
        frame.origin.y = orignY + 10;
        custonmeText.frame = frame;
        orignY = frame.origin.y + custonmeText.contentSize.height;
    }
}

- (void)updataTag:(CustomTextView *)textView
{
    NSInteger tempTag = textView.tag;
    textView.tag = 100000;
    NSLog(@"%ld",(long)textView.tag);
    for (NSInteger i = tempTag + 1; i <= _stringArray.count + 1; i ++) {
        CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:i];
        [custonmeText setTag:i - 1];
    }
    
    CustomTextView *custonmeText = (CustomTextView *)[self.view viewWithTag:tempTag];
    CGRect frame = custonmeText.frame;
    frame.origin.y = frame.origin.y - 50;
    custonmeText.frame = frame;
    [self updateFrame:custonmeText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
