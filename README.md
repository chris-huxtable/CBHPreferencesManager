# CBHPreferencesManager

[![release](https://img.shields.io/github/release/chris-huxtable/CBHPreferencesManager.svg)](https://github.com/chris-huxtable/CBHPreferencesManager/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHPreferencesManager.svg)](https://cocoapods.org/pods/CBHPreferencesManager)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHPreferencesManager/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-95%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHPreferencesManager)

An easy-to-use preferences manager. Additionally includes a notification system.


## Examples:

Gets the shared manager, registers a call back for a key, and changes the key, after which the callback will be executed.
```objective-c

CBHPreferencesKey NameKey = @"NameKey";

// ...

CBHPreferencesManager *manager = [CBHPreferencesManager sharedManager];
[manager registerObject:self withSelector:@selector(nameChanged:) forChangeOfKey:NameKey];
[manager setObject@"Chris Huxtable" forKey:NameKey];


// ...

- (void)nameChanged:(NSNotification *)notification
{
	NSLog(@"Name Changed to %@", [notification object]);
}
```


## Licence
CBHPreferencesManager is available under the [ISC license](https://github.com/chris-huxtable/CBHPreferencesManager/blob/master/LICENSE).
