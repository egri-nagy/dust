#############################################################################
##
## Multi Graded Set (implementation)
##
## Copyright (C)  2013 Attila Egri-Nagy
##

#construct an associative list loaded based on keys and values
InstallGlobalFunction(MultiGradedSet,
function(gradingfunctions) #positive integer valued functions
  return Objectify(MultiGradedSetType,
                 rec(table := [],gradinguncs := gradingfunctions));
end);

InstallOtherMethod(AddSet, "for a multi graded set and an object",
function(mgs, obj)
local grades, grfuncs, n, cursor;
  grfuncs := mgs!.gradingfuncs;
  n := Size(grfuncs);
  grades := List([1..n],i -> grfuncs[i](obj) );
  cursor := mgs!.table;
  for i in [1..n] do
    
  od;
end);

InstallOtherMethod(\=, "for two multi graded sets", IsIdenticalObj,
        [IsMultiGradedSet,
         IsMultiGradedSet],
function(A, B)
  return  A!.table = B!.table; # TODO shall we check the grading functions?
end);

InstallMethod( PrintObj,"for a multigraded set",
        [ IsMultiGradedSet ],
function(mgs)
local key;
  if IsEmpty(mgs!.table) then
    Print("<empty multi graded set>");
  else
    for key in Keys(al) do
      Print(key," -> ", al[key],"\n");
    od;
  fi;
end);
