//
//  CXOverlayView.h
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXTransport.h"

@interface CXOverlayView : UIView <CXTransport>


@property (nonatomic,weak) id<CXTransportDelegate> delete;

@end
