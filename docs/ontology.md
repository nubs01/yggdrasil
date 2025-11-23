# People Knowledge Graph – Data Model & Ontology

This document defines the data model and ontology for a people‑centric knowledge graph (relationships, locations, life events, interests, etc.). It is **implementation‑agnostic** (no code) and is intended to guide schema design and application behavior.

---

## 1. Core Entities (Tables)

The system is represented using a small set of core tables:

1. **`knowledge_bases`** – logical containers for independent graphs (per user or project)
2. **`nodes`** – vertices in the graph (persons, locations, events, interests, groups, notes)
3. **`edges`** – relationships between nodes
4. **`facts`** – audit log and raw assertion store (first stop for new information)
5. **`node_types` / `node_type_fields`** – registry of allowed node types and their data fields
6. **`edge_types` / `edge_type_fields`** – registry of allowed edge types and their data fields

### 1.1 `knowledge_bases` Table

**Purpose:** Represents a single logical knowledge graph. All `nodes`, `edges`, and `facts` belong to exactly one knowledge base.

| Column        | Type        | Description                                           | Allowed / Example Values |
| ------------- | ----------- | ----------------------------------------------------- | ------------------------ |
| `id`          | UUID        | Unique identifier for the knowledge base.             | Any valid UUID           |
| `name`        | TEXT        | Short name for the knowledge base.                    | e.g., `"Personal Graph"` |
| `slug`        | TEXT        | URL‑friendly identifier (optional but recommended).   | e.g., `"personal"`       |
| `description` | TEXT        | Longer description of the knowledge base.             | Optional                 |
| `owner_id`    | UUID / TEXT | Identifier of the owning user or account (app‑level). | Optional                 |
| `created_at`  | TIMESTAMP   | Creation timestamp.                                   |                          |
| `updated_at`  | TIMESTAMP   | Last update timestamp.                                |                          |

**Rules / notes:**

* Every `node`, `edge`, and `fact` **MUST** reference a `knowledge_bases.id`.
* A knowledge base is an independent graph; cross‑KB relationships are **not** allowed.

### 1.2 `nodes` Table

**Purpose:** Represents all entities in the graph.

| Column              | Type         | Description                                                | Allowed / Example Values              |
| ------------------- | ------------ | ---------------------------------------------------------- | ------------------------------------- |
| `id`                | UUID         | Unique identifier for the node.                            | Any valid UUID                        |
| `knowledge_base_id` | UUID (FK)    | Knowledge base this node belongs to.                       | References `knowledge_bases.id`       |
| `type`              | TEXT (enum)  | High‑level class of node.                                  | Registered in `node_types`            |
| `label`             | TEXT         | Human‑readable label (name, title).                        | e.g., `"Alice Smith"`, `"Boston, MA"` |
| `data`              | JSON / JSONB | Type‑specific properties (see per‑type schema guidelines). | Varies by `type`                      |
| `created_at`        | TIMESTAMP    | Creation timestamp.                                        |                                       |
| `updated_at`        | TIMESTAMP    | Last update timestamp.                                     |                                       |

**Rules / notes:**

* `knowledge_base_id` is **required**; each node belongs to exactly one knowledge base.
* `type` **SHOULD** correspond to a row in `node_types` for the same knowledge base (or a shared global registry).

### 1.3 `edges` Table

**Purpose:** Represents relationships between nodes.

| Column              | Type         | Description                                                | Allowed / Example Values        |
| ------------------- | ------------ | ---------------------------------------------------------- | ------------------------------- |
| `id`                | UUID         | Unique identifier for the edge.                            | Any valid UUID                  |
| `knowledge_base_id` | UUID (FK)    | Knowledge base this edge belongs to.                       | References `knowledge_bases.id` |
| `type`              | TEXT (enum)  | Relationship type.                                         | Registered in `edge_types`      |
| `from_id`           | UUID (FK)    | Source node ID.                                            | References `nodes.id`           |
| `to_id`             | UUID (FK)    | Target node ID.                                            | References `nodes.id`           |
| `data`              | JSON / JSONB | Relationship metadata (strength, timestamps, notes, etc.). | Varies by `type`                |
| `created_at`        | TIMESTAMP    | Creation timestamp.                                        |                                 |

