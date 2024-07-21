# RocksDB
- RocksDB is an embeddable persistent key-value store for fast storage developed by Facebook. 
- It is a fork of Google's LevelDB, optimized to exploit multi-core processors (CPUs) and efficient use of fast storage.
- There is also a MyRocks implementation of RocksDB for MySQL - see further.

## MemTable and Write Ahead Log (WAL)
- MemTable: An in-memory data structure that stores writes before they are flushed to disk. By default, RocksDB uses a skip list for the MemTable, but it can be configured to use other data structures like a vector or a hash table.
- Write Ahead Log (WAL): A sequential log file where all write operations are recorded before being applied to the MemTable. This ensures durability and recoverability in case of a crash.

## SSTables (Sorted String Tables)
- SSTables are immutable files stored on disk, containing a sequence of key-value pairs sorted by keys. 
  - Each SSTable is divided into multiple blocks of valirable sizes.
  - Uses append only pattern

- Uses block of variable sizes 
  - Each block is compressed (if compression is enabled) and contains an index of its keys, a data section with key-value pairs, and a footer. 
  - If compressed size is 5KB, then this is also the block size. It is not put into blocks of fixed sizes, like 8KB.

- Footer: Contains fixed information about the block, such as the compression type and pointers to the block index and metaindex.

## Compaction
- Purpose: To manage the growth of SSTables and ensure efficient use of storage and quick reads. Compaction merges multiple SSTables, removes deleted entries, and sorts data to maintain key order.
- Levels: RocksDB uses a leveled compaction strategy, where SSTables are organized into levels (L0, L1, L2, etc.). Each level has a size limit and a policy for merging files from the previous level.

## Metadata Storage
- Manifest File: A log that keeps track of all the SSTables and their associated metadata, such as file numbers, sequence numbers, and level assignments.
- CURRENT File: A small file that points to the current MANIFEST file.
- OPTIONS File: Stores the configuration options used to create the database, ensuring consistent configuration across restarts.

## Index and Filter Blocks
- Index Block: A structure within an SSTable that allows quick lookups of key ranges within data blocks. The index block is loaded into memory to facilitate fast reads.
- Filter Block: Typically implemented using a Bloom filter, this block helps quickly determine if a key is present in the SSTable, reducing unnecessary reads. It is also loaded into memory for fast access.

## Compression
- Types: RocksDB supports various compression algorithms like Snappy, Zlib, Bzip2, LZ4, and ZSTD. Compression is applied at the block level within SSTables.
- Configuration: Users can configure which compression algorithm to use and control the compression level for each SSTable.

## Read and Write Paths
- Write Path: When a write operation occurs, it is first recorded in the WAL and then added to the MemTable. Once the MemTable is full, it is flushed to disk as an SSTable.
- Read Path: When a read operation occurs, RocksDB checks the MemTable, then the immutable MemTable (if it exists), and finally searches the SSTables from the lowest to the highest level. It uses the index and filter blocks to optimize the search process.

## Background Threads
- Compaction Threads: Dedicated threads handle the compaction process to merge and reorganize SSTables.
- Flush Threads: These threads manage the flushing of MemTables to disk, creating new SSTables.

## Snapshots
- Consistency: Snapshots provide a consistent view of the database at a particular point in time. They are implemented using sequence numbers and ensure that read operations see a stable view of the data.

## Transactions
- Isolation and Atomicity: RocksDB supports transactions, providing mechanisms for atomic writes, rollback, and isolation levels. This is critical for applications requiring ACID (Atomicity, Consistency, Isolation, Durability) guarantees.


# MyRocks
- Developed by Facebook.
- https://engineering.fb.com/2016/08/31/core-infra/myrocks-a-space-and-write-optimized-mysql-database/
- MyRocks was created so RocksDB can support replication and SQL layer.
- Uses the log-structured merge-tree (LSM-tree) architecture of RocksDB.
- Ensures ACID compliance, providing the same level of data consistency and durability as other MySQL storage engines.
- Uses RocksDB column families, allowing different parts of the data to be managed and accessed separately within the same database. 

## MyRocks Architecture

- RocksDB as the Storage Engine: MyRocks uses RocksDB for its underlying storage. RocksDB's LSM-tree structure provides efficient handling of write-heavy workloads.
- MemTable and WAL: Similar to RocksDB, MyRocks uses an in-memory MemTable and a Write Ahead Log (WAL) for logging changes before they are flushed to disk.
- SSTables and Compaction: Data is stored in SSTables, which are immutable sorted files. Compaction is used to merge SSTables and manage space efficiently.
- MySQL Layer: MyRocks integrates with the MySQL layer, handling SQL parsing, query optimization, and transaction management. It exposes the RocksDB storage capabilities through the MySQL interface.

