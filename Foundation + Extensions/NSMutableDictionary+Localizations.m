
#import "NSMutableDictionary+Localizations.h"

#import "NSDictionary+WBExtensions.h"

#import "PKGLanguageConverter.h"

@implementation NSMutableDictionary (PKG_Localizations)

- (id)valueForLocalization:(NSString *)inLocalization exactMatch:(BOOL)inExactMatch valueSetChecker:(BOOL (^)(id))valueChecker
{
	if (inLocalization==nil)
		return nil;
	
	NSMutableDictionary * tAvailableLocalizations=[self WB_filteredDictionaryUsingBlock:^BOOL(NSString * bLanguage, id bValue) {
		
		return valueChecker(bValue);
	}];
	
	if (tAvailableLocalizations.count==0)
		return nil;
	
	id tValue=tAvailableLocalizations[inLocalization];
	
	if (tValue!=nil)
		return tValue;
	
	if (inExactMatch==YES)
		return nil;
	
	NSString * tISOLanguage=[[PKGLanguageConverter sharedConverter] ISOFromEnglish:inLocalization];
	
	tValue=tAvailableLocalizations[tISOLanguage];
	
	if (tValue!=nil)
		return tValue;
	
	NSArray * tPreferedLocalizations=(__bridge_transfer NSArray *) CFBundleCopyPreferredLocalizationsFromArray((__bridge CFArrayRef) tAvailableLocalizations.allKeys);
	
	if (tPreferedLocalizations==nil)
		return nil;
	
	for(NSString * tLocalization in tPreferedLocalizations)
	{
		tValue=tAvailableLocalizations[tLocalization];
		
		if (tValue!=nil)
			return tValue;
		
		tISOLanguage=[[PKGLanguageConverter sharedConverter] ISOFromEnglish:tLocalization];
		
		tValue=tAvailableLocalizations[tISOLanguage];
		
		if (tValue!=nil)
			return tValue;
	}
	
	return nil;
}

@end
