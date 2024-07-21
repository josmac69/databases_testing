# Row Chaining
- Row chaining occurs when a row is too large to fit into a single data block. 
- This situation can arise when tables contain columns with large data types such as `VARCHAR2`, `CLOB`, 

## Mechanism:
- The row is split into multiple pieces.
- The initial part of the row is stored in one data block.
- Pointers are used to link subsequent parts of the row that are stored in other blocks.

## Row Migration
Row migration happens when a row that initially fits into a block is updated, and the updated row size exceeds the free space available in the original block. 
- The entire row is moved to a new block with enough space to accommodate it.
- The original block keeps a pointer to the new block containing the migrated row.
- This pointer mechanism ensures that access to the row remains consistent through its original block location.

## Impact on Performance
- Chaining: Requires multiple I/O operations to read the entire row, as parts of the row are spread across multiple blocks.
- Migration: Similarly involves additional I/O to follow the pointer from the original block to the new block.

### Identifying Chained and Migrated Rows
Oracle provides a way to identify chained and migrated rows using the `ANALYZE` command and querying specific data dictionary views:

```sql
ANALYZE TABLE table_name LIST CHAINED ROWS INTO chained_rows_table;
```
Specified `chained_rows_table` will then contain details of the chained and migrated rows.

### Preventive Measures:
- Choosing an Appropriate Block Size: Selecting a block size that matches the typical row size can reduce the occurrence of row chaining.
- Proper Table Design: Normalizing tables and avoiding very wide tables can help minimize row chaining.
- Regular Maintenance: Periodic reorganization of tables and indexes (using tools like `DBMS_REDEFINITION`) can help address issues of row migration and chaining.

## Storage Parameters and Settings
Oracle allows configuration of certain storage parameters that can influence how row chaining and migration are handled:

- PCTFREE: This parameter specifies the percentage of space to leave free in each block for future updates. A higher `PCTFREE` value can help reduce row migration by reserving more space for row expansion.

```sql
CREATE TABLE example_table (
    id NUMBER,
    data VARCHAR2(4000)
) PCTFREE 20;
```

- PCTUSED: This parameter specifies the minimum percentage of used space that Oracle maintains for a block. Blocks with a used space percentage below `PCTUSED` are considered for insertion of new rows.

### Handling LOB Data
Large Object (LOB) data types (e.g., `BLOB`, `CLOB`) are handled differently to optimize storage:
- Out-of-line Storage: By default, LOBs are stored out-of-line, meaning they are stored in separate LOB segments rather than within the main table's data blocks.
- Inline Storage: For smaller LOBs, Oracle can store LOB data inline within the same block as the table row, reducing I/O overhead.
