################################################################################
##
## Multi Graded Set (implementation)
##
## Copyright (C)  2013 Attila Egri-Nagy
##

InstallGlobalFunction(DynamicIndexedSet,
function(indexers) #positive integer valued functions
  return Objectify(DynamicIndexedSetType,
                 rec(table := [],indexers := indexers, depth:=Size(indexers)));
end);

InstallOtherMethod(AddSet, "for a multi graded set and an object",
        [IsDynamicIndexedSet,IsObject],
function(dis, obj)
local cursor, i;
  cursor := dis!.table;
  for i in List(dis!.indexers, f->f(obj)) do
    if not IsBound(cursor[i]) then
      cursor[i] := [];
    fi;
    cursor := cursor[i];
  od;
  AddSet(cursor,obj);
end);

InstallOtherMethod(\in, "for a multi graded set and an object",
        [IsObject, IsDynamicIndexedSet],
function(obj,dis)
local val, cursor, i;
  cursor := dis!.table;
  for i in [1..dis!.depth] do
    val := dis!.indexers[i](obj);
    if not IsBound(cursor[val]) then
      return false;
    fi;
    cursor := cursor[val];
  od;
  return obj in cursor;
end);

InstallOtherMethod(\=, "for two multi graded sets", IsIdenticalObj,
        [IsDynamicIndexedSet,IsDynamicIndexedSet],
function(A, B) return  AsSet(A) = AsSet(B); end);

InstallMethod( AsList,"for a dynamic indexed set",
        [ IsDynamicIndexedSet ],
function(dis)
local l,recursivecollect,n;
  n := Size(dis!.indexers);
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
  recursivecollect(dis!.table, 1, l);
  return l;
end);

InstallMethod( AsSortedList,"for a dynamic indexed set",
        [ IsDynamicIndexedSet ],
function(dis)
  local l;
  l := AsList(dis);
  Sort(l);
  return l;
end);

InstallMethod(Size,"for a multigraded set", #TODO maybe counting when adding?
        [ IsDynamicIndexedSet ],
function(dis)
local recursivesum,n;
  n := Size(dis!.indexers);
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
  return recursivesum(dis!.table, 1);
end);

InstallMethod( PrintObj,"for a multigraded set",
        [ IsDynamicIndexedSet ],
function(dis)
local key;
  if IsEmpty(dis!.table) then
    Print("<empty multi graded set with ",Size(dis!.indexers) ," layers>");
  else
    Print("<multi graded set with ",Size(dis), " elements in ",
          Size(dis!.indexers) ," layers>");
  fi;
end);

TestDynamicIndexedSetCorrectness := function()
local T,dis;
  T := FullTransformationSemigroup(6);
  dis := DynamicIndexedSet([x->1^x, x->2^x, x->3^x, x->4^x]);
  Perform(T, function(t) AddSet(dis,t);end);
  return Size(AsSet(AsList(dis))) = Size(T);
end;

# for n=8 speedup is 10x, memory usage difference is negligeble
TestDynamicIndexedSetPerformance := function(n)
  local sl, dis, partitions,p,t,b;
  partitions := PartitionsSet([1..n]);
  t := Runtime();
  sl := [];
  for p in partitions do
    AddSet(sl,p);
  od;
  Print("Sorted list was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(sl), " bytes of memory.\n");
  t := Runtime();
  for p in partitions do
    b := p in sl;
  od;
  Print("Sorted list membership testing  ", Runtime()-t, "ms\n");
  t := Runtime();
  dis := DynamicIndexedSet([Size,x->Size(x[1])]);
  for p in partitions do
    AddSet(dis,p);
  od;
  Print("2-level multigraded set  was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(dis), " bytes of memory.\n");
  t := Runtime();
  for p in partitions do
    b := p in dis;
  od;
  Print("Dynamic indedexed set membership testing  ", Runtime()-t, "ms\n");
  
end;
