# Next steps

## Syncing updates when there is a LEFT JOIN

#### Assumption:

- Same tables structure as iteration 2
- However, the join query now uses LEFT JOIN instead of INNER JOIN

#### Goal:

- Changes made to key columns which impact the left join should reflect in the OLAP DB.

#### Example:

Join query:

```sql
SELECT
  student.student_id as student_id,
  contact.contact_id as contact_id,
  student.name as name,
  contact.contact_number as contact_number
FROM student
LEFT JOIN contact
  ON student.student_id = contact.student_id
```

Current state of tables:

OLTP TABLE: student

| student_id | name |
| --- | --- |
| 1 | Dan |

OLTP TABLE: contact

| contact_id | student_id (FK) | contact_number |
| --- | --- | --- |

OLAP TABLE: student_contact

| student_id | contact_id | name | contact_number |
| --- | --- | --- | --- |
| 1 | <null> | Dan | <null> |

Now if an entry related to student_id 1 is added to contact table:

| contact_id | student_id (FK) | contact_number |
| --- | --- | --- |
| 1 | 1 | 123 |

The OLAP TABLE: student_contact should now look like:

| student_id | contact_id | name | contact_number |
| --- | --- | --- | --- |
| 1 | 1 | Dan | 123 |

#### Solution:

- We'll figure out the potentially impacted rows in the OLAP DB
    - student_id is the JOIN key in the contact table
    - So all rows in the OLAP Table having the same OLD and NEW student_id (same because we have an equal clause
    in the join condition) may be potentially impacted
    - *Delete all such rows from OLAP Table:
        ```sql
        DELETE FROM student_contact WHERE student_id = 1
        ```
      *Above query needs to be run twice: once for old student_id and again for new student_id.
    - *Upsert based on student_id = 1:
        ```sql
        SELECT ...
        FROM student LEFT JOIN contact ON student.student_id = contact.student_id
        WHERE contact.student_id = 1
        ```
        ```sql
        INSERT INTO ... ON CONFLICT ...
        ```
      *Above query needs to be run twice: once for old student_id and again for new student_id.
      