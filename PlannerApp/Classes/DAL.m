#import "DAL.h"
#import "NSString+Extensions.h"

@implementation DAL

static BOOL inOperation;

+ (BOOL)isInOperation {
	return inOperation;
}


+ (void)setInOperation:(BOOL)operationFlag {
	inOperation = operationFlag;
}


- (id)initDatabase:(NSString *)dbName {
	if (self = [super init]) {
		
		
		//NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		NSString *documentsDir = [documentPaths objectAtIndex:0];
		//databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
		
		NSString *dbPath = [dbName pathInDocumentDirectory];
		
		//NSString *dbPath = [documentsDir stringByAppendingPathComponent:dbName];

		if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK)
			dbAccessError = YES;
	}
	
	return self;
}

- (NSMutableDictionary *)executeDataSet:(NSString *)strQuery {
	NSMutableDictionary  *dctResult = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    NSLog(@"%@",strQuery);
	const char *sql = [strQuery UTF8String];
	sqlite3_stmt *selectStatement;

	//prepare the select statement
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		sqlite3_bind_text(selectStatement, 1, sql, -1, SQLITE_TRANSIENT);
		//loop all the rows returned by the query.
		NSMutableArray *arrColumns = [[NSMutableArray alloc] initWithCapacity:0];
		for (int i=0; i<sqlite3_column_count(selectStatement); i++) 
		{
			const char *st = sqlite3_column_name(selectStatement, i);
			[arrColumns addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
		}
		int intRow =1;
		while(sqlite3_step(selectStatement) == SQLITE_ROW)
		{
			NSMutableDictionary *dctRow = [[NSMutableDictionary alloc] initWithCapacity:0];
			for (int i=0; i<sqlite3_column_count(selectStatement); i++) 				
			{
				int intValue = 0;
				double dblValue =0;
				const char *strValue;
				switch (sqlite3_column_type(selectStatement,i)) 
				{
					case SQLITE_INTEGER:
						intValue  = (int)sqlite3_column_int(selectStatement, i);
						[dctRow setObject:[NSString stringWithFormat:@"%d",intValue] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_FLOAT:
						dblValue = (double)sqlite3_column_double(selectStatement, i);
						[dctRow setObject:[NSString stringWithFormat:@"%f",dblValue] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_TEXT:
						 strValue = (const char *)sqlite3_column_text(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_BLOB:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_NULL:
						[dctRow setObject:@"" forKey:[arrColumns objectAtIndex:i]];						
						break;
					default:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
				}
				
			}
			[dctResult setObject:dctRow forKey:[NSString stringWithFormat:@"Table%d",intRow]];
			[dctRow release];
			intRow ++;
		}
		[arrColumns release];
	}
	
	sqlite3_reset(selectStatement);
	
	return [dctResult autorelease];
}
- (NSMutableArray *)SelectWithStar:(NSString *)strTableName
{
    NSMutableArray  *arryResult = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *strSelect=@"SELECT";
    
     NSString *strStar=@" * ";
    NSString *strFrom=@"FROM ";
    NSMutableString *query=[[NSMutableString alloc]init];

    [query appendString:strSelect];
    [query appendString:strStar];
    [query appendString:strFrom];
    [query appendString:strTableName];
    
    NSLog(@"str tenp:%@",query);
    
    
    
	const char *sql = [query UTF8String];
	sqlite3_stmt *selectStatement;
	
	//prepare the select statement
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		sqlite3_bind_text(selectStatement, 1, sql, -1, SQLITE_TRANSIENT);
		//loop all the rows returned by the query.
		NSMutableArray *arrColumns = [[NSMutableArray alloc] initWithCapacity:0];
		for (int i=0; i<sqlite3_column_count(selectStatement); i++) 
		{
			const char *st = sqlite3_column_name(selectStatement, i);
			[arrColumns addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
		}
		int intRow =1;
		while(sqlite3_step(selectStatement) == SQLITE_ROW)
		{
			NSMutableDictionary *dctRow = [[NSMutableDictionary alloc] initWithCapacity:0];
			for (int i=0; i<sqlite3_column_count(selectStatement); i++) 				
			{
				int intValue = 0;
				double dblValue =0;
				const char *strValue;
				switch (sqlite3_column_type(selectStatement,i)) 
				{
					case SQLITE_INTEGER:
						intValue  = (int)sqlite3_column_int(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithInt:intValue] forKey:[arrColumns objectAtIndex:i]];
						break;
					case SQLITE_FLOAT:
						dblValue = (double)sqlite3_column_double(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithDouble:dblValue] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_TEXT:
						strValue = (const char *)sqlite3_column_text(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_BLOB:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_NULL:
						[dctRow setObject:@"" forKey:[arrColumns objectAtIndex:i]];						
						break;
					default:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
				}
				
			}
			[arryResult addObject:dctRow];
			[dctRow release];
			intRow ++;
		}
		
		[arrColumns release];
	}
	
	sqlite3_reset(selectStatement);
	return [arryResult autorelease];
}

- (int)executeScalar:(NSString *)strQuery {
    
	int intResult = -1;
	const char *chrQuery = [strQuery UTF8String];
	sqlite3_stmt *sqlStatement;
	
	int returnValue = sqlite3_prepare_v2(database, chrQuery, -1, &sqlStatement, NULL);
	if(returnValue == SQLITE_OK)
	{		
		returnValue = sqlite3_step(sqlStatement);
		if(returnValue == SQLITE_DONE)
		{
			intResult = 0;
		}
	}
	
	sqlite3_reset(sqlStatement);
	return intResult;
}


- (NSString *)getValueOfObject:(NSObject *)object {
	NSString *value = nil;
	
	if ([object isKindOfClass:[NSString class]]) {
		NSString *bindString = [(NSString *)object bindSQLCharacters];
		value = [NSString stringWithFormat:@"'%@'", bindString];
	}
	else if ([object isKindOfClass:[NSNumber class]]) {
		NSNumber *number = (NSNumber *)object;
		const char *objCType = [number objCType];
		
		if (strcmp(objCType, "i") == 0) {
			value = [NSString stringWithFormat:@"%d", [number intValue]];
		}
		else if (strcmp(objCType, "f") == 0) {
			value = [NSString stringWithFormat:@"%f", [number floatValue]];
		}
		else if (strcmp(objCType, "d") == 0) {
			value = [NSString stringWithFormat:@"%lf", [number doubleValue]];
		}
		else if (strcmp(objCType, "c") == 0) {
			value = [NSString stringWithFormat:@"%d", [number intValue]];
		}
		else if (strcmp(objCType, "s") == 0) {
			value = [NSString stringWithFormat:@"%d", [number shortValue]];
		}
	}
	else if ([object isKindOfClass:[NSArray class]]) {
		// handle it.
	}
	else if ([object isKindOfClass:[NSDictionary class]]) {
		// handle it.
	}
	else { // if no matches found, consider it as a string.
		NSString *bindString = [(NSString *)object bindSQLCharacters];
		value = [NSString stringWithFormat:@"'%@'", bindString];
	}
	
	return value;
}


- (BOOL)isRecordAvailable:(NSDictionary *)record forID:(NSString *)idKey inTable:(NSString *)table {
	NSObject *object = [record objectForKey:idKey];
	NSString *value = [self getValueOfObject:object];
	
	NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=%@;", table, idKey, value];
	const char *chrQuery = [strQuery UTF8String];
	sqlite3_stmt *sqlStatement;
	
	int returnValue = sqlite3_prepare_v2(database, chrQuery, -1, &sqlStatement, NULL);
	if(returnValue == SQLITE_OK) {
		if(sqlite3_step(sqlStatement) == SQLITE_ROW) {
			sqlite3_reset(sqlStatement);
			return YES;
		}
	}
	
	sqlite3_reset(sqlStatement);
	return NO;
}


- (void)updateRecord:(NSDictionary *)record forID:(NSString *)idKey inTable:(NSString *)table  withValue:(NSString *)strValue{
	
	NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET ", table];
	
	int ctr = 1;
	//int totalKeys = [[record allKeys] count];
	BOOL keyFound = NO;

	for (NSString *key in [record allKeys]) {
		if ([key isEqualToString:idKey]) {
			keyFound = YES;
			ctr++;
			continue;
		}
		
		NSObject *object = [record objectForKey:key];
		NSString *value = [self getValueOfObject:object];
		
		query = [query stringByAppendingFormat:@"%@=%@", key, value];


		
		query = [query stringByAppendingString:@","];
		
		ctr++;
	}

    query = [query substringToIndex:[query length] - 1];
    
	query = [query stringByAppendingFormat:@" WHERE %@%@;", idKey, strValue];
    
    NSLog(@"Query:%@",query);
	
	[self executeScalar:query];
    
}


- (void)insertRecord:(NSDictionary *)record inTable:(NSString *)table {
	
	NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (", table];
	NSString *values = @"(";
	
	int ctr = 1;
	int totalKeys = [[record allKeys] count];
	for (NSString *key in [record allKeys]) {
		
		NSObject *object = [record objectForKey:key];
		NSString *value = [self getValueOfObject:object];
		
		query = [query stringByAppendingFormat:@"%@", key];
		values = [values stringByAppendingFormat:@"%@", value];

		if (ctr != totalKeys) {
			query = [query stringByAppendingString:@", "];
			values = [values stringByAppendingString:@", "];
		}
		else {
			query = [query stringByAppendingString:@") VALUES "];
			values = [values stringByAppendingString:@");"];
		}	
		
		ctr++;
	}

	query = [query stringByAppendingString:values];
	
	[self executeScalar:query];
}


//- (void)addUpdateRecord:(NSDictionary *)record forID:(NSString *)idKey inTable:(NSString *)table {
//	if ([self isRecordAvailable:record forID:idKey inTable:table]) {
//		[self updateRecord:record forID:idKey inTable:table];
//	}
//	else {
//		[self insertRecord:record inTable:table];
//	}
//}


- (NSMutableArray *)executeArraySet:(NSString *)strTableName withColumn:(NSArray *)arrcolumn
{
	NSMutableArray  *arryResult = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *strSelect=@"SELECT ";
    NSString *strComma=@",";
   // NSString *strStar=@" * ";
    NSString *strFrom=@" FROM ";
    NSMutableString *query=[[NSMutableString alloc]init];
    NSMutableString *strtemp=[[NSMutableString alloc]init];
    
    [query appendString:strSelect];
    for(int i=0;i<[arrcolumn count];i++)
    {
        [query appendString:[arrcolumn objectAtIndex:i]];
        [query appendString:strComma];
        
    }
    NSString *strQueryStar=[NSString stringWithFormat:@"%@",query];
    strQueryStar = [strQueryStar substringToIndex:[strQueryStar length] - 1];
    [strtemp appendString:strQueryStar];

    [strtemp appendString:strFrom];
    [strtemp appendString:strTableName];
    
    NSLog(@"str tenp:%@",strtemp);
    

    
	const char *sql = [strtemp UTF8String];
	sqlite3_stmt *selectStatement;
	
	//prepare the select statement
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		sqlite3_bind_text(selectStatement, 1, sql, -1, SQLITE_TRANSIENT);
		//loop all the rows returned by the query.
		NSMutableArray *arrColumns = [[NSMutableArray alloc] initWithCapacity:0];
		for (int i=0; i<sqlite3_column_count(selectStatement); i++) 
		{
			const char *st = sqlite3_column_name(selectStatement, i);
			[arrColumns addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
		}
		int intRow =1;
		while(sqlite3_step(selectStatement) == SQLITE_ROW)
		{
			NSMutableDictionary *dctRow = [[NSMutableDictionary alloc] initWithCapacity:0];
			for (int i=0; i<sqlite3_column_count(selectStatement); i++) 				
			{
				int intValue = 0;
				double dblValue =0;
				const char *strValue;
				switch (sqlite3_column_type(selectStatement,i)) 
				{
					case SQLITE_INTEGER:
						intValue  = (int)sqlite3_column_int(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithInt:intValue] forKey:[arrColumns objectAtIndex:i]];
						break;
					case SQLITE_FLOAT:
						dblValue = (double)sqlite3_column_double(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithDouble:dblValue] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_TEXT:
						strValue = (const char *)sqlite3_column_text(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_BLOB:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_NULL:
						[dctRow setObject:@"" forKey:[arrColumns objectAtIndex:i]];						
						break;
					default:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
				}
				
			}
			[arryResult addObject:dctRow];
			[dctRow release];
			intRow ++;
		}
		
		[arrColumns release];
	}
	
	sqlite3_reset(selectStatement);
	return [arryResult autorelease];
}


- (int)deleteFromTable:(NSString*)strTable WhereField:(NSString*)strField Condition:(NSString*)strCondition{
	NSString *strQuery = [NSString stringWithFormat:@"delete from %@ where %@ %@",strTable,strField,strCondition];
    
    NSLog(@"%@",strQuery);
	int intResult = -1;
	const char *chrQuery = [strQuery UTF8String];
	sqlite3_stmt *sqlStatement;
	
	int returnValue = sqlite3_prepare_v2(database, chrQuery, -1, &sqlStatement, NULL);
	if(returnValue == SQLITE_OK)
	{		
		returnValue = sqlite3_step(sqlStatement);
		if(returnValue == SQLITE_DONE)
		{
			intResult = 0;
		}
	}
	
	sqlite3_reset(sqlStatement);
	return intResult;
}
- (NSMutableArray *)SelectQuery:(NSString *)strTableName withColumn:(NSArray *)arrColumnName withCondition:(NSString *)strColumnCondition withColumnValue:(NSString *)strComumnValue
{
    NSMutableArray  *arryResult = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *strSelect=@"SELECT ";
    NSString *strComma=@",";
    
    NSString *strFrom=@" FROM ";
    NSString *strwhere=@" WHERE ";
    NSMutableString *query=[[NSMutableString alloc]init];
    NSMutableString *strtemp=[[NSMutableString alloc]init];
    
    [query appendString:strSelect];
    for(int i=0;i<[arrColumnName count];i++)
    {
        [query appendString:[arrColumnName objectAtIndex:i]];
        [query appendString:strComma];
        
    }
    NSString *strQueryStar=[NSString stringWithFormat:@"%@",query];
    strQueryStar = [strQueryStar substringToIndex:[strQueryStar length] - 1];
    [strtemp appendString:strQueryStar];

    [strtemp appendString:strFrom];
    [strtemp appendString:strTableName];
    
    [strtemp appendString:strwhere];
    
    [strtemp appendString:strColumnCondition];
    
    [strtemp appendString:strComumnValue];
    
    NSLog(@"str tenp:%@",strtemp);
    
    
    
	const char *sql = [strtemp UTF8String];
	sqlite3_stmt *selectStatement;
	
	//prepare the select statement
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		sqlite3_bind_text(selectStatement, 1, sql, -1, SQLITE_TRANSIENT);
		//loop all the rows returned by the query.
		NSMutableArray *arrColumns = [[NSMutableArray alloc] initWithCapacity:0];
		for (int i=0; i<sqlite3_column_count(selectStatement); i++) 
		{
			const char *st = sqlite3_column_name(selectStatement, i);
			[arrColumns addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
		}
		int intRow =1;
		while(sqlite3_step(selectStatement) == SQLITE_ROW)
		{
			NSMutableDictionary *dctRow = [[NSMutableDictionary alloc] initWithCapacity:0];
			for (int i=0; i<sqlite3_column_count(selectStatement); i++) 				
			{
				int intValue = 0;
				double dblValue =0;
				const char *strValue;
				switch (sqlite3_column_type(selectStatement,i)) 
				{
					case SQLITE_INTEGER:
						intValue  = (int)sqlite3_column_int(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithInt:intValue] forKey:[arrColumns objectAtIndex:i]];
						break;
					case SQLITE_FLOAT:
						dblValue = (double)sqlite3_column_double(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithDouble:dblValue] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_TEXT:
						strValue = (const char *)sqlite3_column_text(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_BLOB:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_NULL:
						[dctRow setObject:@"" forKey:[arrColumns objectAtIndex:i]];						
						break;
					default:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
				}
				
			}
			[arryResult addObject:dctRow];
			[dctRow release];
			intRow ++;
		}
		
		[arrColumns release];
	}
	
	sqlite3_reset(selectStatement);
	return [arryResult autorelease];
}
- (NSMutableArray *)SelectWithStar:(NSString *)strTableName withCondition:(NSString *)strColumnCondition withColumnValue:(NSString *)strComumnValue
{
    NSMutableArray  *arryResult = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *strSelect=@"SELECT";
    NSString *strStar=@" * ";
    NSString *strFrom=@"FROM ";
    NSString *strWhere=@" WHERE ";
    NSMutableString *query=[[NSMutableString alloc]init];
   
    [query appendString:strSelect];
    [query appendString:strStar];
    [query appendString:strFrom];
    [query appendString:strTableName];
    [query appendString:strWhere];
    [query appendString:strColumnCondition];
    [query appendString:strComumnValue];
    
    NSLog(@"str tenp:%@",query);
    
    
    
	const char *sql = [query UTF8String];
	sqlite3_stmt *selectStatement;
	
	//prepare the select statement
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		sqlite3_bind_text(selectStatement, 1, sql, -1, SQLITE_TRANSIENT);
		//loop all the rows returned by the query.
		NSMutableArray *arrColumns = [[NSMutableArray alloc] initWithCapacity:0];
		for (int i=0; i<sqlite3_column_count(selectStatement); i++) 
		{
			const char *st = sqlite3_column_name(selectStatement, i);
			[arrColumns addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
		}
		int intRow =1;
		while(sqlite3_step(selectStatement) == SQLITE_ROW)
		{
			NSMutableDictionary *dctRow = [[NSMutableDictionary alloc] initWithCapacity:0];
			for (int i=0; i<sqlite3_column_count(selectStatement); i++) 				
			{
				int intValue = 0;
				double dblValue =0;
				const char *strValue;
				switch (sqlite3_column_type(selectStatement,i)) 
				{
					case SQLITE_INTEGER:
						intValue  = (int)sqlite3_column_int(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithInt:intValue] forKey:[arrColumns objectAtIndex:i]];
						break;
					case SQLITE_FLOAT:
						dblValue = (double)sqlite3_column_double(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithDouble:dblValue] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_TEXT:
						strValue = (const char *)sqlite3_column_text(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_BLOB:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
					case SQLITE_NULL:
						[dctRow setObject:@"" forKey:[arrColumns objectAtIndex:i]];						
						break;
					default:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
				}
				
			}
			[arryResult addObject:dctRow];
			[dctRow release];
			intRow ++;
		}
		
		[arrColumns release];
	}
	
	sqlite3_reset(selectStatement);
	return [arryResult autorelease];
}
- (void)dealloc {
	sqlite3_close(database);
	
	[super dealloc];
}

@end
