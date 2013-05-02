#############################################################################
##
## Multi Graded Set (implementation)
##
## Copyright (C)  2013 Attila Egri-Nagy
##

#construct an associative list loaded based on keys and values
InstallGlobalFunction(MultiGradedHashtab,
function(gradingfunctions) #positive integer valued functions
  return Objectify(MultiGradedHashtabType,
                 rec(table := [],gradingfuncs := gradingfunctions));
end);

InstallOtherMethod(AddSet, "for a multi graded set and an object",
        [IsMultiGradedHashtab,IsObject],
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
        [IsObject, IsMultiGradedHashtab],
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
        [IsMultiGradedHashtab,
         IsMultiGradedHashtab],
function(A, B)
  return  A!.table = B!.table; # TODO shall we check the grading functions?
end);

InstallMethod( AsList,"for a multigraded set",
        [ IsMultiGradedHashtab ],
function(mgs)
local l,recursivecollect,n;
  n := Size(mgs!.gradingfuncs);
  #-----------------------------------------------------------------------------
  recursivecollect := function(table, level, bag)
    local i;
    if level < n then
      for i in [1..Size(table)] do
        if IsBound(table[i]) then
          recursivecollect(table[i],level+1,bag);
        fi;
      od;
    else
      for i in [1..Size(table)] do
        if IsBound(table[i]) then
          Append(bag, table[i]);
        fi;
      od;
    fi;
  end;
  #-----------------------------------------------------------------------------
  l := [];
  recursivecollect(mgs!.table, 1, l);
  return l;
end);

InstallMethod(Size,"for a multigraded set", #TODO maybe counting when adding?
        [ IsMultiGradedHashtab ],
function(mgs)
local recursivesum,n;
  n := Size(mgs!.gradingfuncs);
  #-----------------------------------------------------------------------------
  recursivesum := function(table, level)
    local i,sum;
    sum := 0;
    if level < n then
      for i in [1..Size(table)] do
        if IsBound(table[i]) then
          sum := sum + recursivesum(table[i],level+1);
        fi;
      od;
    else
      for i in [1..Size(table)] do
        if IsBound(table[i]) then
          sum := sum + Size(table[i]);
        fi;
      od;
    fi;
    return sum;
  end;
  #-----------------------------------------------------------------------------
  return recursivesum(mgs!.table, 1);
end);

InstallMethod( PrintObj,"for a multigraded set",
        [ IsMultiGradedHashtab ],
function(mgs)
local key;
  if IsEmpty(mgs!.table) then
    Print("<empty multi graded set with ",Size(mgs!.gradingfuncs) ," layers>");
  else
    Print("<multi graded set with ",Size(mgs), " elements in ",
          Size(mgs!.gradingfuncs) ," layers>");
  fi;
end);

TestMultiGradedHashtabCorrectness := function()
local T,mgs;
  T := FullTransformationSemigroup(6);
  mgs := MultiGradedHashtab([x->1^x, x->2^x, x->3^x, x->4^x]);
  Perform(T, function(t) AddSet(mgs,t);end);
  return Size(AsSet(AsList(mgs))) = Size(T);
end;

# for n=8 speedup is 10x, memrory usage difference is negligeble
TestMultiGradedHashtabPerformance := function(n)
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
  mgs := MultiGradedHashtab([Size,x->Size(x[1])]);
  for p in partitions do
    AddSet(mgs,p);
  od;
  Print("2-level multigraded set  was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(mgs), " bytes of memory.\n");
end;
