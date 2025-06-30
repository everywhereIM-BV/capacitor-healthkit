export interface CapacitorHealthkitPlugin {
  requestAuthorization(options: RequestAuthorizationOptions): Promise<void>;
  isAvailable(): Promise<void>;
  getAuthorizationStatus(
    options: GetAuthorizationStatusOptions,
  ): Promise<{ status: AuthorizationStatus }>;
  getStatisticsCollection(
    options: StatisticsCollectionOptions,
  ): Promise<StatisticsCollectionOutput>;
}

export interface RequestAuthorizationOptions {
  all?: string[];
  read?: string[];
  write?: string[];
}

export interface GetAuthorizationStatusOptions {
  sampleType: string;
}

export type AuthorizationStatus =
  | 'notDetermined'
  | 'sharingDenied'
  | 'sharingAuthorized';

export interface StatisticsCollectionOptions {
  startDate: string;
  endDate?: string;
  anchorDate: string;
  interval: StatisticsCollectionQueryInterval;
  quantityTypeSampleName: QuantityType;
}

export interface StatisticsCollectionOutput {
  data: {
    startDate: string;
    endDate: string;
    value: number;
  }[];
}

export interface HealthKitDevice {
  name?: string;
  model?: string;
  manufacturer?: string;
  hardwareVersion?: string;
  softwareVersion?: string;
  firmwareVersion?: string;
  localIdentifier?: string;
  udiDeviceIdentifier?: string;
}

export interface StatisticsCollectionQueryInterval {
  unit: 'second' | 'minute' | 'hour' | 'day' | 'month' | 'year';
  value: number;
}

export type QuantityType = 'headphoneAudioExposure';