**Rules / notes:**

* `knowledge_base_id` is **required** and must match the `knowledge_base_id` of both `from_id` and `to_id`.
* `type` **SHOULD** correspond to a row in `edge_types` for the same knowledge base (or a shared global registry).
* Directed edges; symmetric relationships are represented as two edges.

### 1.4 `facts` Table

**Purpose:** Acts as an **audit log** and a **raw assertion store** for new information. Facts may be:

* User‑entered
* Imported from external sources
* Derived from previous facts

Facts can later be **materialized** into the `nodes` and `edges` tables.

| Column              | Type        | Description                                                            | Allowed / Example Values                          |
| ------------------- | ----------- | ---------------------------------------------------------------------- | ------------------------------------------------- |
| `id`                | UUID        | Unique identifier for the fact.                                        | Any valid UUID                                    |
| `knowledge_base_id` | UUID (FK)   | Knowledge base this fact belongs to.                                   | References `knowledge_bases.id`                   |
| `subject_id`        | UUID (FK)   | Node this fact is about (may be null for pre‑node facts).              | References `nodes.id` or `NULL`                   |
| `predicate`         | TEXT        | Property or relationship being asserted.                               | e.g., `"birth_date"`, `"likes"`, `"lives_in"`     |
| `object_id`         | UUID (FK)   | Node referenced by this fact (for relationships / node‑to‑node facts). | References `nodes.id` or `NULL`                   |
| `value`             | TEXT        | Literal value for this fact (for scalar properties).                   | ISO dates, strings, etc.                          |
| `value_type`        | TEXT (enum) | Type of `value`.                                                       | `"string"`, `"date"`, `"int"`, `"bool"`, `"json"` |
| `source`            | TEXT        | Origin / provenance (user, import, etc.).                              | e.g., `"user:roshan"`, `"import:csv_2025_01"`     |
| `confidence`        | REAL        | Confidence score in [0,1] (optional).                                  | e.g., `0.95`                                      |
| `created_at`        | TIMESTAMP   | Creation timestamp.                                                    |                                                   |

**Rules / notes:**

* A fact should have **either** (`object_id` non‑null) **or** (`value` non‑null), but typically not both.
* `knowledge_base_id` is **required** and ensures facts are scoped to a single knowledge base.
* `subject_id` should reference an existing node when available. For early/partial imports, temporary subject placeholders are allowed but materialization should eventually create a real node.
* Facts are **append‑only**. Corrections should be added as new facts with different `value` and optionally lower/higher `confidence`.

### 1.5 `node_types` Table

**Purpose:** Registry of allowed node types and their high‑level constraints, supporting dynamic lookup and UI generation.

| Column              | Type      | Description                                                | Allowed / Example Values                  |
| ------------------- | --------- | ---------------------------------------------------------- | ----------------------------------------- |
| `id`                | UUID      | Unique identifier for the node type definition.            | Any valid UUID                            |
| `knowledge_base_id` | UUID (FK) | Knowledge base this rule applies to (or global if `NULL`). | `NULL` or references `knowledge_bases.id` |
| `name`              | TEXT      | Machine name of the node type (used in `nodes.type`).      | e.g., `"PERSON"`, `"LOCATION"`            |
| `label`             | TEXT      | Human‑readable label.                                      | e.g., `"Person"`                          |
| `description`       | TEXT      | Description of this node type.                             |                                           |
| `is_builtin`        | BOOL      | Whether this is a built‑in/system type.                    | `true` / `false`                          |
| `created_at`        | TIMESTAMP | Creation timestamp.                                        |                                           |

**Rules / notes:**

* `nodes.type` **SHOULD** match `node_types.name`.
* Setting `knowledge_base_id = NULL` can be used for globally shared base types; KB‑specific types override or extend these.

### 1.6 `node_type_fields` Table

**Purpose:** Defines expected data fields for each node type to drive validation and dynamic forms.

