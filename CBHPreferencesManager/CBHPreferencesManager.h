//  CBHPreferencesManager.h
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

@import Foundation;


FOUNDATION_EXPORT double CBHPreferencesManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char CBHPreferencesManagerVersionString[];


NS_ASSUME_NONNULL_BEGIN

typedef NSString * const CBHPreferencesKey NS_EXTENSIBLE_STRING_ENUM;


@interface CBHPreferencesManager : NSObject

#pragma mark - Class Properties

@property (class, nonatomic, readonly) NSDictionary<CBHPreferencesKey, id> *sharedDefaults;


#pragma mark - Factories

+ (instancetype)sharedManager;


#pragma mark - Initializers

- (instancetype)init;
- (instancetype)initWithDefaults:(NSDictionary *)defaults;
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults andDefaults:(NSDictionary *)defaults NS_DESIGNATED_INITIALIZER;


#pragma mark - Properties

@property (nonatomic, readonly) NSUserDefaults *userDefaults;
@property (nonatomic, readonly) NSDictionary *dictionaryRepresentation;
@property (nonatomic, readonly) NSSet *managedKeys;
@property (nonatomic, readonly) NSUInteger count;


#pragma mark - Utilities

- (BOOL)synchronize;


#pragma mark - Notification

- (void)registerObject:(id)object withSelector:(SEL)selector forChangeOfKey:(CBHPreferencesKey)key;

- (void)unregisterObject:(id)object;
- (void)unregisterObject:(id)object forChangeOfKey:(CBHPreferencesKey)key;

- (void)postNotificationForKey:(CBHPreferencesKey)key withObject:(nullable id)object;

@property (nonatomic, readonly) NSNotificationCenter *notifier;


#pragma mark - Getting Preferences

- (BOOL)hasEntryForKey:(CBHPreferencesKey)key;

- (nullable id)objectForKey:(CBHPreferencesKey)key;

- (nullable NSURL *)urlForKey:(CBHPreferencesKey)key;
- (NSArray *)arrayForKey:(CBHPreferencesKey)key;
- (NSDictionary *)dictionaryForKey:(CBHPreferencesKey)key;
- (NSString *)stringForKey:(CBHPreferencesKey)key;
- (NSData *)dataForKey:(CBHPreferencesKey)key;

- (BOOL)boolForKey:(CBHPreferencesKey)key;

- (NSInteger)integerForKey:(CBHPreferencesKey)key;
- (NSUInteger)unsignedIntegerForKey:(CBHPreferencesKey)key;

- (float)floatForKey:(CBHPreferencesKey)key;
- (double)doubleForKey:(CBHPreferencesKey)key;
- (CGFloat)cgFloatForKey:(CBHPreferencesKey)key;


#pragma mark - Setting Preferences

- (void)setObject:(id)object forKey:(CBHPreferencesKey)key;
- (void)setObject:(id)object forKey:(CBHPreferencesKey)key shouldNotify:(BOOL)shouldNotify;

- (void)setURL:(NSURL *)object forKey:(CBHPreferencesKey)key;

- (void)setBool:(BOOL)flag forKey:(CBHPreferencesKey)key;

- (void)setInteger:(NSInteger)value forKey:(CBHPreferencesKey)key;
- (void)setUnsignedInteger:(NSUInteger)value forKey:(CBHPreferencesKey)key;

- (void)setFloat:(float)value forKey:(CBHPreferencesKey)key;
- (void)setDouble:(double)value forKey:(CBHPreferencesKey)key;
- (void)setCGFloat:(CGFloat)value forKey:(CBHPreferencesKey)key;


#pragma mark - Removing

- (void)removeEntryForKey:(CBHPreferencesKey)key;
- (void)removeEntryForKey:(CBHPreferencesKey)key shouldNotify:(BOOL)shouldNotify;

- (void)removeAllEntries;


#pragma mark - Resetting

- (void)resetWithSharedDefaultForKey:(CBHPreferencesKey)key;
- (void)resetWithSharedDefaults;

- (void)resetWithDefaults:(NSDictionary<CBHPreferencesKey, id> *)defaults;

@end

NS_ASSUME_NONNULL_END
