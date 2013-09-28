################################################################################
##
## Multi Indexed Set with Preallocated Storage (declarations)
##
## Copyright (C) 2013  Attila Egri-Nagy
##

DeclareGlobalFunction("IndexedSet");

DeclareCategory("IsIndexedSet", IsSortedList);
DeclareRepresentation( "IsIndexedSetRep",IsComponentObjectRep,
        [ "table", "indexfuncs"] );
IndexedSetType  :=
  NewType(NewFamily("IndexedSetFamily",IsIndexedSet),
          IsIndexedSet and IsIndexedSetRep);
