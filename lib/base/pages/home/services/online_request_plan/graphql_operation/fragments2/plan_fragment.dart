import 'package:graphql/client.dart';

final planFragment = gql('''
fragment planFragment on Plan {
  date
  from{
    name,
    lat,
    lon,
  }
  to{
    name,
    lon,
    lat,
  }
  itineraries {
    startTime
    endTime
    duration
    walkDistance
    emissionsPerPerson {
      co2
    }
    walkTime
    arrivedAtDestinationWithRentedBicycle
    fares {
      cents
      type
      components {
        cents
        fareId
        routes {
          gtfsId
          id
          agency {
            gtfsId
            fareUrl
            name
            id
          }
        }
      }
    }
    legs {
      mode
      realTime
      realtimeState
      transitLeg
      rentedBike
      startTime
      endTime
      interlineWithPreviousLeg
      distance
      duration
      intermediatePlace
      dropOffBookingInfo {
        message
        dropOffMessage
        contactInfo {
          phoneNumber
          infoUrl
          bookingUrl
        }
      }
      agency {
        name
        url
        fareUrl
        id
      }
      steps {
        distance
        lon
        lat
        elevationProfile{
          distance
          elevation
        }
        relativeDirection
        absoluteDirection
        streetName
        exit
        stayOn
        area
        bogusName
        walkingBike
      }
      from {
        lat
        lon
        name
        vertexType
        bikeRentalStation {
          id
          networks
          bikesAvailable
          lat
          lon
          stationId
        }
        stop {
          id
          gtfsId
          code
          platformCode
          vehicleMode
          zoneId
          name
          alerts {
            id
            alertSeverityLevel
            effectiveEndDate
            effectiveStartDate
            entities {
              __typename
            }
            alertHeaderText
            alertDescriptionText
            alertUrl
            trip {
              id
              pattern {
                code
                id
              }
            }
            alertHeaderTextTranslations {
              text
              language
            }
            alertUrlTranslations {
              text
              language
            }
          }
        }
      }
      to {
        lat
        lon
        name
        vertexType
        # TODO still to be implemented in upstream OTP
        # vehicleParkingWithEntrance {
        #   vehicleParking {
        #     tags
        #   }
        # }
        bikeRentalStation {
          lat
          lon
          stationId
          networks
          bikesAvailable
          id
        }
        stop {
          gtfsId
          name
          code
          platformCode
          vehicleMode
          zoneId
          id
          alerts {
            alertSeverityLevel
            effectiveEndDate
            effectiveStartDate
            entities {
              __typename
            }
            alertHeaderText
            alertDescriptionText
            alertUrl
            id
            trip {
              id
              pattern {
                code
                id
              }
            }
            alertHeaderTextTranslations {
              text
              language
            }
            alertUrlTranslations {
              text
              language
            }
          }
        }
        bikePark {
          bikeParkId
          name
          id
        }
        carPark {
          carParkId
          name
          id
        }
      }
      legGeometry {
        length
        points
      }
      intermediatePlaces {
        arrivalTime
        stop {
          gtfsId
          lat
          lon
          name
          code
          platformCode
          zoneId
          id
        }
      }
      route {
        id
        gtfsId
        mode
        shortName
        longName
        color
        type
        desc
        url
        agency {
          id
          gtfsId
          fareUrl
          name
          phone
        }
        alerts {
          id
          alertSeverityLevel
          effectiveEndDate
          effectiveStartDate
          entities {
            __typename
          }
          alertHeaderText
          alertDescriptionText
          alertUrl
          trip {
            id
            pattern {
              id
              code
            }
          }
          alertHeaderTextTranslations {
            text
            language
          }
          alertUrlTranslations {
            text
            language
          }
        }
      }
      trip {
        id
        gtfsId
        tripHeadsign
        directionId
        pattern {
          id
          code
          geometry {
            lat
            lon
          }
          route {
            mode
            color
            id
            url
          }
          stops {
            id
            gtfsId
            lat
            lon
            name
            platformCode
            code
            desc
            zoneId
            
            alerts {
              alertSeverityLevel
              effectiveEndDate
              effectiveStartDate
              id
            }
            stops {
              name
              desc
              id
            }
          }
        }
        stoptimes {
          pickupType
          realtimeState
          stop {
            id
            gtfsId
            name
          }
        }
        stoptimesForDate {
          scheduledDeparture
          pickupType
        }
      }
    }
  }
}
''');
