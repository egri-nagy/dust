################################################################################
##
## Multi Graded Set (declarations)
##
## Copyright (C) 2013  Attila Egri-Nagy
##

DeclareGlobalFunction("DynamicIndexedSet");

DeclareCategory("IsDynamicIndexedSet", IsSortedList);
DeclareRepresentation( "IsDynamicIndexedSetRep",IsComponentObjectRep,
        [ "table", "gradingfuncs"] );
DynamicIndexedSetType  :=
  NewType(NewFamily("DynamicIndexedSetFamily",IsDynamicIndexedSet),
          IsDynamicIndexedSet and IsDynamicIndexedSetRep);
