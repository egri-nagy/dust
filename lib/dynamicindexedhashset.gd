################################################################################
##
## Dynamic Indexed HashSet (declarations)
##
## Copyright (C) 2013  Attila Egri-Nagy
##

DeclareGlobalFunction("DynamicIndexedHashSet");

DeclareCategory("IsDynamicIndexedHashSet", IsSortedList);
DeclareRepresentation( "IsDynamicIndexedHashSetRep",IsComponentObjectRep,
        [ "depth", "table", "indexers", "list"] );
DynamicIndexedHashSetType  :=
  NewType(NewFamily("DynamicIndexedHashSetFamily",IsDynamicIndexedHashSet),
          IsDynamicIndexedHashSet and IsDynamicIndexedHashSetRep);
