
#import "NSDictionary+WBMapping.h"

@implementation NSDictionary (WBExtensions)

- (instancetype)WB_dictionaryByMappingObjectsUsingBlock:(id (^)(id bKey,id bObject))inBlock
{
	if (inBlock==nil)
		return self;
	
	__block NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	[self enumerateKeysAndObjectsUsingBlock:^(id bKey, id bObject, BOOL *bOutStop) {
		id tObject=inBlock(bKey,bObject);
		
		if (tObject==nil)
		{
			*bOutStop=YES;
			tMutableDictionary=nil;
		}
		else
		{
			tMutableDictionary[bKey]=tObject;
		}
	}];
	
	if ([self isKindOfClass:[NSMutableDictionary class]]==YES)
		return tMutableDictionary;
	
	return [tMutableDictionary copy];
}

- (instancetype)WB_dictionaryByMappingObjectsLenientlyUsingBlock:(id (^)(id bKey,id bObject))inBlock
{
	if (inBlock==nil)
		return self;
	
	NSMutableDictionary * tMutableDictionary=[NSMutableDictionary dictionary];
	
	[self enumerateKeysAndObjectsUsingBlock:^(id bKey, id bObject, BOOL *bOutStop) {
		id tObject=inBlock(bKey,bObject);
		
		if (tObject!=nil)
			tMutableDictionary[bKey]=tObject;
	}];
	
	if ([self isKindOfClass:[NSMutableDictionary class]]==YES)
		return tMutableDictionary;
	
	return [tMutableDictionary copy];
}

@end