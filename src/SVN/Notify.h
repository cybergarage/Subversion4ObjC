//
//  Notify.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/11/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#include <svn_client.h>

#import "SVN/Core.h"

@interface Notify : Core {

}
- (id)initWithPool:(Pool *)aPool;
@property(assign) const svn_wc_notify_t *notify;
@end
