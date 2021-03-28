# OLTP to OLAP sync

## Objective

Build a system to keep an OLAP database (denormalised) in sync with its source OLTP database (normalised) in as real time as possible (eventual consistency).

---

## How to see this POC / demo in action

#### Pre-requisites:

1. Git
1. Internet
1. Mac or Linux
1. Docker must be installed and running

#### Steps

1. Execute `bin/setup.sh` to setup required infrastructure. Needs to be done only once. Inspect the script to learn more.
1. Execute `bin/startup.sh` to startup all the components. Inspect the script to learn more.
1. Once everything is up (check kafka consumer logs using `tail -f logs/kafka-consumer.out`):
    1. `psql -h localhost -p 5432 -U pg -d pg` to connect to the OLTP DB (use password: `pg`)
    1. `psql -h localhost -p 5433 -U pg -d pg` to connect to the OLAP DB (use password: `pg`)
1. Insert related records in student and contact and the inserted records should reflect in OLAP DB.
1. Execute `bin/shutdown.sh` to bring down everything. Next time repeat from Step 2.

---

## Iteration 1

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

[Solution 1](docs/iteration1-sol1.md)

---