import Foundation
import HealthKit

func getSampleType(sampleName: String) -> HKSampleType? {
  switch sampleName {
  case "headphoneAudioExposure":
    return HKQuantityType.quantityType(
      forIdentifier: HKQuantityTypeIdentifier.headphoneAudioExposure)!
  default:
    return nil
  }
}

func getSampleTypes(sampleNames: [String]) -> Set<HKSampleType> {
  var types: Set<HKSampleType> = []

  for item in sampleNames {
    if let type = getSampleType(sampleName: item) {
      types.insert(type)
    }
  }

  return types
}

func getQuantityType(sampleName: String) -> HKQuantityType {
  switch sampleName {
  case "headphoneAudioExposure":
    return HKQuantityType.quantityType(
      forIdentifier: HKQuantityTypeIdentifier.headphoneAudioExposure)!
  default:
    fatalError(sampleName + " is not supported.")
  }
}
