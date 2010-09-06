//
//  Client.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import "Client.h"

#include <svn_client.h>


@implementation Client

- (BOOL)checkout
{
	svn_client_checkout(
						NULL,
						"",
						"",
						NULL,
						1,
						NULL,
						NULL);
						
	return YES;
}

@end
