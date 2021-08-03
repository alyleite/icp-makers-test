import Nat32 "mo:base/Nat32";

module Types {

  // Define to-do item properties
  public type Register = {
    id: Nat32;
    email: Text;
  };
};