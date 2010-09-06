//
//  Client.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Svn/Client.h>

#import <Apr/Apr.h>
#import <Svn/Pool.h>

#include <svn_client.h>
#include <svn_pools.h>
#include <svn_path.h>

@implementation Client

- (id)initWithPool:(Pool *)aPool
{
	if (self = [super init]) {
		svn_client_create_context(&ctx, [aPool pool]);
	}
	return self;	
}

- (BOOL)checkout
{
	Apr *apr = [Apr sharedInstance];
	
	/*
	 svn_client_ctx_t *ctx;
	 apr_pool_t *pool;
	 svn_opt_revision_t revision;
	 revision.kind = svn_opt_revision_head;
	 //↑HEADをとってくるように指定
	 
	 //aprの初期化
	 apr_app_initialize(&argc, &argv, NULL); 
	 
	 //メモリプールの作成
	 pool = svn_pool_create(NULL);
	 
	 //クライアントコンテキストを作成
	 svn_client_create_context(&ctx, pool);
	 
	 //認証プロバイダを作る
	 svn_auth_provider_object_t *provider;
	 apr_array_header_t *providers
	 = apr_array_make (pool, 1, sizeof (svn_auth_provider_object_t *));
	 svn_client_get_simple_provider (&provider, pool);
	 APR_ARRAY_PUSH (providers, svn_auth_provider_object_t *) = provider;
	 
	 //プロバイダをコンテキストに渡す
	 svn_auth_baton_t *ab;
	 svn_auth_open (&ab, providers, pool);
	 ctx->auth_baton = ab;
	 
	 //ターゲットディレクトリを正規化
	 const char *target_dir = "./test/";
	 target_dir = svn_path_uri_decode(target_dir, pool);
	 target_dir = svn_path_canonicalize (target_dir, pool);
	 
	 //SVNリポジトリURLの正規化
	 const char *true_url = "http://www.hogehoge.com/foofoo/";
	 true_url = svn_path_canonicalize (true_url, pool);
	 
	 //やっとチェックアウト
	 svn_error_t *err = svn_client_checkout(NULL, true_url, target_dir, 
	 &revision, TRUE, ctx, pool);	
	 
	 //エラー処理
	 if(err) printf("END %s\n", err->message);
	 
	 return 0;
	 }
	 */
	
	return YES;
}

@end
