#############################################################################
##
## Multi Indexed Set with Preallocated Storage (implementation)
##
## Copyright (C)  2013 Attila Egri-Nagy
##

ListCreator := function(l)
  if IsEmpty(l) then return []; fi;
  return List([1..l[1]], i -> ListCreator(l{[2..Size(l)]}));
end;

#construct an associative list loaded based on keys and values
InstallGlobalFunction(IndexedSet,
function(indexfunctions, maxindices) #positive integer valued functions
  local enum;
  return Objectify(IndexedSetType,
                 rec(table := ListCreator(maxindices),indexfuncs := indexfunctions));
end);

InstallOtherMethod(AddSet, "for a dynamic indexed set  and an object",
        [IsIndexedSet,IsObject],
function(mgs, obj)
local cursor, i;
  cursor := mgs!.table;
  for i in List(mgs!.indexfuncs, f -> f(obj)) do cursor := cursor[i]; od;
  AddSet(cursor,obj);
end);

InstallOtherMethod(\in, "for a dynamic indexed set and an object",
        [IsObject, IsIndexedSet],
function(obj,mgs)
local cursor,i;
  cursor := mgs!.table;
  for i in List(mgs!.indexfuncs, f -> f(obj)) do cursor := cursor[i]; od;
  return obj in cursor;
end);


InstallOtherMethod(\=, "for dynamic indexed sets", IsIdenticalObj,
        [IsIndexedSet,
         IsIndexedSet],
function(A, B)
  return  A!.table = B!.table; # TODO shall we check the grading functions?
end);

InstallMethod( AsList,"for a dynamic indexed set",
        [ IsIndexedSet ],
function(mgs)
local l,recursivecollect,n;
  n := Size(mgs!.indexfuncs);
  #-----------------------------------------------------------------------------
  recursivecollect := function(table, level, bag)
    local i;
    if level < n then
      for i in [1..Size(table)] do
        recursivecollect(table[i],level+1,bag);
      od;
    else
      for i in [1..Size(table)] do
        Append(bag, table[i]);
      od;
    fi;
  end;
  #-----------------------------------------------------------------------------
  l := [];
  recursivecollect(mgs!.table, 1, l);
  return l;
end);

IndexedSetDistribution := function(mgs)
local l,recursivedistrib,n;
  n := Size(mgs!.indexfuncs);
  #-----------------------------------------------------------------------------
  recursivedistrib := function(table, level, distr)
    local i;
    if level <= n then
      for i in [1..Size(table)] do
        recursivedistrib(table[i],level+1,distr);
      od;
    else
      #for i in [1..Size(table)] do
        Add(distr, Size(table));
      #od;
    fi;
  end;
  #-----------------------------------------------------------------------------
  l := [];
  recursivedistrib(mgs!.table, 1, l);
  return l;
end;


InstallMethod(Size,"for a dynamic indexed set", #TODO maybe counting when adding?
        [ IsIndexedSet ],
function(mgs)
local recursivesum,n;
  n := Size(mgs!.indexfuncs);
  #-----------------------------------------------------------------------------
  recursivesum := function(table, level)
    local i,sum;
    sum := 0;
    if level < n then
      for i in [1..Size(table)] do
        sum := sum + recursivesum(table[i],level+1);
      od;
    else
      for i in [1..Size(table)] do
        sum := sum + Size(table[i]);
      od;
    fi;
    return sum;
  end;
  #-----------------------------------------------------------------------------
  return recursivesum(mgs!.table, 1);
end);

InstallMethod( PrintObj,"for a dynamic indexed set",
        [ IsIndexedSet ],
function(mgs)
local key;
  if IsEmpty(mgs!.table) then
    Print("<empty multi graded set with ",Size(mgs!.indexfuncs) ," layers>");
  else
    Print("<multi graded set with ",Size(mgs), " elements in ",
          Size(mgs!.indexfuncs) ," layers>");
  fi;
end);

TestIndexedSetCorrectness := function()
local T,mgs;
  T := FullTransformationSemigroup(6);
  mgs := IndexedSet([x->1^x, x->2^x, x->3^x, x->4^x],[6,6,6,6]);
  Perform(T, function(t) AddSet(mgs,t);end);
  return Size(AsSet(AsList(mgs))) = Size(T);
end;

# for n=8 speedup is 10x, memrory usage difference is negligeble
TestIndexedSetPerformance := function(n)
  local sl, mgs, partitions,p,t;
  partitions := PartitionsSet([1..n]);
  sl := [];
  t := Runtime();
  for p in partitions do
    AddSet(sl,p);
  od;
  Print("Sorted list was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(sl), " bytes of memory.\n");

  mgs := IndexedSet([Size,x->Size(x[1]),x->Size(x[Size(x)]) ],[n,n,n]);
  t := Runtime();
  for p in partitions do
    AddSet(mgs,p);
  od;
  Print("2-level dynamic indexed set was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(mgs), " bytes of memory.\n");
  Print("Distribution of ", Size(mgs), " elements:",
        IndexedSetDistribution(mgs),"\n");
end;
