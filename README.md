# ALU_DB — Play with SQL Basics (RDBMS)

Peer group engagement activity: a relational school-system database with five entities — **Students, Classroom, Faculty, Courses, Extra_Curricular_Activities** — plus two junction tables for the many-to-many relationships.

Database name: `alu_db` (everyone connects to the same shared MySQL DBMS name).

## Team & roles

| Member | GitHub | Owns |
|---|---|---|
| Gary | gkarenzi-lang | `Students` table |
| Ketia | kmugishate-cell | `Classroom` table |
| Nicia | (add username) | `Faculty` table |
| Noah | (add username) | `Courses` table |
| Don | (this repo owner) | `Extra_Curricular_Activities` + junction tables (`Student_Courses`, `Student_Activities`) |

## Build order

1. **Gary & Ketia** first — `Students` and `Classroom` have no dependencies (note: `Students` has an FK to `Classroom`, so Ketia's table should exist before Gary inserts data).
2. **Nicia** — `Faculty`, no dependencies, can run in parallel with step 1.
3. **Noah** — `Courses`, depends on `Faculty` and `Classroom` already existing.
4. **Don** — `Extra_Curricular_Activities` + junction tables, depends on everything above existing.
5. **Whole group together** — relationship check, normalization paragraph, 3 join queries, 1 aggregate query.

## File

`schema.sql` is the single shared file, in required order: `CREATE DATABASE` → all 5 `CREATE TABLE` (dependency order, with PK/FK) → all `INSERT` → all individual `UPDATE`/`DELETE`/`SELECT` (labeled by member name in a comment) → group join/aggregate queries + normalization paragraph.

Don's section (Member E) is fully written. Each other section has a `TODO` comment block describing exactly what to write — see the assignment brief for the full spec.

## How to run it

```sql
SOURCE schema.sql;
```

or paste into MySQL Workbench / CLI connected to the shared DBMS.

## Git rules

- Everyone commits **their own** section directly — no single end-of-project dump.
- One commit per table (or per query for the group section).
- Repo must be public, or shared with the instructor if private.
