import AssocList "mo:base/AssocList";
import Array "mo:base/Array";
import Principal "mo:base/Principal";

actor RWA {
    // Define the RWA record type
    type RWA = {
        id: Nat;
        owner: Principal;
        cost: Nat;
        bought: Bool;
        title: Text;
        description: Text;
        image: Text;
        email: Text;
    };

    // State variables
    stable var rwas: [RWA] = [];
    stable var rwasByOwner: AssocList.AssocList<Principal, [Nat]> = AssocList.empty();

    // Register a new RWA
    public shared ({caller}) func registerRWA(
        title: Text,
        description: Text,
        image: Text,
        cost: Nat,
        email: Text
    ): async Nat {
        let newRWA: RWA = {
            id = Nat.rwas.size();
            owner = caller;
            cost = cost;
            bought = false;
            title = title;
            description = description;
            image = image;
            email = email;
        };

        // Add the new RWA to the list
        rwas := Array.append<RWA>(rwas, [newRWA]);

        // Update the mapping for the owner
        let ownerRWAs: [Nat] = switch (AssocList.get<Principal, [Nat]>(rwasByOwner, caller)) {
            case (null) [];
            case (?list) list;
        };
        rwasByOwner := AssocList.replace<Principal, [Nat]>(
            rwasByOwner,
            caller,
            func(_, _) { Some<Array.append<Nat>(ownerRWAs, [newRWA.id]) }
        );

        return newRWA.id;
    };

    // Mark an RWA as bought
    public shared ({caller}) func rwaBought(id: Nat): async Bool {
        if (id >= rwas.size()) {
            return false;
        };

        let rwa: RWA = rwas[id];
        if (rwa.owner != caller) {
            return false;
        };

        let updatedRWA: RWA = rwa;
        updatedRWA.bought := true;

        rwas[id] := updatedRWA;

        return true;
    };

    // Get all RWAs
    public query func getAllRWAs(): async [RWA] {
        return rwas;
    };

    // Get RWAs by owner
   // Get RWAs by owner
public query func getRWAsByOwner(owner: Principal): async [RWA] {
    let ownedRWAIds: [Nat] = switch (AssocList.get<Principal, [Nat]>(rwasByOwner, owner)) {
        case (null) [];
        case (?list) list;
    };

    return Array.map<Nat, RWA>(ownedRWAIds, func (id: Nat): RWA { rwas[id] });
};

};
