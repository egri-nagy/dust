################################################################################
##
## Multi Graded Hashtable (declarations)
##
## Copyright (C) 2013  Attila Egri-Nagy
##

DeclareGlobalFunction("MultiGradedHashtab");

DeclareCategory("IsMultiGradedHashtab", IsSortedList);
DeclareRepresentation( "IsMultiGradedHashtabRep",IsComponentObjectRep,
        [ "table", "gradingfuncs"] );
MultiGradedHashtabType  :=
  NewType(NewFamily("MultiGradedHashtabFamily",IsMultiGradedHashtab),
          IsMultiGradedHashtab and IsMultiGradedHashtabRep);
