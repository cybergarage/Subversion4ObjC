//
//  Client.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SvnObjC/Client.h>

#import <SvnObjC/Apr.h>

#include <svn_client.h>
#include <svn_pools.h>
#include <svn_path.h>

@implementation Client

- (BOOL)checkout
{
	Apr *apr = [Apr sharedInstance];
	/*
	svn_client_ctx_t *ctx;
	apr_pool_t *pool;
	svn_opt_revision_t revision;
	revision.kind = svn_opt_revision_head;
	
	apr_app_initialize(&argc, &argv, NULL); 
	
	//メモリプールの作成
	pool = svn_pool_create(NULL);
	
	//クライアントコンテキストを作成
	svn_client_create_context(&ctx, pool);
	*/
	
	return YES;
}

@end
