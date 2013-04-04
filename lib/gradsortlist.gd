################################################################################
##
## Multi Graded Set (declarations)
##
## Copyright (C) 2013  Attila Egri-Nagy
##

DeclareGlobalFunction("MultiGradedSet");

DeclareCategory("IsMultiGradedSet", IsSortedList);
DeclareRepresentation( "IsMultiGradedSetRep",IsComponentObjectRep,
        [ "table", "gradingfuncs"] );
MultiGradedSetType  :=
  NewType(NewFamily("MultiGradedSetFamily",IsMultiGradedSet),
          IsMultiGradedSet and IsMultiGradedSetRep);
