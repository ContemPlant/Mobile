//  This file was automatically generated and should not be edited.

import Apollo

public enum MutationType: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case created
  case updated
  case deleted
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREATED": self = .created
      case "UPDATED": self = .updated
      case "DELETED": self = .deleted
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .created: return "CREATED"
      case .updated: return "UPDATED"
      case .deleted: return "DELETED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: MutationType, rhs: MutationType) -> Bool {
    switch (lhs, rhs) {
      case (.created, .created): return true
      case (.updated, .updated): return true
      case (.deleted, .deleted): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class PlantsQuery: GraphQLQuery {
  public let operationDefinition =
    "query Plants {\n  plants {\n    __typename\n    ...BasicPlantDetails\n  }\n}"

  public var queryDocument: String { return operationDefinition.appending(BasicPlantDetails.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("plants", type: .nonNull(.list(.nonNull(.object(Plant.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(plants: [Plant]) {
      self.init(unsafeResultMap: ["__typename": "Query", "plants": plants.map { (value: Plant) -> ResultMap in value.resultMap }])
    }

    public var plants: [Plant] {
      get {
        return (resultMap["plants"] as! [ResultMap]).map { (value: ResultMap) -> Plant in Plant(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Plant) -> ResultMap in value.resultMap }, forKey: "plants")
      }
    }

    public struct Plant: GraphQLSelectionSet {
      public static let possibleTypes = ["Plant"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("plantStates", arguments: ["last": 1], type: .list(.nonNull(.object(PlantState.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, plantStates: [PlantState]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Plant", "id": id, "name": name, "plantStates": plantStates.flatMap { (value: [PlantState]) -> [ResultMap] in value.map { (value: PlantState) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var plantStates: [PlantState]? {
        get {
          return (resultMap["plantStates"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [PlantState] in value.map { (value: ResultMap) -> PlantState in PlantState(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [PlantState]) -> [ResultMap] in value.map { (value: PlantState) -> ResultMap in value.resultMap } }, forKey: "plantStates")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var basicPlantDetails: BasicPlantDetails {
          get {
            return BasicPlantDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }

      public struct PlantState: GraphQLSelectionSet {
        public static let possibleTypes = ["PlantState"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("health", type: .nonNull(.scalar(Double.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, health: Double) {
          self.init(unsafeResultMap: ["__typename": "PlantState", "id": id, "health": health])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var health: Double {
          get {
            return resultMap["health"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "health")
          }
        }
      }
    }
  }
}

public final class NewPlantsSubscription: GraphQLSubscription {
  public let operationDefinition =
    "subscription NewPlants {\n  newPlant {\n    __typename\n    mutation\n    node {\n      __typename\n      id\n      name\n    }\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("newPlant", type: .object(NewPlant.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(newPlant: NewPlant? = nil) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "newPlant": newPlant.flatMap { (value: NewPlant) -> ResultMap in value.resultMap }])
    }

    public var newPlant: NewPlant? {
      get {
        return (resultMap["newPlant"] as? ResultMap).flatMap { NewPlant(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "newPlant")
      }
    }

    public struct NewPlant: GraphQLSelectionSet {
      public static let possibleTypes = ["PlantSubscriptionPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("mutation", type: .nonNull(.scalar(MutationType.self))),
        GraphQLField("node", type: .object(Node.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(mutation: MutationType, node: Node? = nil) {
        self.init(unsafeResultMap: ["__typename": "PlantSubscriptionPayload", "mutation": mutation, "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var mutation: MutationType {
        get {
          return resultMap["mutation"]! as! MutationType
        }
        set {
          resultMap.updateValue(newValue, forKey: "mutation")
        }
      }

      public var node: Node? {
        get {
          return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "node")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes = ["Plant"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String) {
          self.init(unsafeResultMap: ["__typename": "Plant", "id": id, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}

public final class LoadPlantOnArduMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation LoadPlantOnArdu($arduID: String!, $plantID: ID!) {\n  loadPlantOnArdu(arduId: $arduID, plantId: $plantID) {\n    __typename\n    arduId\n  }\n}"

  public var arduID: String
  public var plantID: GraphQLID

  public init(arduID: String, plantID: GraphQLID) {
    self.arduID = arduID
    self.plantID = plantID
  }

  public var variables: GraphQLMap? {
    return ["arduID": arduID, "plantID": plantID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("loadPlantOnArdu", arguments: ["arduId": GraphQLVariable("arduID"), "plantId": GraphQLVariable("plantID")], type: .object(LoadPlantOnArdu.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(loadPlantOnArdu: LoadPlantOnArdu? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "loadPlantOnArdu": loadPlantOnArdu.flatMap { (value: LoadPlantOnArdu) -> ResultMap in value.resultMap }])
    }

    public var loadPlantOnArdu: LoadPlantOnArdu? {
      get {
        return (resultMap["loadPlantOnArdu"] as? ResultMap).flatMap { LoadPlantOnArdu(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "loadPlantOnArdu")
      }
    }

    public struct LoadPlantOnArdu: GraphQLSelectionSet {
      public static let possibleTypes = ["Ardu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("arduId", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(arduId: String) {
        self.init(unsafeResultMap: ["__typename": "Ardu", "arduId": arduId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var arduId: String {
        get {
          return resultMap["arduId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "arduId")
        }
      }
    }
  }
}

public final class UnloadPlantMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation UnloadPlant($plantID: ID!) {\n  unloadPlant(plantId: $plantID) {\n    __typename\n    arduId\n  }\n}"

  public var plantID: GraphQLID

  public init(plantID: GraphQLID) {
    self.plantID = plantID
  }

  public var variables: GraphQLMap? {
    return ["plantID": plantID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("unloadPlant", arguments: ["plantId": GraphQLVariable("plantID")], type: .object(UnloadPlant.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(unloadPlant: UnloadPlant? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "unloadPlant": unloadPlant.flatMap { (value: UnloadPlant) -> ResultMap in value.resultMap }])
    }

    public var unloadPlant: UnloadPlant? {
      get {
        return (resultMap["unloadPlant"] as? ResultMap).flatMap { UnloadPlant(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "unloadPlant")
      }
    }

    public struct UnloadPlant: GraphQLSelectionSet {
      public static let possibleTypes = ["Ardu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("arduId", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(arduId: String) {
        self.init(unsafeResultMap: ["__typename": "Ardu", "arduId": arduId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var arduId: String {
        get {
          return resultMap["arduId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "arduId")
        }
      }
    }
  }
}

public struct BasicPlantDetails: GraphQLFragment {
  public static let fragmentDefinition =
    "fragment BasicPlantDetails on Plant {\n  __typename\n  id\n  name\n  plantStates(last: 1) {\n    __typename\n    id\n    health\n  }\n}"

  public static let possibleTypes = ["Plant"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("plantStates", arguments: ["last": 1], type: .list(.nonNull(.object(PlantState.selections)))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String, plantStates: [PlantState]? = nil) {
    self.init(unsafeResultMap: ["__typename": "Plant", "id": id, "name": name, "plantStates": plantStates.flatMap { (value: [PlantState]) -> [ResultMap] in value.map { (value: PlantState) -> ResultMap in value.resultMap } }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var plantStates: [PlantState]? {
    get {
      return (resultMap["plantStates"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [PlantState] in value.map { (value: ResultMap) -> PlantState in PlantState(unsafeResultMap: value) } }
    }
    set {
      resultMap.updateValue(newValue.flatMap { (value: [PlantState]) -> [ResultMap] in value.map { (value: PlantState) -> ResultMap in value.resultMap } }, forKey: "plantStates")
    }
  }

  public struct PlantState: GraphQLSelectionSet {
    public static let possibleTypes = ["PlantState"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("health", type: .nonNull(.scalar(Double.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, health: Double) {
      self.init(unsafeResultMap: ["__typename": "PlantState", "id": id, "health": health])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var health: Double {
      get {
        return resultMap["health"]! as! Double
      }
      set {
        resultMap.updateValue(newValue, forKey: "health")
      }
    }
  }
}