| Column           | Type         | Description                                            | Allowed / Example Values                                            |
| ---------------- | ------------ | ------------------------------------------------------ | ------------------------------------------------------------------- |
| `id`             | UUID         | Unique identifier for the field definition.            | Any valid UUID                                                      |
| `node_type_id`   | UUID (FK)    | Reference to `node_types.id`.                          | References `node_types.id`                                          |
| `key`            | TEXT         | JSON field key in `nodes.data`.                        | e.g., `"birth_date"`                                                |
| `value_type`     | TEXT (enum)  | Data type of the value.                                | `"string"`, `"date"`, `"int"`, `"bool"`, `"json"`, `"string_array"` |
| `required`       | BOOL         | Whether this field is required for this type.          | `true` / `false`                                                    |
| `allowed_values` | JSON / JSONB | Optional list/structure of allowed values (for enums). | e.g., `["family","friend"]`                                         |
| `description`    | TEXT         | Description / help text.                               |                                                                     |

**Rules / notes:**

* Application logic can use `node_type_fields` to dynamically render forms and validate `nodes.data`.
* `allowed_values` is typically used when `value_type` is an enum‑like string.

### 1.7 `edge_types` Table

**Purpose:** Registry of allowed edge types and their high‑level constraints.

| Column              | Type      | Description                                                | Allowed / Example Values                  |
| ------------------- | --------- | ---------------------------------------------------------- | ----------------------------------------- |
| `id`                | UUID      | Unique identifier for the edge type definition.            | Any valid UUID                            |
| `knowledge_base_id` | UUID (FK) | Knowledge base this rule applies to (or global if `NULL`). | `NULL` or references `knowledge_bases.id` |
| `name`              | TEXT      | Machine name of the edge type (used in `edges.type`).      | e.g., `"KNOWS"`, `"LIVES_IN"`             |
| `label`             | TEXT      | Human‑readable label.                                      | e.g., `"Knows"`                           |
| `description`       | TEXT      | Description of this edge type.                             |                                           |
| `from_node_type`    | TEXT      | Expected `nodes.type` for `from_id`.                       | e.g., `"PERSON"`                          |
| `to_node_type`      | TEXT      | Expected `nodes.type` for `to_id`.                         | e.g., `"LOCATION"`                        |
| `is_symmetric`      | BOOL      | Whether this edge type is conceptually symmetric.          | `true` / `false`                          |
| `created_at`        | TIMESTAMP | Creation timestamp.                                        |                                           |

**Rules / notes:**

* `edges.type` **SHOULD** match `edge_types.name`.
* `from_node_type` and `to_node_type` guide validation and UI (e.g., only show certain edge types when linking given nodes).

### 1.8 `edge_type_fields` Table

**Purpose:** Defines expected data fields for each edge type to drive validation and dynamic forms.

| Column           | Type         | Description                                            | Allowed / Example Values                                            |
| ---------------- | ------------ | ------------------------------------------------------ | ------------------------------------------------------------------- |
| `id`             | UUID         | Unique identifier for the field definition.            | Any valid UUID                                                      |
| `edge_type_id`   | UUID (FK)    | Reference to `edge_types.id`.                          | References `edge_types.id`                                          |
| `key`            | TEXT         | JSON field key in `edges.data`.                        | e.g., `"since"`, `"strength"`                                       |
| `value_type`     | TEXT (enum)  | Data type of the value.                                | `"string"`, `"date"`, `"int"`, `"bool"`, `"json"`, `"string_array"` |
| `required`       | BOOL         | Whether this field is required for this edge type.     | `true` / `false`                                                    |
| `allowed_values` | JSON / JSONB | Optional list/structure of allowed values (for enums). | e.g., `["crush","friend"]`                                          |
| `description`    | TEXT         | Description / help text.                               |                                                                     |

**Rules / notes:**

* Application logic can use `edge_type_fields` to dynamically render forms and validate `edges.data`.
* Combining `edge_types` and `edge_type_fields` enables a fully data‑driven UI for relationships.

---

## 2. Node Type Schemas

Each node type uses the shared `nodes` table but has type‑specific expectations for `label` and `data`.

### 2.1 PERSON

**`nodes.type = 'PERSON'`**

* **Label**: Required. Preferred format: `"First Last"` or commonly used nickname.
* **Required minimum**: `label`
* **Recommended `data` fields:**

