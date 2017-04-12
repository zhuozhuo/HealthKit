## Demo 展示效果


![recordTime2.gif](http://upload-images.jianshu.io/upload_images/2926059-b00a048443397e0c.gif?imageMogr2/auto-orient/strip)


##前言
>随着人们对健康的重视,移动端两大巨头Apple和Google都推出了各自的健康库 Apple Health , Google Fit ,它们集成大部分健康中所用到的数据类型,各个应用根据自己所擅长的领域写入相关健康数据,或共享HealthKit中其他健康数据,以达各尽所长，数据共享！



##简述
>HealthKit框架提供了一个结构，应用可以使用它来分享健康和健身数据。HealthKit管理从不同来源获得的数据，并根据用户的偏好设置，自动将不同来源的所有数据合并起来。应用还可以获取每个来源的原始数据，然后执行自己的数据合并。

>HealthKit另外提供了一个应用来帮助管理用户的健康数据。健康应用为用户展示HealthKit的数据。用户可以使用健康应用来查看、添加、删除或者管理其全部的健康和健身数据。用户还可以编辑每种数据类型的分享权限。

>HealthKit和健康应用在iPad上都不可用。

##隐私
>由于健康数据可能是敏感的，HealthKit通过精确控制哪些信息允许应用读取，从而让用户可以控制这些数据。用户必须明确设置每个应用在HealthKit存储中读写的权限。用户可以单独为每种数据类型设置准许或拒绝的权限。例如，用户可以允许你的应用读取计步数据，但是不允许读取用户心率数据。为了防止可能的信息泄露，应用在不调用相关访问接口时,是不知道它是否被禁止读取数据的。

>HealthKit的数据不会保存在iCloud中，也不会在多设备间同步。这些数据只会保存在用户的本地设备中。为了安全考虑，当设备没有解锁时，HealthKit存储的数据是加密的。

>另外，你的应用如果主要不是提供健康或健身服务的话，那就不能调用HealthKit的API。如果你的应用提供健康和健身服务，就必须要在App Store相关应用简介和应用界面上明确的表明。

##使用HealthKit特别注意

1. 你的应用不应该将HealthKit收集的数据用于广告或类似的服务。注意，在使用HealthKit框架应用中可以插播广告，但是你不能使用HealthKit中的数据来服务广告。
2. 在没有用户的明确允许下，你不能向第三方展示任何HealthKit收集的数据。即使用户允许，你也只能向提供健康或健身服务的第三方展示这些数据。
3. 你不能将HealthKit收集的数据出售给广告平台、数据代理人或者信息经销商。
4. 如果用户允许，你可以将HealthKit数据共享给第三方用于医学研究。**注意是用户允许**
5. 你必须明确说明，你和你的应用会怎样使用用户的HealthKit数据。





## 应用中使用了HealthKit 上 App Store 特别注意

1. 一定要添加隐私政策网址链接,并注明健康数据使用的隐私相关条例。例如：

   * 在App里您设置身高、体重时，根据您之前是否允许授权权限，XXX将依据您给的权限是否把信息写入苹果健康应用。
   * 在App里同步计步、睡眠、心率数据时，根据您之前是否允许授权权限，XXX将依据您给的权限是否把信息写入苹果健康应用。

2. 应用介绍中一定要注明：**此版本支持你使用Apple健康应用程序**

   * 审核详情请参考 [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/2016-06-13/#healthkit)中的HealthKit章节。

## HealthKit设计目标

>HealthKit是用来在应用间以一种有意义的方式共享数据。为了达到这点，框架限制只能使用预先定义好的数据类型和单位。这些限制保证了其他应用能理解这些数据是什么意思,以及怎样使用。因此，开发者不能创建自定义数据类型和单位。而HealthKit尽量会提供一个完整的数据类型和单位。

## HealthKit 存储理念
>框架大量使用了子类化，在相似的类间创建层级关系。通常这些类间都有一些细微但是重要的差别。还有不少和它相关的类，需要正确搭配,才能一起工作。存储在HealthKit中的数据都是由**对象**和对象所属**类型**组成,这个概念一定要刻入脑海,你才能理解整个存储结构。所有对象都是基于[HKObject](https://developer.apple.com/reference/healthkit/hkobject#//apple_ref/occ/cl/HKObject)，所有对象所属的类型都是基于[HKObjectType](https://developer.apple.com/reference/healthkit/hkobjecttype#//apple_ref/occ/cl/HKObjectType)。下面简单介绍下这两个类:

*  [HKObject](https://developer.apple.com/reference/healthkit/hkobject#//apple_ref/occ/cl/HKObject)我们不能直接使用,而是使用它的子类。子类有:
   * [HKCategorySample](https://developer.apple.com/reference/healthkit/hkcategorysample)
   * [HKQuantitySample](https://developer.apple.com/reference/healthkit/hkquantitysample)
   * [HKCorrelation](https://developer.apple.com/reference/healthkit/hkcorrelation)
   * [HKWorkout](https://developer.apple.com/reference/healthkit/hkworkout)

* [HKObject](https://developer.apple.com/reference/healthkit/hkobject#//apple_ref/occ/cl/HKObject) 主要分为两类：特征和样本。特征对象代表一些基本不变的数据。例如：用户的生日、血型和生理性别,肤色。你的应用不能写入特征数据。用户必须通过健康应用来输入或者修改这些数据。
   * 样本对象是某个特定时间断的数据。所有的样本对象都是[HKSample](https://developer.apple.com/library/prerelease/ios/documentation/HealthKit/Reference/HKSample_Class/index.html#//apple_ref/occ/cl/HKSample)的子类。它们都有下列属性：
     * `sampleType`: 样本类型。例如：一个睡眠分析样本、一个身高样本或者一个计步样本。
     * `startDate` : 样本的开始时间。
     * `endDate` : 样本的结束时间。

* [HKObject](https://developer.apple.com/reference/healthkit/hkobject#//apple_ref/occ/cl/HKObject) 所有对象都是不可变的(除非修改了对象来源),创建对象时需设置对象的相关属性。所有对象都有相同的属性。如下所示：
   * 唯一的标识符`UUID`
   * 数据来源`source` 9.0版本后用`sourceRevision`
   * `device`生成这个对象数据的设备。
   * `Metadata`用来描述对象的额外信息,是`NSDictionary`类型,其中`Key`都为`NSString`类型,`Value`可以为`NSString`,`NSNumber`,`NSDate`类型。其中`Key`可以为系统预定义的也可以自定义。系统预定义的`Key`:
   > ```objective-c
   >  NSString * const HKMetadataKeyDeviceSerialNumber;
   > NSString * const HKMetadataKeyBodyTemperatureSensorLocation;
   > NSString * const HKMetadataKeyHeartRateSensorLocation;
   > NSString * const HKMetadataKeyFoodType;
   > NSString * const HKMetadataKeyUDIDeviceIdentifier;
   > NSString * const HKMetadataKeyUDIProductionIdentifier;
   > NSString * const HKMetadataKeyDigitalSignature;
   > NSString * const HKMetadataKeyExternalUUID;
   > NSString * const HKMetadataKeyTimeZone;
   > NSString * const HKMetadataKeyDeviceName;
   > NSString * const HKMetadataKeyDeviceManufacturerName;
   > NSString * const HKMetadataKeyWasTakenInLab;
   > NSString * const HKMetadataKeyReferenceRangeLowerLimit;
   > NSString * const HKMetadataKeyReferenceRangeUpperLimit;
   > NSString * const HKMetadataKeyWasUserEntered;
   > NSString * const HKMetadataKeyWorkoutBrandName;
   > NSString * const HKMetadataKeyGroupFitness;
   > NSString * const HKMetadataKeyIndoorWorkout;
   > NSString * const HKMetadataKeyCoachedWorkout;
   > NSString * const HKMetadataKeySexualActivityProtectionUsed;
   > NSString * const HKMetadataKeyMenstrualCycleStart;
   > ```
       ​```

* [HKObjectType](https://developer.apple.com/reference/healthkit/hkobjecttype#//apple_ref/occ/cl/HKObjectType)是用来描述[HKObject](https://developer.apple.com/reference/healthkit/hkobject#//apple_ref/occ/cl/HKObject)的类型。我们也不能直接使用，只能使用其子类来对数据类型进行区分。其子类有:
   * [HKQuantityType ](https://developer.apple.com/reference/healthkit/hkquantitytype)
   * [HKCategoryType](https://developer.apple.com/reference/healthkit/hkcategorytype)
   * [HKCharacteristicType](https://developer.apple.com/reference/healthkit/hkcharacteristictype)
   * [HKActivitySummaryType](https://developer.apple.com/reference/healthkit/hkactivitysummarytype)
   * [HKCorrelationType](https://developer.apple.com/reference/healthkit/hkcorrelationtype)
   * [HKDocumentType](https://developer.apple.com/reference/healthkit/hkdocumenttype)
   * [HKWorkoutType](https://developer.apple.com/reference/healthkit/hkworkouttype)
* 初始化类型子类的方法有:


```objective-c
+ (nullable HKQuantityType *)quantityTypeForIdentifier:(NSString *)identifier;
+ (nullable HKCategoryType *)categoryTypeForIdentifier:(NSString *)identifier;
+ (nullable HKCharacteristicType *)characteristicTypeForIdentifier:(NSString *)identifier;
+ (nullable HKCorrelationType *)correlationTypeForIdentifier:(NSString *)identifier;
```

* 系统预定义类型的`Identifiers`有：


```objective-c
/*--------------------------------*/
/*   HKQuantityType Identifiers   */
/*--------------------------------*/

// Body Measurements
HK_EXTERN NSString * const HKQuantityTypeIdentifierBodyMassIndex NS_AVAILABLE_IOS(8_0);             // Scalar(Count),               Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierBodyFatPercentage NS_AVAILABLE_IOS(8_0);         // Scalar(Percent, 0.0 - 1.0),  Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierHeight NS_AVAILABLE_IOS(8_0);                    // Length,                      Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierBodyMass NS_AVAILABLE_IOS(8_0);                  // Mass,                        Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierLeanBodyMass NS_AVAILABLE_IOS(8_0);              // Mass,                        Discrete

// Fitness
HK_EXTERN NSString * const HKQuantityTypeIdentifierStepCount NS_AVAILABLE_IOS(8_0);                 // Scalar(Count),               Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDistanceWalkingRunning NS_AVAILABLE_IOS(8_0);    // Length,                      Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDistanceCycling NS_AVAILABLE_IOS(8_0);           // Length,                      Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierBasalEnergyBurned NS_AVAILABLE_IOS(8_0);         // Energy,                      Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierActiveEnergyBurned NS_AVAILABLE_IOS(8_0);        // Energy,                      Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierFlightsClimbed NS_AVAILABLE_IOS(8_0);            // Scalar(Count),               Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierNikeFuel NS_AVAILABLE_IOS(8_0);                  // Scalar(Count),               Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierAppleExerciseTime HK_AVAILABLE_IOS_WATCHOS(9_3, 2_2);    // Time                         Cumulative

// Vitals
HK_EXTERN NSString * const HKQuantityTypeIdentifierHeartRate NS_AVAILABLE_IOS(8_0);                 // Scalar(Count)/Time,          Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierBodyTemperature NS_AVAILABLE_IOS(8_0);           // Temperature,                 Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierBasalBodyTemperature NS_AVAILABLE_IOS(9_0);      // Basal Body Temperature,      Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierBloodPressureSystolic NS_AVAILABLE_IOS(8_0);     // Pressure,                    Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierBloodPressureDiastolic NS_AVAILABLE_IOS(8_0);    // Pressure,                    Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierRespiratoryRate NS_AVAILABLE_IOS(8_0);           // Scalar(Count)/Time,          Discrete

// Results
HK_EXTERN NSString * const HKQuantityTypeIdentifierOxygenSaturation NS_AVAILABLE_IOS(8_0);          // Scalar (Percent, 0.0 - 1.0,  Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierPeripheralPerfusionIndex NS_AVAILABLE_IOS(8_0);  // Scalar(Percent, 0.0 - 1.0),  Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierBloodGlucose NS_AVAILABLE_IOS(8_0);              // Mass/Volume,                 Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierNumberOfTimesFallen NS_AVAILABLE_IOS(8_0);       // Scalar(Count),               Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierElectrodermalActivity NS_AVAILABLE_IOS(8_0);     // Conductance,                 Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierInhalerUsage NS_AVAILABLE_IOS(8_0);              // Scalar(Count),               Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierBloodAlcoholContent NS_AVAILABLE_IOS(8_0);       // Scalar(Percent, 0.0 - 1.0),  Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierForcedVitalCapacity NS_AVAILABLE_IOS(8_0);       // Volume,                      Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierForcedExpiratoryVolume1 NS_AVAILABLE_IOS(8_0);   // Volume,                      Discrete
HK_EXTERN NSString * const HKQuantityTypeIdentifierPeakExpiratoryFlowRate NS_AVAILABLE_IOS(8_0);    // Volume/Time,                 Discrete

// Nutrition
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryFatTotal NS_AVAILABLE_IOS(8_0);           // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryFatPolyunsaturated NS_AVAILABLE_IOS(8_0); // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryFatMonounsaturated NS_AVAILABLE_IOS(8_0); // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryFatSaturated NS_AVAILABLE_IOS(8_0);       // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryCholesterol NS_AVAILABLE_IOS(8_0);        // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietarySodium NS_AVAILABLE_IOS(8_0);             // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryCarbohydrates NS_AVAILABLE_IOS(8_0);      // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryFiber NS_AVAILABLE_IOS(8_0);              // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietarySugar NS_AVAILABLE_IOS(8_0);              // Mass,   Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryEnergyConsumed NS_AVAILABLE_IOS(8_0);     // Energy, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryProtein NS_AVAILABLE_IOS(8_0);            // Mass,   Cumulative

HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryVitaminA NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryVitaminB6 NS_AVAILABLE_IOS(8_0);          // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryVitaminB12 NS_AVAILABLE_IOS(8_0);         // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryVitaminC NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryVitaminD NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryVitaminE NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryVitaminK NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryCalcium NS_AVAILABLE_IOS(8_0);            // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryIron NS_AVAILABLE_IOS(8_0);               // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryThiamin NS_AVAILABLE_IOS(8_0);            // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryRiboflavin NS_AVAILABLE_IOS(8_0);         // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryNiacin NS_AVAILABLE_IOS(8_0);             // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryFolate NS_AVAILABLE_IOS(8_0);             // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryBiotin NS_AVAILABLE_IOS(8_0);             // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryPantothenicAcid NS_AVAILABLE_IOS(8_0);    // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryPhosphorus NS_AVAILABLE_IOS(8_0);         // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryIodine NS_AVAILABLE_IOS(8_0);             // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryMagnesium NS_AVAILABLE_IOS(8_0);          // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryZinc NS_AVAILABLE_IOS(8_0);               // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietarySelenium NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryCopper NS_AVAILABLE_IOS(8_0);             // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryManganese NS_AVAILABLE_IOS(8_0);          // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryChromium NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryMolybdenum NS_AVAILABLE_IOS(8_0);         // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryChloride NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryPotassium NS_AVAILABLE_IOS(8_0);          // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryCaffeine NS_AVAILABLE_IOS(8_0);           // Mass, Cumulative
HK_EXTERN NSString * const HKQuantityTypeIdentifierDietaryWater NS_AVAILABLE_IOS(9_0);              // Volume, Cumulative

HK_EXTERN NSString * const HKQuantityTypeIdentifierUVExposure NS_AVAILABLE_IOS(9_0);                // Scalar (Count), Discrete

/*--------------------------------*/
/*   HKCategoryType Identifiers   */
/*--------------------------------*/

HK_EXTERN NSString * const HKCategoryTypeIdentifierSleepAnalysis NS_AVAILABLE_IOS(8_0);             // HKCategoryValueSleepAnalysis
HK_EXTERN NSString * const HKCategoryTypeIdentifierAppleStandHour NS_AVAILABLE_IOS(9_0);            // HKCategoryValueAppleStandHour
HK_EXTERN NSString * const HKCategoryTypeIdentifierCervicalMucusQuality NS_AVAILABLE_IOS(9_0);      // HKCategoryValueCervicalMucusQuality
HK_EXTERN NSString * const HKCategoryTypeIdentifierOvulationTestResult NS_AVAILABLE_IOS(9_0);       // HKCategoryValueOvulationTestResult
HK_EXTERN NSString * const HKCategoryTypeIdentifierMenstrualFlow NS_AVAILABLE_IOS(9_0);             // HKCategoryValueMenstrualFlow
HK_EXTERN NSString * const HKCategoryTypeIdentifierIntermenstrualBleeding NS_AVAILABLE_IOS(9_0);    // (Spotting) HKCategoryValue
HK_EXTERN NSString * const HKCategoryTypeIdentifierSexualActivity NS_AVAILABLE_IOS(9_0);            // HKCategoryValue


/*--------------------------------------*/
/*   HKCharacteristicType Identifiers   */
/*--------------------------------------*/

HK_EXTERN NSString * const HKCharacteristicTypeIdentifierBiologicalSex NS_AVAILABLE_IOS(8_0); // NSNumber (HKCharacteristicBiologicalSex)
HK_EXTERN NSString * const HKCharacteristicTypeIdentifierBloodType NS_AVAILABLE_IOS(8_0);     // NSNumber (HKCharacteristicBloodType)
HK_EXTERN NSString * const HKCharacteristicTypeIdentifierDateOfBirth NS_AVAILABLE_IOS(8_0);   // NSDate
HK_EXTERN NSString * const HKCharacteristicTypeIdentifierFitzpatrickSkinType NS_AVAILABLE_IOS(9_0); // HKFitzpatrickSkinType

/*-----------------------------------*/
/*   HKCorrelationType Identifiers   */
/*-----------------------------------*/

HK_EXTERN NSString * const HKCorrelationTypeIdentifierBloodPressure NS_AVAILABLE_IOS(8_0);
HK_EXTERN NSString * const HKCorrelationTypeIdentifierFood NS_AVAILABLE_IOS(8_0);

/*------------------------------*/
/*   HKWorkoutType Identifier   */
/*------------------------------*/

HK_EXTERN NSString * const HKWorkoutTypeIdentifier NS_AVAILABLE_IOS(8_0);

NS_ASSUME_NONNULL_END

```

* 其中我们常用的有 [HKQuantityType ](https://developer.apple.com/reference/healthkit/hkquantitytype), [HKCategoryType](https://developer.apple.com/reference/healthkit/hkcategorytype)也是我应用中用过的类型。

## 如何使用
* 创建一个工程取名为: HealthKit
* 在`TAGETS`->`Capabilities` 打开->`HealthKit`如下图所示：


![屏幕快照 2016-09-20 22.12.44.png](http://upload-images.jianshu.io/upload_images/2926059-91d0374c8fa99f02.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这时工程将会自动将`HealthKit.framework`加入工程。

* 创建一个管理我们HealthKit相关操作的类:`ZHHealthManager`里面包含请求访问HealthKit库以及相关读写操作。

     *  `ZHHealthManager.h`文件相关方法


```objective-c

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

typedef void (^ZHHealthKitFinishBlock) (BOOL success,NSError *error);
typedef void (^ZHHealthKitIntegerValueBlock)(NSInteger value, NSError *error);

@interface ZHHealthManager : NSObject
@property (nonatomic) HKHealthStore * healthStore;

+(ZHHealthManager *)shareZHHealthManager;


/**
 *  request Authorization To Share Data in HealthKit
 *
 *  @param finish block
 */
-(void)requestAuthorizationToShareWithCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  Read User Age
 *
 *  @param finish finish block.
 */
-(void)readUsersAgeWithFinish:(ZHHealthKitIntegerValueBlock)finish;


/**
 *  write height data into HealthKit
 *
 *  @param height height `cm`
 *  @param unit   unit Option
 *  @param finish block
 */
-(void)saveHeightIntoHealthStore:(double)height withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  write weight data into HealthKit
 *
 *  @param weight weight `kg`
 *  @param unit   unit option
 *  @param finish finishBlock
 */
-(void)saveWeightIntoHealthStore:(double)weight withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save stepcount into HealthKit
 *
 *  @param steps     steps
 *  @param startDate startDate
 *  @param endDate   endDate
 *  @param finish    Block
 */
-(void)saveStepCount:(NSInteger)steps startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save walk distance into healthKit
 *
 *  @param walkDistance walk distance
 *  @param startDate    startDate
 *  @param endDate      endDate
 *  @param finish       block
 */
-(void)saveWalkDistance:(double)walkDistance startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save active Energy burn calories into healthKit
 *
 *  @param calories  calories
 *  @param startDate startDate
 *  @param endDate   endDate
 *  @param finish    block
 */
-(void)saveActiveEnergyBurnCalories:(double)calories startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save heartRate into HealthKit
 *
 *  @param heartRate heartRate
 *  @param finish    block
 */
-(void)saveHeartRate:(NSInteger)heartRate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save sleep data into HealthKit
 *
 *  @param startDate start time
 *  @param endDate   end time
 *  @param finish    finish block
 */
-(void)saveSleepWithstartTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;
@end

```

## 方法调用
* 首先我们需要把自己想要读或写的相关数据类型写明。


```objective-c
#pragma mark - Health Kit TypesToWrite
-(NSSet *)dataTypesToWrite
{
    HKQuantityType *stepCountQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *walkDistanceQuantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *activeEnergyBurnQuantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heartQuantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKCategoryType *sleepCategoryType = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    
    return [NSSet setWithObjects:stepCountQuantityType, walkDistanceQuantityType, activeEnergyBurnQuantityType,sleepCategoryType,heartQuantityType,heightType,weightType, nil];
}

#pragma mark - Health Kit TypesToRead
- (NSSet *)dataTypesToRead {
    HKCharacteristicType *ageTypte = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    return [NSSet setWithObjects:ageTypte, nil];
    return nil;
}
```

*  然后申请访问相关读写操作。


```objective-c
-(void)requestAuthorizationToShareWithCompletion:(ZHHealthKitFinishBlock)finish
{
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error){
            if (finish) {
                finish(success,error);
            }
        }];
    }else{
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"健康应用不可用!", @"健康应用不可用!"),NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Health Kit not available.", @"Health Kit not available."),NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", @"Have you tried turning it off and on again?")};
        NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:-10 userInfo:userInfo];
        if (finish) {
            finish(NO,error);
        }
        
        NSLog(@"Health Kit not available");
    }
}

```

* 获取权限后进行读或写相关操作，重要记住三点。
 1.  判断系统版本,低于8.0不可用。
 2.  判断设备是否支持HealthKit。`[HKHealthStore isHealthDataAvailable]`。
 3.  判断用户是否对这个类型的进行授权。`authorizationStatusForType` (基本不可变数据类型除外,例如:生日,性别,血型等)不对授权进行判断，一般不会出问题在进行读写操作时也会有错误提示。但是对数据操作时系统判断更耗时而且有时会出现莫名的错误。

* 这里举两个例子说明下：
     *  对年龄进行读操作。
     *  对身高进行写操作。

>年龄读操作

```objective-c
-(void)readUsersAgeWithFinish:(ZHHealthKitIntegerValueBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        return;
    }
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    NSInteger age = -1;//年龄没有获取到返回－1
    if (dateOfBirth) {//读取到生日转换成年龄
        NSDate *now = [NSDate date];
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
        NSUInteger usersAge = [ageComponents year];
        age = usersAge;
    }
    if (finish) {
        finish(age,error);
    }
}
```

> 身高写操作

```objective-c

-(void)saveHeightIntoHealthStore:(double)height withCompletion:(ZHHealthKitFinishBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        return;
    }
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    if ([self.healthStore authorizationStatusForType:weightType] != HKAuthorizationStatusSharingAuthorized) {
        NSLog(@"未经用户允许访问直接返回");
        return;
        
    }

    HKUnit *hkUnit = [HKUnit inchUnit];
    height = height/100;
    hkUnit = [HKUnit meterUnit];
    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:hkUnit doubleValue:height];
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    if ([self.healthStore authorizationStatusForType:heightType]) {
        
    }
    NSDate *now = [NSDate date];
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:now endDate:now];
    [self.healthStore saveObject:heightSample withCompletion:^(BOOL success, NSError *error){
            if (finish) {
                finish(success, error);
            }
        }];

}
```
* 当然在进行其他样本操作时,例如:记步,睡眠等等。如果有可能出现重复写入，我们需要先进行判断这段时间内的数据是否已经存入HealthKit。这里会用到查询操作，具体可以参考我Demo中的`HKHealthStore+ZHHKExtensions`类。

###Demo 下载地址
[GitHub](https://github.com/zhuozhuo/HealthKit/tree/master)
