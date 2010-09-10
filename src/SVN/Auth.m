//
//  Auth.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import "Auth.h"

static svn_error_t *
cg_svnobjc_simple_prompt_callback (svn_auth_cred_simple_t **cred,
								   void *baton,
								   const char *realm,
								   const char *username,
								   svn_boolean_t may_save,
								   apr_pool_t *pool);

static svn_error_t *
cg_svnobjc_username_prompt_callback (svn_auth_cred_username_t **cred,
									 void *baton,
									 const char *realm,
									 svn_boolean_t may_save,
									 apr_pool_t *pool);

@implementation AuthCred

@synthesize username;
@synthesize password;

- (id)init
{
	if (self = [super init]) {
		[self setUsername:@""];
		[self setPassword:@""];
	}
	return self;	
}

@end

@implementation Auth

@synthesize delegate;
@synthesize providers;

- (id)initWithPool:(Pool *)aPool
{
	if (self = [super initWithPool:aPool]) {
		
		[self setProviders:apr_array_make ([[self pool] pool], 4, sizeof (svn_auth_provider_object_t *))];
		
		svn_auth_provider_object_t *provider;
		
		svn_auth_get_simple_prompt_provider(
											&provider,
											cg_svnobjc_simple_prompt_callback,
											self, /* baton */
											2, /* retry limit */
											[[self pool] pool]);
		APR_ARRAY_PUSH ([self providers], svn_auth_provider_object_t *) = provider;
		
		svn_auth_get_username_prompt_provider (&provider,
											   cg_svnobjc_username_prompt_callback,
											   self, /* baton */
											   2, /* retry limit */ 
											   [[self pool] pool]);
		
		APR_ARRAY_PUSH ([self providers], svn_auth_provider_object_t *) = provider;
	}
	return self;	
}

@end

static svn_error_t *
cg_svnobjc_simple_prompt_callback (svn_auth_cred_simple_t **cred,
                           void *baton,
                           const char *realm,
                           const char *username,
                           svn_boolean_t may_save,
                           apr_pool_t *pool)
{
	Auth *svnAuth = (Auth *)baton;
	
	if (![svnAuth delegate]) {
		return SVN_NO_ERROR;
	}
	
	AuthCred *authCred = [[AuthCred alloc] init];
	if (username)
		[authCred setUsername:[NSString stringWithUTF8String:username]];
	
	if (![[svnAuth delegate] simplePrompt:authCred]) {
		[authCred release];
		return SVN_NO_ERROR;
	}
	
	svn_auth_cred_simple_t *credRet = apr_pcalloc ([[svnAuth pool] pool], sizeof (*credRet));
	if ([authCred username] != nil)
		credRet->username = apr_pstrdup ([[svnAuth pool] pool], [[authCred username] UTF8String]);
	if ([authCred password] != nil)
		credRet->password = apr_pstrdup ([[svnAuth pool] pool],  [[authCred password] UTF8String]);

	[authCred release];
	
	return SVN_NO_ERROR;
}


/* A tiny callback function of type 'svn_auth_username_prompt_func_t'. For
 a much better example, see svn_cl__auth_username_prompt in the official
 svn cmdline client. */
 svn_error_t *
cg_svnobjc_username_prompt_callback (svn_auth_cred_username_t **cred,
                             void *baton,
                             const char *realm,
                             svn_boolean_t may_save,
                             apr_pool_t *pool)
{
	Auth *svnAuth = (Auth *)baton;
	
	AuthCred *authCred = [[AuthCred alloc] init];
	
	if (![[svnAuth delegate] usernamePrompt:authCred]) {
		[authCred release];
		return SVN_NO_ERROR;
	}
	
	svn_auth_cred_simple_t *credRet = apr_pcalloc ([[svnAuth pool] pool], sizeof (*credRet));
	if ([authCred username] != nil)
		credRet->username = apr_pstrdup ([[svnAuth pool] pool], [[authCred username] UTF8String]);
	
	[authCred release];
	
	return SVN_NO_ERROR;
}
