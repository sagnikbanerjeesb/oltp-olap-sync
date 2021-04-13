[Back to main README](../README.md)

---

# Iteration 3 - Solution 1

#### Example:

Join query:

```sql
SELECT
  student.student_id as student_id,
  contact.contact_id as contact_id,
  student.name as name,
  contact.contact_number as contact_number
FROM student
INNER JOIN contact
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
| 1 | 1 | 123 |

OLAP TABLE: student_contact

| student_id | contact_id | name | contact_number |
| --- | --- | --- | --- |
| 1 | 1 | Dan | 123 |

If the student_id of the entry in contact table changes to something else, say 100:

| contact_id | student_id (FK) | contact_number |
| --- | --- | --- |
| 1 | 100 | 123 |

Then the entry in OLAP table (student_contact) should vanish.

#### Solution

- Whenever there is a change to any key column (a column impacting join criteria),
first delete all such entries from the OLAP DB based on the PREVIOUS value of the PK column.
In this example:  
    ```sql
    DELETE FROM student_contact WHERE contact_id = 1
    ```
- Upsert entries corresponding to the NEW value of the PK column.
In this example:
    ```sql
    SELECT ...
    FROM student INNER JOIN contact ON student.student_id = contact.student_id
    WHERE contact.contact_id = 1
    ```
    ```sql
    INSERT INTO ... ON CONFLICT ...
    ```
- Although the contact_id is same in DELETE and SELECT statements for this example, but it could have
been different if the change was in the student_id column of the student table. This solution would
have worked in that scenario as well.