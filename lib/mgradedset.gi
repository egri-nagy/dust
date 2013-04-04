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

InstallOtherMethod(\in, "for a multi graded set and an object",
        [IsObject, IsMultiGradedSet],
function(obj,mgs)
local grades, grfuncs, n, cursor, i;
  grfuncs := mgs!.gradingfuncs;
  n := Size(grfuncs);
  grades := List([1..n],i -> grfuncs[i](obj) );
  cursor := mgs!.table;
  for i in [1..n] do
    if not IsBound(cursor[grades[i]]) then
      return false;
    fi;
    cursor := cursor[grades[i]];
  od;
  return obj in cursor;
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

# for n=8 speedup is 10x, memrory usage difference is negligeble
TestMultiGradedSetPerformance := function(n)
  local sl, mgs, partitions,p,t;
  partitions := PartitionsSet([1..n]);
  t := Runtime();
  sl := [];
  for p in partitions do
    AddSet(sl,p);
  od;
  Print("Sorted list was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(sl), " bytes of memory.\n");
  t := Runtime();
  mgs := MultiGradedSet([Size,x->Size(x[1])]);
  for p in partitions do
    AddSet(mgs,p);
  od;
  Print("2-level multigraded set  was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(mgs), " bytes of memory.\n");
end;
