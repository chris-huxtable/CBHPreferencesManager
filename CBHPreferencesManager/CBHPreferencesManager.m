//  CBHPreferencesManager.m
//  CBHPreferencesManager
//
//  Created by Christian Huxtable <chris@huxtable.ca>, November 2017.
//  Copyright (c) 2017 Christian Huxtable. All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#import "CBHPreferencesManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHPreferencesManager ()
{
	@private

	NSNotificationCenter *_notifier;
	NSUserDefaults *_userDefaults;
	NSMutableSet<CBHPreferencesKey> *_managedKeys;
}

@end

NS_ASSUME_NONNULL_END


@implementation CBHPreferencesManager

#pragma mark - Class Properties

+ (NSDictionary<CBHPreferencesKey, id> *)sharedDefaults
{
	return @{};
}


#pragma mark - Factories

+ (instancetype)sharedManager
{
	static CBHPreferencesManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[[self class] alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults] andDefaults:[self sharedDefaults]];
	});
	return sharedManager;
}


#pragma mark - Initializers

- (instancetype)init
{
	return [self initWithUserDefaults:[NSUserDefaults standardUserDefaults] andDefaults:[[self class] sharedDefaults]];
}

- (instancetype)initWithDefaults:(NSDictionary *)defaults
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	return [self initWithUserDefaults:userDefaults andDefaults:defaults];
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults andDefaults:(NSDictionary *)defaults
{
	if ( self = [super init] )
	{
		_notifier = [[NSNotificationCenter alloc] init];
		_userDefaults = userDefaults;
		_managedKeys = [NSMutableSet setWithCapacity:[defaults count]];

		/// Setup Defaults
		[self setupDefaults:defaults];
		for (CBHPreferencesKey key in [defaults keyEnumerator])
		{
			[_managedKeys addObject:key];
		}
	}

	return self;
}


#pragma mark - Properties

@synthesize userDefaults = _userDefaults;

- (NSDictionary<CBHPreferencesKey, id> *)dictionaryRepresentation
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[_managedKeys count]];

	for (CBHPreferencesKey key in _managedKeys)
	{
		id object = [self objectForKey:key];
		[dictionary setObject:object forKey:key];
	}

	return dictionary;
}

@synthesize managedKeys = _managedKeys;

- (NSUInteger)count
{
	return [_managedKeys count];
}


#pragma mark - Utilities

- (BOOL)synchronize
{
	return [_userDefaults synchronize];
}


#pragma mark - Notification

- (void)registerObject:(id)object withSelector:(SEL)selector forChangeOfKey:(CBHPreferencesKey)key
{
	[_notifier addObserver:object selector:selector name:key object:nil];
}

- (void)unregisterObject:(id)object
{
	[_notifier removeObserver:object];
}

- (void)unregisterObject:(id)object forChangeOfKey:(CBHPreferencesKey)key
{
	[_notifier removeObserver:object name:key object:nil];
}

- (void)postNotificationForKey:(CBHPreferencesKey)key withObject:(id)object
{
	NSNotificationCenter * __weak notifier = _notifier;
	dispatch_async(dispatch_get_main_queue(), ^{
		[notifier postNotificationName:key object:object];
	});
}

@synthesize notifier = _notifier;


#pragma mark - Getting Preferences

- (BOOL)hasEntryForKey:(CBHPreferencesKey)key
{
	return [_managedKeys containsObject:key];
}

- (id)objectForKey:(CBHPreferencesKey)key
{
	return [_userDefaults objectForKey:key];
}


- (NSURL *)urlForKey:(CBHPreferencesKey)key
{
	NSString *string = [self objectForKey:key];
	if ( string == nil ) { return nil; }

	return [NSURL URLWithString:string];
}

- (NSArray *)arrayForKey:(CBHPreferencesKey)key
{
	NSArray *array = [self objectForKey:key];
	return ( array != nil ) ? array : @[];
}

- (NSDictionary *)dictionaryForKey:(CBHPreferencesKey)key
{
	NSDictionary *dictionary = [self objectForKey:key];
	return ( dictionary != nil ) ? dictionary : @{};
}

- (NSString *)stringForKey:(CBHPreferencesKey)key
{
	NSString *string = [self objectForKey:key];
	return ( string != nil ) ? string : @"";
}

- (NSData *)dataForKey:(CBHPreferencesKey)key
{
	NSData *data = [self objectForKey:key];
	return ( data != nil ) ? data : [NSData data];
}


