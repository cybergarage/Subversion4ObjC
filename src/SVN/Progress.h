//
//  Progress.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/11/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Core.h>

@interface Progress : Core {

}
@property(assign) int position;
@property(assign) int total;
- (id)init;
@end