| Key              | Type        | Description                             | Required | Example                             |
| ---------------- | ----------- | --------------------------------------- | -------- | ----------------------------------- |
| `birth_date`     | string      | Date of birth (ISO, `YYYY-MM-DD`).      | Optional | `"1990-05-10"`                      |
| `birth_place_id` | string UUID | Node id of birth location (`LOCATION`). | Optional |                                     |
| `notes`          | string      | Free‑text notes about the person.       | Optional |                                     |
| `gender`         | string      | Optional gender descriptor.             | Optional | `"female"`, `"male"`, `"nonbinary"` |
| `pronouns`       | string      | Pronouns in user‑preferred format.      | Optional | `"she/her"`                         |
| `tags`           | string[]    | Tags for grouping/filtering.            | Optional | `["family", "college"]`             |

**Validation rules (recommended):**

* If `birth_date` present, must be a valid ISO date string `YYYY-MM-DD`.
* If `birth_place_id` present, it **must** reference a node with `type = 'LOCATION'`.

### 2.2 LOCATION

**`nodes.type = 'LOCATION'`**

* **Label**: Required; human‑readable place name (e.g. `"Boston, MA"`, `"MIT Campus"`).
* **Required minimum**: `label`
* **Recommended `data` fields:**

| Key           | Type   | Description                         | Required | Example  |
| ------------- | ------ | ----------------------------------- | -------- | -------- |
| `kind`        | enum   | Location category.                  | Optional | `"city"` |
| `country`     | string | Country name or code.               | Optional | `"US"`   |
| `region`      | string | Region/state/province.              | Optional | `"MA"`   |
| `coordinates` | object | `{ "lat": number, "lon": number }`. | Optional |          |

**Location kind enum (suggested):**

* `city`
* `country`
* `venue`
* `neighborhood`
* `address`
* `region`

### 2.3 EVENT

**`nodes.type = 'EVENT'`**

* **Label**: Required; concise description of the event (e.g. `"Alice & Bob Wedding 2023"`).
* **Required minimum**: `label`, at least one of `date`, `start_date` or `end_date` if known.
* **Recommended `data` fields:**

| Key          | Type   | Description                            | Required | Example            |
| ------------ | ------ | -------------------------------------- | -------- | ------------------ |
| `kind`       | enum   | Event category.                        | Optional | `"birthday_party"` |
| `date`       | string | Single date (ISO) if event is one day. | Optional | `"2023-08-10"`     |
| `start_date` | string | Start date (ISO) for multi‑day events. | Optional | `"2023-08-10"`     |
| `end_date`   | string | End date (ISO) for multi‑day events.   | Optional | `"2023-08-12"`     |
| `notes`      | string | Additional event notes.                | Optional |                    |

**Event kind enum (suggested):**

* `birthday`
* `birthday_party`
* `wedding`
* `anniversary`
* `move`
* `new_job`
* `graduation`
* `breakup`
* `other`

### 2.4 INTEREST

**`nodes.type = 'INTEREST'`**

* **Label**: Required; the name of the interest (e.g. `"Jazz"`, `"D&D"`, `"Sushi"`).
* **Required minimum**: `label`
* **Recommended `data` fields:**

| Key        | Type   | Description            | Required | Example   |
| ---------- | ------ | ---------------------- | -------- | --------- |
| `category` | enum   | Interest category.     | Optional | `"hobby"` |
| `notes`    | string | Free‑text description. | Optional |           |

**Interest category enum (suggested):**

* `hobby`
* `genre`
* `food`
* `sport`
* `media`
* `topic`
* `other`

### 2.5 GROUP

**`nodes.type = 'GROUP'`**

* **Label**: Required; group name (e.g. `"Nanu Family"`, `"College Roommates"`).
* **Required minimum**: `label`
* **Recommended `data` fields:**

| Key     | Type   | Description                      | Required | Example    |
| ------- | ------ | -------------------------------- | -------- | ---------- |
| `kind`  | enum   | Group category.                  | Optional | `"family"` |
| `notes` | string | Description or membership notes. | Optional |            |

**Group kind enum (suggested):**

* `family`
* `friends`
* `coworkers`
* `organization`
* `online_community`
* `other`

### 2.6 NOTE

**`nodes.type = 'NOTE'`**

* **Label**: Required; short summary of the note.
* **Required minimum**: `label`
* **Recommended `data` fields:**

