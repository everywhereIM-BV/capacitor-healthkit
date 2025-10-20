import Capacitor
import Foundation
import HealthKit

var healthStore = HKHealthStore()

@objc(CapacitorHealthkitPlugin)
public class CapacitorHealthkitPlugin: CAPPlugin {
  @objc func requestAuthorization(_ call: CAPPluginCall) {
    if !HKHealthStore.isHealthDataAvailable() {
      return call.reject("Health data is not available.")
    }

    let _all = call.options["all"] as? [String] ?? []
    let _read = call.options["read"] as? [String] ?? []
    let _write = call.options["write"] as? [String] ?? []

    let writeTypes: Set<HKSampleType> = getSampleTypes(sampleNames: _write).union(
      getSampleTypes(sampleNames: _all))
    let readTypes: Set<HKSampleType> = getSampleTypes(sampleNames: _read).union(
      getSampleTypes(sampleNames: _all))

    healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, _ in
      if !success {
        call.reject("Could not get permission to access health.")

        return
      }

      call.resolve()
    }
  }

  @objc func isAvailable(_ call: CAPPluginCall) {
    if HKHealthStore.isHealthDataAvailable() {
      return call.resolve()
    } else {
      return call.reject("Health data is not available.")
    }
  }

  @objc func getAuthorizationStatus(_ call: CAPPluginCall) {
    guard let sampleName = call.options["sampleName"] as? String else {
      return call.reject("sampleName is required.")
    }

    let sampleType: HKSampleType? = getSampleType(sampleName: sampleName)

    if sampleType == nil {
      return call.reject("Unknown sampleName " + sampleName)
    }

    let status: String

    switch healthStore.authorizationStatus(for: sampleType!) {
    case .sharingAuthorized:
      status = "sharingAuthorized"
    case .sharingDenied:
      status = "sharingDenied"
    case .notDetermined:
      status = "notDetermined"
    @unknown default:
      return call.reject("Unknown status")
    }

    call.resolve([
      "status": status
    ])
  }

  @objc func getStatisticsCollection(_ call: CAPPluginCall) {
    guard let sampleName = call.options["quantityTypeSampleName"] as? String else {
      return call.reject("quantityTypeSampleName is required.")
    }

    guard let anchorDateInput = call.options["anchorDate"] as? String else {
      return call.reject("anchorDate is required.")
    }

    guard let startDateInput = call.options["startDate"] as? String else {
      return call.reject("startDate is required.")
    }

    let endDateInput = call.options["endDate"] as? String

    let interval: Interval
    if let intervalInput = call.options["interval"] as? [String: Any],
      let unit = intervalInput["unit"] as? String,
      let value = intervalInput["value"] as? Int
    {
      interval = Interval(unit: unit, value: value)
    } else {
      print("Failed to extract interval information")

      return call.reject("interval is not valid")
    }

    let intervalComponents = getInterval(interval.unit, interval.value)

    let anchorDate = getDateFromString(inputDate: anchorDateInput)

    let quantityType = getQuantityType(sampleName: sampleName)

    // Create the query.
    let query = HKStatisticsCollectionQuery(
      quantityType: quantityType,
      quantitySamplePredicate: nil,
      options: .discreteAverage,
      anchorDate: anchorDate,
      intervalComponents: intervalComponents)

    // Set the results handler.
    query.initialResultsHandler = {
      query, results, error in

      // Handle errors here.
      if let error = error as? HKError {
        switch error.code {
        case .errorDatabaseInaccessible:
          // HealthKit couldn't access the database because the device is locked.
          return call.reject("Device is locked.")
        default:
          // Handle other HealthKit errors here.
          return call.reject("A HealthKit error occurred")
        }
      }

      guard let statsCollection = results else {
        // You should only hit this case if you have an unhandled error. Check for bugs
        // in your code that creates the query, or explicitly handle the error.
        return call.reject("An unexpected error occurred")
      }

      let endDate = endDateInput != nil ? getDateFromString(inputDate: endDateInput!) : Date()
      let startDate = getDateFromString(inputDate: startDateInput)

      var output: [[String: Any]] = []

      // Enumerate over all the statistics objects between the start and end dates.
      statsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
        if let quantity = statistics.averageQuantity() {
          let startDate = statistics.startDate
          let endDate = statistics.endDate
          let value =
            quantity != nil
            ? quantity.doubleValue(for: HKUnit.decibelAWeightedSoundPressureLevel())
            : nil

          output.append([
            "startDate": startDate,
            "endDate": endDate,
            "value": value,
          ])
        }
      }

      call.resolve(["data": output])
    }

    healthStore.execute(query)
  }
}
