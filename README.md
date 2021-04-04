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

### [Iteration 1](docs/iteration1.md)

### [Iteration 2](docs/iteration2.md)

---