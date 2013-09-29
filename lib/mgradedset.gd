################################################################################
##
## Dynamic Indexed Set (declarations)
##
## Copyright (C) 2013  Attila Egri-Nagy
##

DeclareGlobalFunction("DynamicIndexedSet");

DeclareCategory("IsDynamicIndexedSet", IsSortedList);
DeclareRepresentation( "IsDynamicIndexedSetRep",IsComponentObjectRep,
        [ "depth", "table", "indexers"] );
DynamicIndexedSetType  :=
  NewType(NewFamily("DynamicIndexedSetFamily",IsDynamicIndexedSet),
          IsDynamicIndexedSet and IsDynamicIndexedSetRep);
