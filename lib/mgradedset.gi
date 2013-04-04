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
                 rec(table := [],gradingfuncs := gradingfunctions));
end);

InstallOtherMethod(AddSet, "for a multi graded set and an object",
        [IsMultiGradedSet,IsObject],
function(mgs, obj)
local grades, grfuncs, n, cursor, i;
  grfuncs := mgs!.gradingfuncs;
  n := Size(grfuncs);
  grades := List([1..n],i -> grfuncs[i](obj) );
  cursor := mgs!.table;
  for i in [1..n] do
    if not IsBound(cursor[grades[i]]) then
      cursor[grades[i]] := [];
    fi;
    cursor := cursor[grades[i]];
  od;
  AddSet(cursor,obj);
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

  fi;
end);
