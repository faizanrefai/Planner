#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DAL : NSObject {
	sqlite3 *database;
	
	BOOL dbAccessError;
}

+ (BOOL)isInOperation;
+ (void)setInOperation:(BOOL)operationFlag;

- (id)initDatabase:(NSString *)dbName;



//delete quere

- (int)deleteFromTable:(NSString*)strTable WhereField:(NSString*)strField Condition:(NSString*)strCondition;

// select query
- (NSMutableArray *)SelectWithStar:(NSString *)strTableName;
- (NSMutableArray *)SelectQuery:(NSString *)strTableName withColumn:(NSArray *)arrColumnName withCondition:(NSString *)strColumnCondition withColumnValue:(NSString *)strComumnValue;
- (NSMutableArray *)SelectWithStar:(NSString *)strTableName withCondition:(NSString *)strColumnCondition withColumnValue:(NSString *)strComumnValue;
- (NSMutableDictionary *)executeDataSet:(NSString *)strQuery;
- (NSMutableArray *)executeArraySet:(NSString *)strTableName withColumn:(NSArray *)arrcolumn;


- (BOOL)isRecordAvailable:(NSDictionary *)record forID:(NSString *)idKey inTable:(NSString *)table;

// update record

- (void)updateRecord:(NSDictionary *)record forID:(NSString *)idKey inTable:(NSString *)table  withValue:(NSString *)strValue;

// insert record
- (void)insertRecord:(NSDictionary *)record inTable:(NSString *)table;

// update or insert recordfd
//- (void)addUpdateRecord:(NSDictionary *)record forID:(NSString *)idKey inTable:(NSString *)table;

@end
