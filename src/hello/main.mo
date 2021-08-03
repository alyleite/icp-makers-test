import Types "types";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import List "mo:base/List";
import Option "mo:base/Option";
import Debug "mo:base/Debug";

actor {
    
    type Register = Types.Register;

    private stable var registers : Trie.Trie<Nat32, Register> = Trie.empty();
    // The next available register identifier.
    private stable var next : Nat32 = 0;    

     // Create a register.
    public func create(email : Text) : async Nat32 {
        let registerId = next;
        next += 1;

        let register : Register = {
            id = registerId;
            email = email;
        };

		registers := Trie.replace(registers, key(registerId), Nat32.equal, ?register).0;

        return registerId;
    };

    // Read a register.
    public query func read(registerId : Nat32) : async ?Register {
        let result = Trie.find(registers, key(registerId), Nat32.equal);
        return result;
    };

    public query func readEmail (email : Text) : async Trie.Trie<Nat32, Register>  {   
        let result = Trie.filter<Nat32, Register>(registers, func (k, v) { v.email == email });
        return result;
    };

    // Update a register.
    public func update(registerId : Nat32, register : Register) : async Bool {
        let result = Trie.find(registers, key(registerId), Nat32.equal);
        let exists = Option.isSome(result);
        if (exists) {
            registers := Trie.replace(
                registers,
                key(registerId),
                Nat32.equal,
                ?register,
            ).0;
        };
        return exists;
    };

    // Delete a register.
    public func delete(registerId : Nat32) : async Bool {
        let result = Trie.find(registers, key(registerId), Nat32.equal);
        let exists = Option.isSome(result);
        if (exists) {
            registers := Trie.replace(
                registers,
                key(registerId),
                Nat32.equal,
                null,
            ).0;
        };
        return exists;
    };

    /**
    * Utilities
    */

    // Create a trie key from a register identifier.
    private func key(x : Nat32) : Trie.Key<Nat32> {
        return { hash = x; key = x };
    };
};
