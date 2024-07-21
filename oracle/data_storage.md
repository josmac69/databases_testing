# Oracle data storage

## Datafiles
- https://docs.oracle.com/en/database/oracle/oracle-database/19/admin/managing-data-files-and-temp-files.html#GUID-501A8889-3C18-4F99-B0B7-9095E981B970
- Structure:

  - Data block (pages) - the smallest unit of I/O, typically sized from 2KB to 32KB, stores rows or their chunks

  - Structure: Each block contains:
    - Block Header: Metadata about the block, such as block address and type.
    - Table Directory: Information about the tables that have rows in this block (for clusters)
    - Row Directory: Pointers to the rows in the block.
    - Row Data: The actual data stored in rows.
    - Free Space: Unused space available for new rows.

  - Extent - a collection of contiguous data blocks.
    - Command CREATE TABLESPACE allows you to define size of extents and their number by setting maxsize of tablespace.

  - Segment - a collection of extents allocated for a specific type of database object. 
    - Types: Data segments (tables, clusters), index segments, temporary segments, undo segments.
    - Partitions are stored each in its own segment.
    - "High wate mark" - boundary between used and unused space in a segmen
    - Bitmapped blocks - leaf structure, describe the space usage of each block within a segment.

## Control Files
- https://docs.oracle.com/cd/B10500_01/server.920/a96521/control.htm
- Control files maintain the state of the physical structure of the database. They store:
  - Database name and timestamp of database creation.
  - Names and locations of datafiles and redo log files.
  - Checkpoint information.
  - Log sequence number.
  - Begin and end of backup information.

## Redo Log Files
- https://docs.oracle.com/en/database/oracle/oracle-database/19/admin/managing-the-redo-log.html
- Two or more preallocated files, which store all changes made to the database..
- Essential for recovery operations. 
- They contain:
  - Redo records (Change vectors).
  - Log sequence numbers (LSN).

## Archived Redo Log Files
- https://docs.oracle.com/en/database/oracle/oracle-database/19/admin/managing-archived-redo-log-files.html#GUID-5EE4AC49-E1B2-41A2-BEE7-AA951EAAB2F3
- Copies of redo log files that have been archived to ensure data can be recovered in the event of a failure.
- //TODO??

## Parameter Files (PFILE/SPFILE)
- Configuration settings for the instance startup and operation.

## Password File
- Format: Binary file.
- Content: Used for authenticating privileged users.

## Temporary Files
- Format: Binary files.
- Content: Used for operations like sorting and joining, which require intermediate storage.

## Logical Storage Structure
Oracle's logical storage is organized into several layers:

## Tablespaces
- Definition: Logical storage units that group related logical structures together.
- Types: SYSTEM, SYSAUX, USER, TEMP, UNDO, etc.


## Database objects

- Tables
  - Types: Heap-organized tables, Index-organized tables, Partitioned tables, External tables.

- Indexes
  - Types: B-tree indexes, Bitmap indexes, Function-based indexes, Domain indexes.

- Clusters
  - Definition: A group of tables that share the same data blocks.

- LOBs (Large Objects)
  - Types: BLOB, CLOB, NCLOB, BFILE.

## Transaction Management and Concurrency Control

- Undo Segments
  - Purpose: Store old values of data that have been modified, allowing for rollback operations and read consistency.

- Redo Logs
  - Purpose: Capture all changes to the database, ensuring recoverability.

- Locks
  - Purpose: Mechanisms to control concurrent access to data, ensuring data integrity.
