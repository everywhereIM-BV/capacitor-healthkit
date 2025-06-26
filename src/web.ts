import { WebPlugin } from '@capacitor/core';

import type {
  AuthorizationStatus,
  CapacitorHealthkitPlugin,
  GetAuthorizationStatusOptions,
  StatisticsCollectionOptions,
  StatisticsCollectionOutput,
} from './definitions';

export class CapacitorHealthkitWeb
  extends WebPlugin
  implements CapacitorHealthkitPlugin {
  async echo(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async requestAuthorization(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async isAvailable(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async getAuthorizationStatus(
    options: GetAuthorizationStatusOptions,
  ): Promise<{ status: AuthorizationStatus }> {
    console.log({ options });
    throw new Error('Method not implemented.');
  }

  async getStatisticsCollection(
    options: StatisticsCollectionOptions,
  ): Promise<StatisticsCollectionOutput> {
    console.log({ options });
    throw new Error('Method not implemented.');
  }
}
