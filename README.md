# ExSeedify: A Seeder Application

Create a Phoenix application and implement features to seed data and send email.

## What will we build

A phoenix app with 2 endpoints to manage users.

## Requirements

- We should store users and salaries in PostgreSQL database.
- Each user has a name and can have multiple salaries.
- Each salary should have a currency.
- Every field defined above should be required.
- One user should at most have 1 salary active at a given time.
- All endpoints should return JSON.
- A readme file with instructions on how to run the app.

### Seeding the database

- `mix ecto.setup` should create database tables, and seed the database with 20k users, for each user it should create 2 salaries with random amounts/currencies.
- The status of each salary should also be random, allowing for users without any active salary and for users with just 1 active salary.
- Must use 4 or more different currencies. Eg: USD, EUR, JPY and GBP.
- Users’ name can be random or populated from the result of calling list_names/0 defined in the ExSeedify module.

### Tasks

1. 📄 Implement an endpoint to provide a list of users and their salaries
    - Each user should return their `name` and active `salary`.
    - Some users might have been offboarded (offboarding functionality should be considered out of the scope) so it’s possible that all salaries that belong to a user are inactive. In those cases, the endpoint is supposed to return the salary that was active most recently.
    - This endpoint should support filtering by partial user name and order by user name.
    - Endpoint: `GET /users`

2. 📬 Implement an endpoint that sends an email to all users with active salaries
    - The action of sending the email must use any external API and mock it.
    - ⚠️ This library doesn’t actually send any email so you don’t necessarily need internet access to work on your challenge.
    - Endpoint: `POST /invite-users`

## How to run the application

You will need the following installed:

- Elixir >= 1.15.7-otp-26
- Postgres >= 14.5

Check out the `.tool-versions` file for a concrete version combination we ran the application with. Using [asdf](https://github.com/asdf-vm/asdf) you could install their plugins and them via `asdf install`.

### To start your Phoenix server

- Run `mix setup` to install, setup dependencies and setup the database
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Implementation

## Technical Results:
Benchmark results:
```bash
Calculating statistics...
Formatting results...

Name               ips        average  deviation         median         99th %
mix_task      406.08 K        2.46 μs   ±467.97%        2.42 μs        2.79 μs
```

Result Log:
```elixir
Seeding of users and salaries tables completed in 1978 millisecond.
```

### Database Schema
1. User schema
```
 ______________________________________________
|   Column    |              Type              |
|-------------+--------------------------------+
| id          | bigint                         |
| name        | character varying(255)         |
| inserted_at | timestamp(0) without time zone |
| updated_at  | timestamp(0) without time zone |
|______________________________________________|
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "salaries" CONSTRAINT "salaries_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
```

2. Salary Schema
```
______________________________________________
|   Column    |              Type              |
|-------------+--------------------------------+
| id          | bigint                         |
| currency    | character varying(255)         |
| active      | boolean                        |
| amount      | integer                        |
| inserted_at | timestamp(0) without time zone |
| updated_at  | timestamp(0) without time zone |
|______________________________________________|
Indexes:
    "salaries_pkey" PRIMARY KEY, btree (id)
    "idx_unique_active_salary_per_user" UNIQUE, btree (user_id) WHERE active = true
    "salaries_user_id_index" btree (user_id)
Foreign-key constraints:
    "salaries_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
```

### API EndPoint
1. `GET /users` - Returns the paginated list of users with active salaries.
  - **Response**
   ```
   {
    "entries": [
        {
            "user_name": "user1",
            "user_id": 111,
            "salary": {
                "amount": 10000,
                "currency": "USD"
            }
        },
        {
            "user_name": "user1",
            "user_id": 201,
            "salary": {
                "amount": 25000,
                "currency": "GBP"
            }
        }
    ],
    "page_number": 1,
    "page_size": 2,
    "total_entries": 20003,
    "total_pages": 10002
   }
   ```
   - Added pagination to iterate through a large dataset.
   - I have added Limit-offset based pagination in this assignment for the sake of simplicity, the cursor-based pagination is optimal for infinite scrolling.
   - To fetch users with active salary - 
     - Added virtual field `active_salary` for selecting and merging into the `User` struct.
     - The salary is ordered by the `active` and `updated_at` fields to handle both cases, first when the user has at least one active salary, second if not then select the recently updated salary.
     - **Filters**
       - order_by: username
       - username: "Jos"
       - page: 11
       - page_size: 20

3. `POST /invite-users` - Send email invitations to users with active salaries.
  - **Response**
  ```elixir
  {
    "message": "Invitation emails sent successfully."
  }
  ```
  - Send emails only to users with active salaries and not offboarded users, hence only fetching users with active salaries and sending them email invitations.
  - Implemented a `retry` mechanism on the `send_email` API call and set the value at the macro level, in the future we can move it to the config level. 
