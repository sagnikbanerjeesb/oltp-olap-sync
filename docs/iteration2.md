[Back to main README](../README.md)

---

# Iteration 2

### Assumptions

- We are dealing with the same table structure used in iteration 1

### Goal

1. Updates to non key columns (PKs, join columns) in OLTB DB, in this case: name and contact_number should reflect in
the OLAP DB
1. Deletion of row

#### Solution:

[Solution 1](./iteration2-sol1.md)

### OUT OF SCOPE

1. Robust failure handling
1. Parallelism
1. Handling primary key changes
1. Handling updates to join columns