[Back to main README](../README.md)

---

# Iteration 1

### Assumptions

#### Say we have a source OLTP database like this:

TABLE: student

| student_id | name |
| --- | --- |
| 1 | Dan |
| 2 | Tom |

TABLE: contact

| contact_id | student_id (FK) | contact_number |
| --- | --- | --- |
| 1 | 1 | 123 |
| 2 | 1 | 456 |
| 3 | 2 | 789 |

#### The target OLAP database should then look like this:

TABLE: student_contact

| student_id | contact_id | name | contact_number |
| --- | --- | --- | --- |
| 1 | 1 | Dan | 123 |
| 1 | 2 | Dan | 456 |
| 2 | 3 | Tom | 789 |

Query to populate this table:
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

#### Goals

1. The solution should be able to populate the OLAP DB from the existing data in OLTP DB. (Initial load)
1. Whenever there is an insert in the OLTP DB, it should reflect in the OLAP DB.
    1. NOTE: As part of iteration 1, we'll focus only on creation of rows. Update and delete are OUT OF SCOPE

#### Solution:

[Solution 1](./iteration1-sol1.md)

#### OUT OF SCOPE:

1. Robust failure handling
1. Parallelism
1. Handling primary key changes
1. Handling update and delete operations