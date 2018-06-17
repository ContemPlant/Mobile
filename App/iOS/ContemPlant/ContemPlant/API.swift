//  This file was automatically generated and should not be edited.

import Apollo

public final class PlantsQuery: GraphQLQuery {
  public static let operationString =
    "query Plants {\n  plants {\n    __typename\n    id\n    name\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("plants", type: .nonNull(.list(.nonNull(.object(Plant.selections))))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(plants: [Plant]) {
      self.init(snapshot: ["__typename": "Query", "plants": plants.map { (value: Plant) -> Snapshot in value.snapshot }])
    }

    public var plants: [Plant] {
      get {
        return (snapshot["plants"] as! [Snapshot]).map { (value: Snapshot) -> Plant in Plant(snapshot: value) }
      }
      set {
        snapshot.updateValue(newValue.map { (value: Plant) -> Snapshot in value.snapshot }, forKey: "plants")
      }
    }

    public struct Plant: GraphQLSelectionSet {
      public static let possibleTypes = ["Plant"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String) {
        self.init(snapshot: ["__typename": "Plant", "id": id, "name": name])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}