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

static svn_error_t *
cg_svnobjc_auth_ssl_server_trust_prompt(
										svn_auth_cred_ssl_server_trust_t **cred_p,
										void *baton,
										const char *realm,
										apr_uint32_t failures,
										const svn_auth_ssl_server_cert_info_t *cert_info,
										svn_boolean_t may_save,
										apr_pool_t *pool);

@implementation AuthCred

@synthesize user;
@synthesize password;
@synthesize realm;

- (id)init
{
	if ((self = [super init])) {
		[self setUser:@""];
		[self setPassword:@""];
		[self setRealm:@""];
	}
	return self;	
}

-(void)dealloc
{
    self.user = nil;
    self.password = nil;
    self.realm = nil;
    
	[super dealloc];
}

-(BOOL)hasUser
{
	if (user == nil)
		return NO;
	if ([user length] <= 0)
		return NO;
	return YES;
}

-(BOOL)hasPassword;
{
	if (password == nil)
		return NO;
	if ([password length] <= 0)
		return NO;
	return YES;
}

@end

@implementation Auth

@synthesize delegate;
@synthesize providers;
@synthesize delegateObject;

- (id)init
{
	if ((self = [super init])) {
		
		[self setProviders:apr_array_make ([self pool], 4, sizeof (svn_auth_provider_object_t *))];
		
		svn_auth_provider_object_t *provider;
		
		svn_auth_get_ssl_server_trust_prompt_provider (&provider,
											   cg_svnobjc_auth_ssl_server_trust_prompt,
											   self, /* baton */
											   [self pool]);
		APR_ARRAY_PUSH ([self providers], svn_auth_provider_object_t *) = provider;
		
		svn_auth_get_simple_prompt_provider(
											&provider,
											cg_svnobjc_simple_prompt_callback,
											self, /* baton */
											2, /* retry limit */
											[self pool]);
		APR_ARRAY_PUSH ([self providers], svn_auth_provider_object_t *) = provider;
		
		svn_auth_get_username_prompt_provider (&provider,
											   cg_svnobjc_username_prompt_callback,
											   self, /* baton */
											   2, /* retry limit */ 
											   [self pool]);
		
		APR_ARRAY_PUSH ([self providers], svn_auth_provider_object_t *) = provider;
	}
	return self;	
}

-(void)dealloc
{
	[super dealloc];
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
	
	if (realm)
		[authCred setRealm:[NSString stringWithUTF8String:realm]];
	
	 if (username)
		[authCred setUser:[NSString stringWithUTF8String:username]];
	
	if (![[svnAuth delegate] simplePrompt:authCred object:[svnAuth delegateObject]]) {
		[authCred release];
		return SVN_NO_ERROR;
	}
	
	svn_auth_cred_simple_t *credRet = apr_pcalloc (pool, sizeof (*credRet));
	if ([authCred user] != nil)
		credRet->username = apr_pstrdup (pool, [[authCred user] UTF8String]);
	if ([authCred password] != nil)
		credRet->password = apr_pstrdup (pool,  [[authCred password] UTF8String]);

	[authCred release];
	
	*cred = credRet;
	return SVN_NO_ERROR;
}


/* A tiny callback function of type 'svn_auth_username_prompt_func_t'. For
 a much better example, see svn_cl__auth_username_prompt in the official
 svn cmdline client. */
static svn_error_t *
cg_svnobjc_username_prompt_callback (svn_auth_cred_username_t **cred,
                             void *baton,
                             const char *realm,
                             svn_boolean_t may_save,
                             apr_pool_t *pool)
{
	Auth *svnAuth = (Auth *)baton;
	
	AuthCred *authCred = [[AuthCred alloc] init];
	
	if (realm)
		[authCred setRealm:[NSString stringWithUTF8String:realm]];

	if (![[svnAuth delegate] usernamePrompt:authCred object:[svnAuth delegateObject]]) {
		[authCred release];
		return SVN_NO_ERROR;
	}
	
	svn_auth_cred_username_t *credRet = apr_pcalloc (pool, sizeof (*credRet));
	if ([authCred user] != nil)
		credRet->username = apr_pstrdup (pool, [[authCred user] UTF8String]);
	
	[authCred release];
	
	*cred = credRet;
	return SVN_NO_ERROR;
}

static svn_error_t *
cg_svnobjc_auth_ssl_server_trust_prompt
(svn_auth_cred_ssl_server_trust_t **cred_p,
 void *baton,
 const char *realm,
 apr_uint32_t failures,
 const svn_auth_ssl_server_cert_info_t *cert_info,
 svn_boolean_t may_save,
 apr_pool_t *pool)
{
	*cred_p = apr_pcalloc(pool, sizeof(**cred_p));
	(*cred_p)->may_save = FALSE;
	(*cred_p)->accepted_failures = failures;
	
	return SVN_NO_ERROR;
}