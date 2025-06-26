# Capacitor HealthKit Plugin

We are slowly working on the next version of this plugin. PRs to the main branch are no longer being accepted, please work with the v2 branch from now on. v2 is already being published as alpha on npm.

:heart: Capacitor plugin to retrieve data from HealthKit :heart:

Disclaimer : _for now only some of the HK data base, in the future the retrieve base will be bigger !_

## Getting Started

### Prerequisites

- Add **HealthKit to your Xcode project** (section signing & capabilities)

![alt text](https://i.ibb.co/Bg03ZKf/auth-hk.png)

- ADD **Privacy - Health Share Usage Description** to your Xcode project
- ADD **Privacy - Health Update Usage Description** to your Xcode project

You can simply put this into the `info.plist` file

```
	<key>NSHealthShareUsageDescription</key>
	<string>Read Health Data</string>
	<key>NSHealthUpdateUsageDescription</key>
	<string>Read Health Data</string>
```

### Installing

Do

```
npm i --save @everywhereIM-BV/capacitor-healthkit
```

Then

```
npx cap update
```

And **if you use Ionic or Angular, here a example setup:**

in your .ts file add this:

```ts
import {
  ActivityData,
  CapacitorHealthkit,
  OtherData,
  QueryOutput,
  SampleNames,
} from '@everywhereIM-BV/capacitor-healthkit';

const READ_PERMISSIONS = ['headphoneAudioExposure'];

```

and then you can create async functions like this:

```ts
  public async requestAuthorization(): Promise<void> {
    try {
      await CapacitorHealthkit.requestAuthorization({
        read: READ_PERMISSIONS,
      });

    } catch (error) {
      console.error('[HealthKitService] Error getting Authorization:', error);
    }
  }

  private async getActivityData(
    startDate: Date,
    endDate: Date = new Date(),
  ): Promise<StatisticsCollectionOutput> | undefined {
    try {
      const queryOptions = {
        quantityTypeSampleName: 'headphoneAudioExposure',
        anchorDate: endDate.toISOString(),
        startDate: startDate.toISOString(),
        endDate: endDate.toISOString(), // Optional
        interval: {
          unit: 'second',
          value: 1,
        }
      };

      return await CapacitorHealthkit.getStatisticsCollection(queryOptions);
    } catch (error) {
      console.error(error);

      return undefined;
    }
  }
```

## API

<docgen-index>

* [`requestAuthorization(...)`](#requestauthorization)
* [`isAvailable()`](#isavailable)
* [`getAuthorizationStatus(...)`](#getauthorizationstatus)
* [`getStatisticsCollection(...)`](#getstatisticscollection)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### requestAuthorization(...)

```typescript
requestAuthorization(options: RequestAuthorizationOptions) => Promise<void>
```

| Param         | Type                                                                                |
| ------------- | ----------------------------------------------------------------------------------- |
| **`options`** | <code><a href="#requestauthorizationoptions">RequestAuthorizationOptions</a></code> |

--------------------


### isAvailable()

```typescript
isAvailable() => Promise<void>
```

--------------------


### getAuthorizationStatus(...)

```typescript
getAuthorizationStatus(options: GetAuthorizationStatusOptions) => Promise<{ status: AuthorizationStatus; }>
```

| Param         | Type                                                                                    |
| ------------- | --------------------------------------------------------------------------------------- |
| **`options`** | <code><a href="#getauthorizationstatusoptions">GetAuthorizationStatusOptions</a></code> |

**Returns:** <code>Promise&lt;{ status: <a href="#authorizationstatus">AuthorizationStatus</a>; }&gt;</code>

--------------------


### getStatisticsCollection(...)

```typescript
getStatisticsCollection(options: StatisticsCollectionOptions) => Promise<StatisticsCollectionOutput>
```

| Param         | Type                                                                                |
| ------------- | ----------------------------------------------------------------------------------- |
| **`options`** | <code><a href="#statisticscollectionoptions">StatisticsCollectionOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#statisticscollectionoutput">StatisticsCollectionOutput</a>&gt;</code>

--------------------


### Interfaces


#### RequestAuthorizationOptions

| Prop        | Type                  |
| ----------- | --------------------- |
| **`all`**   | <code>string[]</code> |
| **`read`**  | <code>string[]</code> |
| **`write`** | <code>string[]</code> |


#### GetAuthorizationStatusOptions

| Prop             | Type                |
| ---------------- | ------------------- |
| **`sampleType`** | <code>string</code> |


#### StatisticsCollectionOutput

| Prop       | Type                                                                  |
| ---------- | --------------------------------------------------------------------- |
| **`data`** | <code>{ startDate: string; endDate: string; value: number; }[]</code> |


#### StatisticsCollectionOptions

| Prop                         | Type                                                                                            |
| ---------------------------- | ----------------------------------------------------------------------------------------------- |
| **`startDate`**              | <code>string</code>                                                                             |
| **`endDate`**                | <code>string</code>                                                                             |
| **`anchorDate`**             | <code>string</code>                                                                             |
| **`interval`**               | <code><a href="#statisticscollectionqueryinterval">StatisticsCollectionQueryInterval</a></code> |
| **`quantityTypeSampleName`** | <code><a href="#quantitytype">QuantityType</a></code>                                           |


#### StatisticsCollectionQueryInterval

| Prop        | Type                                                                      |
| ----------- | ------------------------------------------------------------------------- |
| **`unit`**  | <code>'second' \| 'minute' \| 'hour' \| 'day' \| 'month' \| 'year'</code> |
| **`value`** | <code>number</code>                                                       |


#### HealthKitDevice

| Prop                      | Type                |
| ------------------------- | ------------------- |
| **`name`**                | <code>string</code> |
| **`model`**               | <code>string</code> |
| **`manufacturer`**        | <code>string</code> |
| **`hardwareVersion`**     | <code>string</code> |
| **`softwareVersion`**     | <code>string</code> |
| **`firmwareVersion`**     | <code>string</code> |
| **`localIdentifier`**     | <code>string</code> |
| **`udiDeviceIdentifier`** | <code>string</code> |


### Type Aliases


#### AuthorizationStatus

<code>'notDetermined' | 'sharingDenied' | 'sharingAuthorized'</code>


#### QuantityType

<code>'headphoneAudioExposure'</code>

</docgen-api>
