# OPTIMIZATION OF QUERY

**NAME:** YAHYA A. G. ALSAEDI  
**TIME:** 4:00 Hours  
**GITHUB:** YahyaAdnan  

---

## OPTIMIZATION OF QUERY

### 1. Problem Identification

The original query had multiple inefficiencies that can cause performance problems, including:

- Choosing all columns (Jobs*, JobCategories*, etc.) which generates pointless information and raises network overhead.
- Using multiple `LEFT JOINs` with filters that will probably be duplicate.
- Using a lot of `LIKE` connotations which are expensive due to lack of indexing.
- Pagination with `LIMIT & OFFSET` is not ideal for big databases.
- Grouping information using `GROUP BY` without any aggregate purpose is unnecessary.

---

### 2. Optimization Changes

#### I. Minimized SELECT Columns

- **Change Made:** Limited the `SELECT` list to only the columns essential for the query's purpose (e.g., `Jobs.id`, `Jobs.name`, `JobCategories.name`, `JobTypes.name`, etc.).
- **Why:** Reducing certain columns reduces memory consumption and data transmission, therefore accelerating query execution. Choosing empty columns wastes computing power and bandwidth.

#### II. Simplified JOIN Conditions

- **Change Made:** Eliminated useless `LEFT JOINs` and kept only those necessary for display or filtering logic.
- **Why:**
  - `LEFT JOIN` increases computational cost by keeping all rows from the left table independent of any match discovery. When feasible, switching to `INNER JOIN` helps to shrink the dataset early in query running.
  - Ensuring indices on join columns (e.g., `Jobs.id`, `JobCategories.id`, `JobTypes.id`) further accelerates join operations.

#### III. Removed Redundant GROUP BY

- **Change Made:** Removed `GROUP BY Jobs.id` unless aggregation functions like `COUNT` or `SUM` were required.
- **Why:** If there’s no aggregation, `GROUP BY` is redundant. Removing it avoids unnecessary sorting and grouping operations in the query execution plan.

#### IV. Consolidated LIKE Conditions

- **Change Made:** Reduced several `LIKE` clauses into fewer tests on more relevant columns (e.g., `Jobs.name`, `JobCategories.name`, `JobTypes.name`, `Personalities.name`).
- **Why:**
  - `LIKE '%value%'` scans the entire column for matches, which is slow on large datasets unless indexed.
  - Using fewer conditions reduces the CPU workload. Consideration was also given to using a full-text index or search for optimized text matching.

#### V. Improved Pagination

- **Change Made:** Suggested pagination using indexed cursors instead of `LIMIT` and `OFFSET`.
- **Why:** `LIMIT` with `OFFSET` becomes slower as the `OFFSET` value increases because the database must scan and skip rows. Using an indexed cursor allows the query to directly fetch the next set of rows.

#### VI. Removed Unnecessary Parentheses

- **Change Made:** Eliminated unnecessary parentheses in `WHERE` clauses and `ON` clauses to simplify the search.
- **Why:** Too many parentheses could confound query analyzers, making execution plans more difficult to understand and debug.

#### VII. Full-Text Search Optimization

- **Change Made:** Replaced multiple `LIKE '%value%'` conditions with a single `MATCH()` clause using full-text search indexes on relevant columns such as `Jobs.name`, `Jobs.description`, `JobCategories.name`, and `JobTypes.name`.
- **Why:** `LIKE '%value%'` cannot utilize normal indexes, making it ineffective for big datasets. Full-text search using `MATCH()` uses specialized full-text indexes to greatly minimize CPU and disk I/O. It also provides relevance scores, helping better rank results.

---

### 3. Expected Improvements

- **Minimized SELECT columns:** Reduced data transfer and memory usage.
- **Simplified JOINs:** Faster join operations and execution.
- **Consolidated LIKE filters:** Reduced CPU workload on text matching.
- **Removed GROUP BY:** Avoided unnecessary grouping overhead.
- **Optimized Pagination:** Efficient handling of large datasets.
- **Added Indexes:** Faster lookups for join/filter columns.

This optimized query strikes a balance of scalability, speed, and readability for current and future use scenarios. Pagination is improved, and major speed enhancements are achieved by lowering unnecessary calculations through the use of indices.
