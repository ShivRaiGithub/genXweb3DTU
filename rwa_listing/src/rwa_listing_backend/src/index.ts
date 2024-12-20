import { Canister, nat, Principal, text, bool, query, update, Vec, Opt } from 'azle';

// Define the RWA type
interface RWA {
    id: nat;
    owner: Principal;
    cost: nat;
    bought: bool;
    title: text;
    description: text;
    image: text;
    email: text;
}

// State variables
let rwas: Vec<RWA> = [];
let rwasByOwner: Map<Principal, Vec<nat>> = new Map();

export default Canister({
    // Register a new RWA
    registerRWA: update([text, text, text, nat, text], nat, (title, description, image, cost, email) => {
        const caller = ic.caller();
        const newRWA: RWA = {
            id: rwas.length,
            owner: caller,
            cost,
            bought: false,
            title,
            description,
            image,
            email
        };

        rwas.push(newRWA);

        if (!rwasByOwner.has(caller)) {
            rwasByOwner.set(caller, []);
        }
        rwasByOwner.get(caller)?.push(newRWA.id);

        return newRWA.id;
    }),

    // Mark an RWA as bought
    rwaBought: update([nat], bool, (id) => {
        if (id >= rwas.length) {
            return false;
        }

        const rwa = rwas[id];
        if (rwa.owner.toText() !== ic.caller().toText()) {
            return false;
        }

        rwas[id] = {
            ...rwa,
            bought: true
        };

        return true;
    }),

    // Get all RWAs
    getAllRWAs: query([], Vec<RWA>, () => {
        return rwas;
    }),

    // Get RWAs by owner
    getRWAsByOwner: query([Principal], Vec<RWA>, (owner) => {
        const ownedRWAIds = rwasByOwner.get(owner) || [];
        return ownedRWAIds.map((id) => rwas[id]);
    })
});
