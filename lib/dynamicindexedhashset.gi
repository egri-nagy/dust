################################################################################
##
## Dynamic Indexed Set (implementation)
##
## Copyright (C)  2013 Attila Egri-Nagy
##

InstallGlobalFunction(DynamicIndexedHashSet,
function(indexers) #positive integer valued functions
  return Objectify(DynamicIndexedHashSetType,
                 rec(table := [],indexers := indexers, depth:=Size(indexers), list:=[]));
end);

InstallOtherMethod(AddSet, "for a dynamic indexed set and an object",
        [IsDynamicIndexedHashSet,IsObject],
function(dis, obj)
local cursor, i, indices;
  cursor := dis!.table;
  indices := List(dis!.indexers, f->f(obj)); 
  for i in [1..Size(indices)] do
    if not IsBound(cursor[indices[i]]) then
      if i < Size(indices) then
        cursor[indices[i]] := [];
      else
        cursor[indices[i]] := HTCreate(obj);
      fi;
    fi;
    cursor := cursor[indices[i]];
  od;
  if HTValue(cursor,obj) = fail then
    HTAdd(cursor,obj,true);
    Add(dis!.list,obj); #double accounting
  fi;
end);

InstallOtherMethod(\in, "for a dynamic indexed hash set and an object",
        [IsObject, IsDynamicIndexedHashSet],
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
  return HTValue(cursor,obj)=true;
end);

InstallOtherMethod(\=, "for two dynamic indexed hashsets", IsIdenticalObj,
        [IsDynamicIndexedHashSet,IsDynamicIndexedHashSet],
function(A, B) return  AsSortedList(A) = AsSortedList(B); end);

InstallMethod( AsList,"for a dynamic indexed hashset",
        [ IsDynamicIndexedHashSet ],
function(dis)
  return dis!.list;
end);

InstallMethod( Iterator,"for a dynamic indexed hashset",
        [ IsDynamicIndexedHashSet ],
function(dis)
  return Iterator(dis!.list);
end);

InstallMethod( AsSortedList,"for a dynamic indexed hashset",
        [ IsDynamicIndexedHashSet ],
function(dis)
  local l;
  l := ShallowCopy(AsList(dis));
  Sort(l);
  return l;
end);

InstallMethod(Size,"for a dynamic indexed hashset",
        [ IsDynamicIndexedHashSet ],
function(dis)
  return Size(dis!.list);
end);

InstallMethod( PrintObj,"for a dynamic indexed set",
        [ IsDynamicIndexedHashSet ],
function(dis)
local key;
  if IsEmpty(dis!.table) then
    Print("<empty dynamic indexed set with ",Size(dis!.indexers) ," layers>");
  else
    Print("<dynamic indexed set with ",Size(dis), " elements in ",
          Size(dis!.indexers) ," layers>");
  fi;
end);

TestDynamicIndexedHashSetCorrectness := function()
local T,dis;
  T := FullTransformationSemigroup(6);
  dis := DynamicIndexedHashSet([x->1^x, x->2^x, x->3^x, x->4^x]);
  Perform(T, function(t) AddSet(dis,t);end);
  return Size(AsSet(AsList(dis))) = Size(T);
end;

# lot faster but more memory used
TestDynamicIndexedHashSetPerformance := function(n)
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
  dis := DynamicIndexedHashSet([Size,x->Size(x[1])]);
  for p in partitions do
    AddSet(dis,p);
  od;
  Print("2-level dynamic indexed set  was filled up in ", Runtime()-t, "ms, using ",
        MemoryUsage(dis), " bytes of memory.\n");
  t := Runtime();
  for p in partitions do
    b := p in dis;
  od;
  Print("Dynamic indedexed set membership testing  ", Runtime()-t, "ms\n");
end;
