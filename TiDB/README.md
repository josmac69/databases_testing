# TiDB Data Storage

- Created by PingCAP - https://www.pingcap.com/

- Distributed SQL database with horizontal scalability, strong consistency, and high availability.

- TiDB architecture has three main components: TiDB server, TiKV (distributed key-value store), and PD (Placement Driver).
  - TiDB Server - stateless SQL layer that processes SQL queries, performs optimizations, and coordinates transactions. It does not store data itself but interacts with TiKV for data storage.
  - TiKV 
    - distributed key-value store used by TiDB for data storage. Responsible for persisting data, ensuring data consistency, and providing data retrieval capabilities. 
    - TiKV splits data into regions and replicates them across multiple nodes for fault tolerance.
    - TiKV uses RocksDB as its underlying storage engine. RocksDB is a high-performance key-value store optimized for flash storage. It uses a Log-Structured Merge-Tree (LSM-Tree) to manage data efficiently.
    - https://www.pingcap.com/blog/rocksdb-in-tikv/
    - TiKV uses Titan - RocksDB plugin https://www.pingcap.com/blog/titan-storage-engine-design-and-implementation/

  - PD (Placement Driver) - cluster manager responsible for managing metadata, scheduling data distribution, and ensuring load balancing. It keeps track of all regions and their replicas, and it makes decisions about where data should reside.

- Data Partitioning - TiKV uses a sharding mechanism to split data into regions. Each region is a contiguous range of keys, typically 96MB in size. Regions are the basic unit of data migration and replication.
- Data Replication - TiKV uses the Raft consensus algorithm to replicate regions across multiple nodes. Each region has a leader and several followers. The leader handles all read and write requests, while followers apply log entries and can serve read requests if consistency requirements allow.
    
- Data Organization
  - Rows to Key-Value Pairs - TiDB converts relational data (tables, rows) into key-value pairs before storing them in TiKV. The primary key or row ID of a table row is used as the key, and the row's data is stored as the value.
  - Indexes - Secondary indexes are also stored as key-value pairs. The key is formed by combining the index column values and the row ID, while the value is typically empty or contains a reference to the primary key.

## Data Formats:

1. Row Format:

TiDB uses a custom binary format to encode rows. This format is designed to be compact and efficient for storage and retrieval. Each row is serialized into a binary string, which includes metadata such as column IDs and data types.

2. Key Format:

Keys in TiKV are hierarchical, consisting of multiple components to ensure uniqueness and support various operations. A typical key format for a row is:

- Table Prefix: A fixed prefix to identify the table (0x74).
- Table ID: Unique identifier for the table.
- Record Prefix: Indicates a row record (0x72).
- Row ID: Unique identifier for the row within the table.

For example, a key for a row with ID 123 in table with ID 456 would look like: `0x74_456_0x72_123`.

3. Value Format:

Values in TiKV are the serialized binary representations of rows or index entries. The encoding includes data type information, null flags, and actual column values. The format is designed for fast deserialization and minimal storage overhead.

4. Index Format:

Secondary indexes have their own key format:

- Table Prefix: A fixed prefix to identify the table (0x74).
- Table ID: Unique identifier for the table.
- Index Prefix: Indicates an index record (0x73).
- Index ID: Unique identifier for the index.
- Indexed Column Values: The actual values of the indexed columns.
- Row ID: The primary key or row ID to ensure uniqueness.

For example, an index entry for columns with values `('abc', 123)` in index with ID 789 for table with ID 456 would look like: `0x74_456_0x73_789_abc_123`.

### Transaction Management:

- MVCC (Multi-Version Concurrency Control) - TiKV implements MVCC to manage concurrent transactions. Each write operation creates a new version of a key with a unique timestamp. Readers can access the latest version of a key that is valid at their transaction's start time, ensuring consistent views of the data.
- Write-Ahead Logging - TiKV uses a write-ahead log (WAL) to ensure durability. Changes are first written to the WAL before being applied to the data store, providing recovery in case of failures.

## High Availability and Scalability:
- Horizontal Scalability - TiDB's architecture supports horizontal scaling by adding more TiKV nodes to the cluster. PD automatically redistributes regions across nodes to balance load and ensure efficient resource utilization.
- Fault Tolerance - TiKV's use of the Raft protocol ensures that data remains available and consistent even if some nodes fail. PD continuously monitors the cluster's health and can initiate automatic failover to maintain availability.


## RocksDB Titan plugin

### TiKV RocksDB Customizations

1. Titan (Large Values Storage):
   - Overview: Titan is a plugin for RocksDB that improves the performance of handling large values.
   - Functionality: It separates large values from the LSM-Tree and stores them in a different blob storage, which helps in reducing write amplification and improving write and read performance.
   - Usage in TiDB: Titan is used to handle cases where TiDB needs to store large amounts of data in individual fields efficiently.

2. Optimized Compaction:
   - Overview: Compaction is a process in RocksDB that merges different levels of SSTables (Sorted String Tables) to reclaim space and improve read performance.
   - Functionality: TiKV includes optimizations for the compaction process, making it more efficient and reducing the impact on performance during heavy write operations.
   - Usage in TiDB: This ensures that TiDB can handle high write throughput without significant performance degradation.

3. Custom Rate Limiter:
   - Overview: Rate limiting is used to control the rate of I/O operations to avoid overwhelming the storage medium.
   - Functionality: TiKV's RocksDB uses a custom rate limiter that is aware of the specific workload patterns of TiDB, providing more effective I/O management.
   - Usage in TiDB: Helps in maintaining consistent performance by preventing spikes in I/O operations from affecting overall system performance.

4. Advanced Block Cache:
   - Overview: Block caching improves read performance by storing frequently accessed data in memory.
   - Functionality: TiKV's RocksDB includes enhancements to the block cache mechanism, making it more efficient and better suited for TiDB's access patterns.
   - Usage in TiDB: Enhances read performance by reducing the need to access data from disk frequently.

5. Write-Ahead Log (WAL) Optimizations:
   - Overview: WAL is used to ensure durability by logging all write operations before they are applied to the main data store.
   - Functionality: TiKV's RocksDB includes optimizations to the WAL to reduce latency and improve write throughput.
   - Usage in TiDB: Ensures data durability while maintaining high write performance.

6. Multi-threaded Compaction and Flush:
   - Overview: Utilizing multiple threads for compaction and flush operations can improve performance on multi-core systems.
   - Functionality: TiKV's RocksDB has been optimized to effectively use multiple CPU cores for these operations.
   - Usage in TiDB: Allows TiDB to leverage modern multi-core processors for better performance.

### How These Enhancements Benefit TiDB

- Scalability: The enhancements allow TiDB to handle large-scale data efficiently, making it suitable for enterprise-level applications with heavy workloads.
- Performance: Optimizations in compaction, caching, and I/O management ensure that TiDB maintains high performance even under heavy read and write loads.
- Consistency: The use of WAL and other durability mechanisms ensures that TiDB provides strong consistency guarantees, which is crucial for transactional workloads.
- Resource Utilization: Multi-threaded operations and custom rate limiting help in making effective use of available hardware resources, providing a balanced performance profile.