| Key    | Type     | Description              | Required | Example |
| ------ | -------- | ------------------------ | -------- | ------- |
| `body` | string   | Full note text.          | Optional |         |
| `tags` | string[] | Tags for classification. | Optional |         |

---

## 3. Edge Type Ontology

`edges.type` defines semantics of the relationship between `from_id` and `to_id`. All edges share the same base columns but have type‑specific expectations for `from_id`, `to_id`, and `data`.

### 3.1 Edge Types (enum)

Suggested set:

**Person ↔ Person**

* `KNOWS`
* `FRIEND_OF`
* `PARTNER_OF`
* `PARENT_OF`
* `LIKES` (when `to_id` is PERSON)
* `DISLIKES` (when `to_id` is PERSON)

**Person ↔ Interest**

* `LIKES` (when `to_id` is INTEREST)
* `DISLIKES`

**Person ↔ Location**

* `LIVES_IN`
* `FROM`
* `VISITED`

**Person ↔ Event**

* `ATTENDED`
* `INVOLVED_IN`

**Event ↔ Location**

* `OCCURRED_AT`

**Person ↔ Group**

* `MEMBER_OF`

Additional types may be added but should follow the same style and be documented.

### 3.2 Per‑Type Edge Rules

For each edge type, the following table defines **expected node types** and suggested `data` keys.

#### 3.2.1 KNOWS

* **Semantics:** Person A knows Person B.
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'PERSON'`
* **Symmetry:** Typically represented as two edges: `A -> B` and `B -> A`.
* **Recommended `data` fields:**

| Key       | Type   | Description                           |
| --------- | ------ | ------------------------------------- |
| `since`   | string | Approximate start date of connection. |
| `context` | string | How they met (school, work, etc.).    |

#### 3.2.2 FRIEND_OF

* Same constraints as `KNOWS`, but implies a closer relationship.
* Often also symmetric (two directed edges).

**Recommended `data` fields:**

| Key         | Type   | Description                          |
| ----------- | ------ | ------------------------------------ |
| `since`     | string | Approximate date friendship started. |
| `closeness` | int    | 1–5 rating of closeness (optional).  |

#### 3.2.3 PARTNER_OF

* **Semantics:** Romantic partner or spouse.
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'PERSON'`
* **Symmetry:** Should typically exist as `A -> B` and `B -> A`.

**Recommended `data` fields:**

| Key       | Type   | Description                               |
| --------- | ------ | ----------------------------------------- |
| `since`   | string | Date relationship started (ISO).          |
| `married` | bool   | Whether they are married.                 |
| `status`  | enum   | `"together"`, `"separated"`, `"divorced"` |

#### 3.2.4 PARENT_OF

* **Semantics:** A is a parent of B.
* **Node constraints:**

  * `from_id.type = 'PERSON'` (parent)
  * `to_id.type = 'PERSON'` (child)

**Recommended `data` fields:**

| Key       | Type   | Description                               |
| --------- | ------ | ----------------------------------------- |
| `adopted` | bool   | Whether this is an adoptive relationship. |
| `notes`   | string | Additional details.                       |

#### 3.2.5 LIKES (Person → Person or Interest)

* **Semantics:** A likes B (person or interest).
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type in {'PERSON', 'INTEREST'}`

**Recommended `data` fields:**

| Key        | Type   | Description                                             |
| ---------- | ------ | ------------------------------------------------------- |
| `kind`     | enum   | `"crush"`, `"friend"`, `"favorite"`, `"platonic"`, etc. |
| `strength` | int    | 1–5 rating of how strong this preference is.            |
| `since`    | string | Since when (if known).                                  |

#### 3.2.6 DISLIKES

* Mirror of `LIKES` but negative.
* **Node constraints:** Same as `LIKES`.

**Recommended `data` fields:**

| Key        | Type   | Description              |
| ---------- | ------ | ------------------------ |
| `strength` | int    | 1–5 rating of intensity. |
| `since`    | string | Since when (if known).   |
| `reason`   | string | Optional explanation.    |

#### 3.2.7 LIVES_IN

* **Semantics:** Person currently or historically lives in a location.
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'LOCATION'`

**Recommended `data` fields:**

