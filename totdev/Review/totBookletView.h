//
//  totBookletView.h
//  totdev
//
//  Created by Lixing Huang on 6/11/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class totPageElement;

@interface totBookBasicView : UIView {

}

- (void) rotate: (float)r;

@end

@interface totPageElementView : totBookBasicView {
    totPageElement* mData;
}

@property (nonatomic, retain) totPageElement* mData;

- (id)initWithElement:(totPageElement*)data;
- (void)display;

@end


@interface totPageView : UIView {

}

@end

@interface totBookView : UIView {

}

@end