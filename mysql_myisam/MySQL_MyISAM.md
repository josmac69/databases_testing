# MySQL data storage - MyISAM

- Designed mainly for read-heavy operations.
- Does not have transactions.
- Does not support foreign keys or row-level locking.
- Uses only table-level locking. It means the entire table is locked during read or write operations. This can lead to contention in write-heavy environments.
- Supports full-text indexes, enabling efficient text searching capabilities.
- Tables can be compressed to save space.
- Tool `myisamchk` is available for repairing and recovering tables.

- There several files belonging to one table:
  1. Data File (`.MYD`) - contains data records.
  2. Index File (`.MYI`) - contains all indexes.
  3. Table Definition File (`.frm`) - table definition and metadata.

## Data File (`.MYD`)

The `.MYD` file contains all the table's data. Each record in the data file includes record header and field values. Record header contains metadata about the record, such as the length and status (e.g., deleted or active). Rows are stored sequentially

- Record Formats:
  - Fixed-length - all records have the same size. Ideal for tables with frequent updates and deletions, avoids fragmentation.
  - Dynamic-length - records can have variable sizes due to varying lengths of data types `VARCHAR` or `TEXT`. This format is more space-efficient but data file can suffer from fragmentation.

### Storage of Different Data Types

- Numeric types - binary format.
- Date and time types - binary format.
- String types:
  - Fixed-length strings are padded with spaces,
  - Variable-length strings are prefixed with length.

## Index File (`.MYI`)

The `.MYI` file contains all the table's indexes. MyISAM supports multiple index types - primary key, unique index, full-text index, spatial index (geometry).
Indexes are stored in fixed-size blocks. Each page contains index entries and pointers to other pages. The root page starts the tree structure, and leaf pages store the actual index entries.

- B-tree structure: Used for most indexes. Provides fast lookups, insertions, and deletions.
- Full-text indexes: Use an internal structure optimized for text search.
- Spatial indexes: Use an R-tree structure.

## Table Definition File (`.frm`)

The `.frm` file stores the table schema:

- Table name and column definitions.
- Column data types and attributes (e.g., `NOT NULL`, `AUTO_INCREMENT`).
- Index definitions and constraints.
- Table options.
