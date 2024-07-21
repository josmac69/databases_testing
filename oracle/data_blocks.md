# Data blocks

- Typically, data block sizes can be 2KB, 4KB, 8KB, 16KB, 32KB. Default is 8KB.
  - SGA (System Global Area) has a separate buffer cache for each block size
    - DB_2K_CACHE_SIZE - DB_32K_CACHE_SIZE
    - Frequently accessed blocks are kept in the buffer cache to improve performance.
    - Uses LRU (Least Recently Used) algorithm for managing blocks in the cache.
    
- Block size is determined at the tablespace level when the tablespace is created.
  - Smaller block sizes can lead to less wasted space but more blocks to manage.
  - Larger block sizes can improve read efficiency but may lead to more wasted space.

- Block corruption detection
  - Oracle uses checksums and other methods to detect block corruption.
  - DBMS_REPAIR and RMAN (Recovery Manager) are used for detecting and repairing corrupt blocks.

## Block Header
- Contains metadata about the block.
- Content:
  - Block address and type.
  - Sequence number for the block.
  - Information on free space management.
  - Transaction information for concurrency control.

## Table Directory
- Stores information about the tables whose rows are contained in the block (multiple for clusters)
- Contains table IDs corresponding to rows in the block.

## Row Directory
- Contains pointers to the actual rows in the block.
- Array of offsets pointing to the starting address of each row within the block.

## Row Data
- Content:
  - Row Header: Includes the row's lock status, column count, and other metadata.
  - Column Data: The actual data values of the row's columns, stored in a variable-length format.
  - Free Space: Unused space within the block that can be allocated for row growth or new row insertion.

- Rows are stored in a variable-length format within the block.
  - Row Chaining: Occurs when a row is too large to fit into a single block and spans multiple blocks.
  - Row Migration: Occurs when a row is updated and no longer fits in its original block, causing it to be moved to a new block with a pointer left behind.

## Indexes
- Indexes contain pointers to rows within blocks, allowing for quick location of data.

## Transaction Information
- Block Header: Contains information about active transactions affecting the block.
- ITL (Interested Transaction List): Part of the block header that records transaction entries, helping manage concurrent transactions.

## Locks and Consistency
- Row-level Locks: Ensure that rows are locked during updates to prevent concurrent modifications.
- Read Consistency: Oracle uses undo data and rollback segments to provide read consistency, ensuring users see a consistent view of the data.

## Recovery
- Redo Logs: Contain the history of changes to the blocks, essential for recovery.
- Undo Segments: Store previous versions of changed data, aiding in rolling back transactions if needed.

## Advanced Features
- Compression - Basic table compression, OLTP compression, and hybrid columnar compression.
- Encryption - Transparent Data Encryption (TDE) allows encryption without requiring changes to applications.

## Monitoring Tools
- Views: DBA_TABLES, DBA_SEGMENTS, DBA_FREE_SPACE provide insights into block usage and space allocation.
- Automatic Workload Repository (AWR): Collects performance data, helping in tuning database performance.

## Tuning Techniques
- Block Size: Choosing the optimal block size based on workload.
- Buffer Cache: Adjusting the size of the buffer cache to ensure frequently accessed blocks remain in memory.
- Automatic segment space management.