| Key          | Type   | Description                                  |
| ------------ | ------ | -------------------------------------------- |
| `since`      | string | Start date of residence (ISO).               |
| `until`      | string | End date of residence (if no longer there).  |
| `is_primary` | bool   | Whether this is the primary current address. |

#### 3.2.8 FROM

* **Semantics:** Person is originally from a location (birthplace or "grew up in").
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'LOCATION'`

**Recommended `data` fields:**

| Key     | Type   | Description                       |
| ------- | ------ | --------------------------------- |
| `kind`  | enum   | `"birthplace"`, `"grew_up"`, etc. |
| `notes` | string | Additional details.               |

#### 3.2.9 VISITED

* **Semantics:** Person visited a location.
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'LOCATION'`

**Recommended `data` fields:**

| Key     | Type   | Description                                |
| ------- | ------ | ------------------------------------------ |
| `date`  | string | Visit date (ISO) or approximate.           |
| `times` | int    | Approximate count of visits.               |
| `notes` | string | Additional context (vacation, work, etc.). |

#### 3.2.10 ATTENDED

* **Semantics:** Person attended an event.
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'EVENT'`

**Recommended `data` fields:**

| Key     | Type   | Description                                                          |
| ------- | ------ | -------------------------------------------------------------------- |
| `role`  | enum   | `"host"`, `"guest"`, `"officiant"`, `"organizer"`, `"speaker"`, etc. |
| `notes` | string | Additional details.                                                  |

#### 3.2.11 INVOLVED_IN

* **Semantics:** Person involved in an event in a non‑attendance role (e.g., subject of the event, organizer behind the scenes).
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'EVENT'`

**Recommended `data` fields:**

| Key     | Type   | Description                           |
| ------- | ------ | ------------------------------------- |
| `role`  | string | Free‑form description of involvement. |
| `notes` | string | Additional details.                   |

#### 3.2.12 OCCURRED_AT

* **Semantics:** Event occurred at a location.
* **Node constraints:**

  * `from_id.type = 'EVENT'`
  * `to_id.type = 'LOCATION'`

**Recommended `data` fields:**

| Key     | Type   | Description                              |
| ------- | ------ | ---------------------------------------- |
| `notes` | string | Any extra detail (room, building, etc.). |

#### 3.2.13 MEMBER_OF

* **Semantics:** Person is a member of a group.
* **Node constraints:**

  * `from_id.type = 'PERSON'`
  * `to_id.type = 'GROUP'`

**Recommended `data` fields:**

| Key     | Type   | Description                             |
| ------- | ------ | --------------------------------------- |
| `since` | string | When membership started.                |
| `role`  | string | E.g. `"admin"`, `"member"`, `"leader"`. |

---

## 4. Workflow: Facts → Graph Materialization

### 4.1 Ingesting New Information

1. **User input / external source** creates a new fact (row in `facts`).
2. Fact includes: `subject_id` (if known), `predicate`, and either `object_id` or `value`.
3. `source` and `confidence` are stored to track provenance and reliability.

### 4.2 Materialization Rules (Examples)

Examples of how facts map into `nodes`/`edges`:

* `predicate = "birth_date"`, `subject_id` = person node, `value` = date → update `PERSON.data.birth_date`.
* `predicate = "likes"`, `subject_id` = person A, `object_id` = person B → create `LIKES` edge from A to B.
* `predicate = "lives_in"`, `subject_id` = person, `object_id` = location node → create `LIVES_IN` edge.

Materialization can be:

* **On write**: immediately after fact creation.
* **Batch**: periodic job that scans recent facts and updates the graph.

In both cases, the `facts` table remains the **source of truth** for historical information and conflict resolution.

---

## 5. General Design Principles

* **Small, composable ontology**: prefer a small set of node and edge types with flexible metadata over many rigid tables.
* **JSON `data` fields**: allow type‑specific attributes without schema churn; enforce constraints at the application level.
* **Enums where stable**: constrain types, kinds, and statuses using enumerations for consistency.
* **Symmetric relationships**: represent symmetry explicitly as paired directed edges where needed.
* **Facts first**: new information is always captured in `facts`, then materialized into `nodes` and `edges` for fast query and visualization.
* **Forward‑compatible**: adding new node/edge types or additional `data` keys should not require breaking changes to existing data.