- (BOOL)boolForKey:(CBHPreferencesKey)key
{
	return [[self objectForKey:key] boolValue];
}


- (NSInteger)integerForKey:(CBHPreferencesKey)key
{
	return [[self objectForKey:key] integerValue];
}

- (NSUInteger)unsignedIntegerForKey:(CBHPreferencesKey)key
{
	return (NSUInteger)[self integerForKey:key];
}


- (float)floatForKey:(CBHPreferencesKey)key
{
	return [[self objectForKey:key] floatValue];
}

- (double)doubleForKey:(CBHPreferencesKey)key
{
	return [[self objectForKey:key] doubleValue];
}

- (CGFloat)cgFloatForKey:(CBHPreferencesKey)key
{
	#if CGFLOAT_IS_DOUBLE
		return [[self objectForKey:key] doubleValue];
	#else
		return [[self objectForKey:key] floatValue];
	#endif
}


#pragma mark - Setting Preferences

- (void)setObject:(id)object forKey:(CBHPreferencesKey)key
{
	[self setObject:object forKey:key shouldNotify:YES];
}

- (void)setObject:(id)object forKey:(CBHPreferencesKey)key shouldNotify:(BOOL)shouldNotify
{
	id old = [self objectForKey:key];
	if ( old != nil && (object == old || [object isEqual:old]) )
	{
		[_managedKeys addObject:key];
		return;
	}

	[_userDefaults setObject:object forKey:key];
	[_managedKeys addObject:key];

	if ( shouldNotify ) { [self postNotificationForKey:key withObject:object]; }
}

- (void)setURL:(NSURL *)url forKey:(CBHPreferencesKey)key
{
	[self setObject:[url relativeString] forKey:key];
}


- (void)setBool:(BOOL)flag forKey:(CBHPreferencesKey)key
{
	[self setObject:(flag ? @YES : @NO) forKey:key];
}


- (void)setInteger:(NSInteger)value forKey:(CBHPreferencesKey)key
{
	[self setObject:@(value) forKey:key];
}

- (void)setUnsignedInteger:(NSUInteger)value forKey:(CBHPreferencesKey)key
{
	[self setInteger:(NSInteger)value forKey:key];
}


- (void)setFloat:(float)value forKey:(CBHPreferencesKey)key
{
	[self setObject:@(value) forKey:key];
}

- (void)setDouble:(double)value forKey:(CBHPreferencesKey)key
{
	[self setObject:@(value) forKey:key];
}

- (void)setCGFloat:(CGFloat)value forKey:(CBHPreferencesKey)key
{
	[self setObject:@(value) forKey:key];
}


#pragma mark - Removing

- (void)removeEntryForKey:(CBHPreferencesKey)key
{
	[self removeEntryForKey:key shouldNotify:YES];
}

- (void)removeEntryForKey:(CBHPreferencesKey)key shouldNotify:(BOOL)shouldNotify
{
	[_managedKeys removeObject:key];
	[_userDefaults removeObjectForKey:key];

	if ( shouldNotify) { [self postNotificationForKey:key withObject:nil]; }
}

- (void)removeAllEntries
{
	NSSet *keys = [_managedKeys copy];
	for (CBHPreferencesKey key in keys)
	{
		[self removeEntryForKey:key];
	}
}


#pragma mark - Defaults

- (void)resetWithSharedDefaultForKey:(CBHPreferencesKey)key
{
	id object = [[[self class] sharedDefaults] objectForKey:key];
	if ( object ) { [self setObject:object forKey:key]; }
	else { [self removeEntryForKey:key]; }
}

- (void)resetWithSharedDefaults
{
	[self resetWithDefaults:[[self class] sharedDefaults]];
}


- (void)resetWithDefaults:(NSDictionary<CBHPreferencesKey, id> *)defaults
{
	[self removeAllEntries];

	for (CBHPreferencesKey key in [defaults keyEnumerator])
	{
		[self setObject:[defaults objectForKey:key] forKey:key];
	}
}


- (void)setupDefaults:(NSDictionary<CBHPreferencesKey, id> *)defaults
{
	for (CBHPreferencesKey key in [defaults keyEnumerator])
	{
		if ( ![_userDefaults objectForKey:key] ) { [_userDefaults setObject:[defaults objectForKey:key] forKey:key]; }
	}
}

@end
