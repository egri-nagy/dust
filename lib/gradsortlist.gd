################################################################################
##
## Graded Sorted List (declarations)
##
## Copyright (C)  Attila Egri-Nagy
##

DeclareGlobalFunction("GradedSortedList");

#the type info
DeclareCategory("IsGradedSortedList", IsSortedList);
DeclareRepresentation( "IsGradedSortedListRep",IsComponentObjectRep,
        [ "table", "gradingfuncs"] );
GradedSortedListType  :=
  NewType(NewFamily("GradedSortedListFamily",IsGradedSortedList),
          IsGradedSortedList and IsGradedSortedListRep);
