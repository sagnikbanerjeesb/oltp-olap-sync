[Back to main README](../README.md)

---

# Iteration 2 - Solution 1

- In this case our existing solution will work out of the box for updates, because we are using upsert queries which will take
care of updating the impacted columns. We just need to update our solution to work with update type of events as well
- For deletes, something like this will work:

    For deletions in student OLTP table:
    ```sql
    DELETE FROM student_contact
    WHERE student_id = <ID of student entry in OLTP DB>
    ```
    For deletions in contact OLTP table:
    ```sql
    DELETE FROM student_contact
    WHERE contact_id = <ID of contact entry in OLTP DB>
     ```

NOTE: Seems like debezium emits a kafka event of null value during deletes (after from the regular DELETE event ofcourse)