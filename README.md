# DUST - OBSOLETE

Some code went into SubSemi and BioGAP.

## GAP package for additional generic data structures. 

Dust is everywhere, but will be wiped off (eventually,
i.e. incorporated into some other package or GAP itself).

1. associative list: index arrays by anything that can be sorted
(as the underlying data structures are sorted lists)
2. general storage structures: queues and stacks,
so you can write your graph search algorithm on a general level,
then feed a stack or a queue getting depth-first of breadth-first search
3. multilevel indexed storage based on supplied list of indexer functions
in order to do load balancing on lists/hashtables
(instead of putting huge amount of elements into one storage)
  
